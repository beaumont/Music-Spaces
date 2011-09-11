# == Schema Information
# Schema version: 20081216224705
#
# Table name: globalize_countries
#
#  id                     :integer(11)     not null, primary key
#  code                   :string(2)
#  english_name           :string(255)
#  date_format            :string(255)
#  currency_format        :string(255)
#  currency_code          :string(3)
#  thousands_sep          :string(2)
#  decimal_sep            :string(2)
#  currency_decimal_sep   :string(2)
#  number_grouping_scheme :string(255)
#

require "open-uri"
class Movable::Country < ActiveRecord::Base
  set_table_name 'movable_countries'

  has_many :operators, :foreign_key => 'movable_country_id', :class_name => 'Movable::Operator'
  has_many :numbers, :through => :operators, :class_name => 'Movable::Number'

  MOVABLE_BASE_URL = 'http://smszamok.ru/common/js/kroogi_ops.js'
  #MOVABLE_BASE_URL = 'http://smszamok.ru/common/js/ops_nevaline.js'
  
  named_scope :current, lambda { 
    {:conditions => {:version => Movable::Version.current}}
  }
  
  # A wrapper to get all current countries, updating if none available and alerting if still having problems
  def self.get_current
    # Get the coutries
    all = Movable::Country.find(:all, :include => :numbers)
    
    # If empty, try to fix it
    if all.empty?
      Movable::Country.update_data_from_movable!
      all = Movable::Country.find(:all, :include => :numbers)
      AdminNotifier.async_deliver_admin_alert("There are ZERO current movable countries, even after running update_data_from_movable! (inline, unfortunatley)") if all.empty?
    end
        
    # Return the coutries
    return all
  end
  
  def self.update_data_from_movable!(force = false)
    update_attempted = Time.now
    Movable::Version.attempt!(update_attempted)

    # Grab the data from the movable site
    data = get_data_from_movable
    if data.blank?
      raise "ERROR GRABBING MOVABLE DATA FROM #{MOVABLE_BASE_URL} ! Is it password protected now?"
    end
    
    if !force && Movable::Version.data_is_stale?(data)
      # Stale data, don't bother touching db
      
      # Mark success if no errors, even if skipped db update because of cache
      Movable::Version.success!(update_attempted)
      
      return "Movable's data identical to cache. Last new data was imported at #{Movable::Version.last_update}"
    else
      begin
        # Import data into our db
        version = Movable::Version.next
        Movable::Country.import_from_movable(data, version, update_attempted)
        
        # Mark success if no errors, even if skipped db update because of cache
        Movable::Version.success!(update_attempted)
      rescue Exception => e
        AdminNotifier.async_deliver_admin_alert("Error updating movable countries: #{e.message}<br/>From: #{e.backtrace}")
        Movable::Country.delete_all ['version=?', version]
      end
    end

    # Admin notification -- if last succeeded is set to now if cache, so this can only happen if new data. 
    # In that case, only notify me every few hours
    if update_attempted - Movable::Version.last_succeeded > 3.hours
      AdminNotifier.async_deliver_admin_alert("Movable hasn't successfully updated in quite a while. Last success was #{Movable::Version.last_succeeded}.")
    end
    
    true
  end
  
  # If you pass in a collection of countries uses that (helps with concurrency issues)
  def self.dump_to_js(all, options)
    all ||= Movable::Country.get_current
    arr = {}
    all.each do |c|
      arr.merge!({c.id => c.attributes.except(:id).merge(:operators => Movable::Operator.dump_to_js(c.operators, options))})
    end
    return arr.to_json
  end
    
  # Given the JSON-parsed data from movable, import it into the database.
  # This whole thing is here to do it in three sql statements, rather than one per object
  # Using straight rails (obj.create, looping obj.association << subobj.new) we lock the DB for too long for performance
  def self.import_from_movable(data, version, timestamp)
    # Get an array of countries, one of operators, and one of numbers, with all associations in place
    countries = []; operators = []; numbers = []
    data['country'].each do |country_data|
      # Build up the movable country in memory
      countries << extract_hash_matching_db(country_data, Movable::Country.column_names, version)
      
      # For each country, build up it's constituent operators and numbers
      country_data['Operators'].each do |operator_data|
        operators << extract_hash_matching_db(operator_data, Movable::Operator.column_names, version, country_data['Id'])
        operator_data['Numbers'].each do |number_data|
          numbers << extract_hash_matching_db(number_data, Movable::Number.column_names, version, operator_data['Id'])
        end
      end
    end
    
    # Now stick those arrays directly in the database w/ a mass insert
    Movable::Country.transaction do
      
      # Remove any with soon-to-be-current version, just in case
      Movable::Country.delete_all ['version=?', version]
      
      # Add the new records to the database
      ActiveRecord::Base.connection.execute( movable_insert_sql(countries, Movable::Country ) )

      # Now we need to update the operator data to point to the correct ID
      translation = Movable::Country.find(:all, :conditions => {:version => version}).inject({}) {|hash, x| hash.merge!(x.mid.to_i => x.id) }
      operators.each {|o| o['movable_country_id'] = translation[o['movable_country_id'].to_i] }
      
      ActiveRecord::Base.connection.execute( movable_insert_sql(operators, Movable::Operator) )
      
      # Now do the same for number data
      translation = Movable::Operator.find(:all, :conditions => {:version => version}).inject({}) {|hash, x| hash.merge!(x.mid.to_i => x.id) }
      numbers.each do |n| 
        n['movable_operator_id'] = translation[n['movable_operator_id'].to_i]
        n['formatted_cost'] = '%.02f' % (n['cost'].to_i / 100.0) unless n['cost'].blank?
      end

      ActiveRecord::Base.connection.execute( movable_insert_sql(numbers,   Movable::Number  ) )
      
      # Now that we have all data in db, increment the Movable::Version to point to the new stuff
      Movable::Version.set!(version, timestamp, data)
      
      # Now that we have the new version set, remove all other records
      clear_old_movable_data!(version)
    end
  end
  
  def self.get_data_from_movable
    data = open(MOVABLE_BASE_URL).read
    data.gsub!(/^.*?\{/, '{') # remove variable assignment at beginning
    data.gsub!(/;.*?$/, '')   # remove semicolon at end
    return ActiveSupport::JSON.decode(data)
  rescue Exception => e
    # AdminNotifier.async_deliver_admin_alert("Error parsing JSON to update movable countries: #{e}")
    return nil
  end
  
  # Remove data from the previous iteration
  def self.clear_old_movable_data!(v = nil)
    current = v || Movable::Version.current
    Movable::Country.delete_all ['version<>?', current]
    Movable::Operator.delete_all ['version<>?', current]
    Movable::Number.delete_all ['version<>?', current]
  end
  
  # Given a hash of data and an array of column names, return a hash with just the given columns (w/ id converted to mid)
  def self.extract_hash_matching_db(data, columns, version, movable_parent_id = nil)
    hash = {'version' => version}

    # Get the basic data
    data.each {|key, value| columns.include?(key.underscore) ? hash[key.underscore] = value : nil}

    # Rename movable's ID to mid (keep id col free for rails, but keep tracking MIDs)
    hash['mid'] = hash.delete('id').to_i

    # Handle associating each with its parent
    if movable_parent_id && movable_id_col = columns.detect{|x| x.match(/movable_.+?_id/)}
      hash[movable_id_col] = movable_parent_id.to_i
    end
    
    return hash
  end
  
  def self.movable_insert_sql(data, klass)
    # Prep the data structures
    columns = (klass.column_names - ['id']).sort!
    values = []
    
    # Create an array of sql strings w/ data in proper order
    data.each do |instance|
      instance_values = columns.inject([]) {|array, name| array << instance[name]}
      values << '(' + instance_values.collect{|x| Movable::Country.quote_value(x) }.join(', ') + ')'
    end
    
    # Create actual SQL statement
    "INSERT INTO #{klass.table_name} (#{columns.join(',')}) VALUES #{values.join(', ')};"
  end
  
end
