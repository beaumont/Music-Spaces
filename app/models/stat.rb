# == Schema Information
# Schema version: 20081006211752
#
# Table name: stats
#
#  id           :integer(11)     not null, primary key
#  content_id   :integer(11)
#  user_id      :integer(11)
#  type         :string(255)
#  value        :string(255)
#  ip           :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  content_type :string(20)
#

class Stat < ActiveRecord::Base
  #skip_caching
  
  KEEP_STATS_FOR = 7.days         # Only delete stats older than __
  SESSION_LENGTH = 5.minutes      # Ignore duplicate hits within this time period

  belongs_to :user
  belongs_to :content, :polymorphic => true

  def self.for(content, limit = nil)
    self.find(:all, :conditions => {:content_id => content.id, :content_type => content.class.to_s}, :order => 'created_at DESC', :limit => limit)
  end

  def self.hit!(opts)
    self.create( model_hash(opts) )
  end

  # If hit recently, don't count as new
  def self.hit_recently?(opts)
    my_opts = opts.clone # Mess with copy, don't modify original
    # Only use IP for session tracking if user_id is of Guest
    my_opts.delete(:ip) unless (my_opts[:user_id].nil? || [0, 1].include?(my_opts[:user_id]))
    session_hits = self.count(:all, :conditions => ["#{hash_to_sql(my_opts)} AND created_at > ?", Time.now.utc - session_time_limit(my_opts)])
    return session_hits > 0
  end

  # Make method so Play can override for tracks
  def self.session_time_limit(anything = {})
    SESSION_LENGTH
  end

  def self.hits_today(opts)
    self.count(:all, :conditions => ["#{hash_to_sql(opts)} AND created_at > ?", Time.now - 24.hours])
  end
  
  # If given a user_id, only clears that user's. Else, clears all users'.
  def self.clear_old!(user_id = nil)
    condition_string = "created_at < #{Stat.quote_value((Time.now - KEEP_STATS_FOR).to_s(:db))}"
    condition_string += " and user_id=#{Stat.quote_value(user_id)}" if user_id
    ActiveRecord::Base.connection.execute("delete from stats where #{condition_string}")
  end

  protected
  
  # Convert a hash of properties into finder search. Can't pass has directly, because need to use > on time
  def self.hash_to_sql(hash)
    valid = valid_keys(hash)
    sql_snips = valid.inject([]) {|sql, key| sql << "stats.#{key} = #{Stat.quote_value(hash[key])}"}
    sql_snips.join(' AND ')
  end

  # Filter out all hash entries that don't have a corresponding model column
  def self.valid_keys(hash)
    if hash[:content]
      hash[:content_id] = hash[:content].id
      hash[:content_type] = hash[:content].class.to_s
    end
    hash.keys.select {|x| Stat.column_names.include?(x.to_s) }
  end
  
  # Start with hash, end with hash containing only model fields as keys
  def self.model_hash(hash)
    good_keys = valid_keys(hash)
    hash.delete_if{|k,v| !good_keys.include?(k)}
  end
  
  
  
  # From console on production, used to get stats for e.g. investor presentations
  def self.site_stats
    puts "================"
    puts "= Kroogi Stats ="
    puts "================\n"
    puts "Total (Active) Users: #{User.active.activated.not_project.count}"
    puts "Total (Active) Projects: #{Project.active.count}"
    puts "Users (Active) signed up in the last two months: #{User.active.not_project.count(:conditions => ['created_at > ?', Time.now - 2.months])}"
    puts "Total Musician Kroogi pages (users with tracks uploaded): #{Track.find(:all, :include => :user).collect{|x| x.user}.uniq.size}"
    puts "----------"
    puts "Total (active) tracks uploaded: #{Track.active.count}"
    puts "----------"
    puts "Total downloads of stand-alone content items: #{Activity.only(:content_download_initiated).size}"
    puts "Total content purchases: #{Activity.only(:content_purchased).size}"
    puts "Total Folders with Downloadables downloads: #{Activity.only(:content_downloaded).size}"
    puts "----------"
    puts "Total inboxes receiving content from other users: #{Inbox.active.size}"
    puts "Total inbox items received: #{Activity.only(:inbox_submission_received).size}"
    puts "Total inbox items accepted: #{Activity.only(:inbox_submission_accepted).size}"
    puts "Inbox acceptance rate: #{"%.03f" % (Activity.only(:inbox_submission_accepted).size.to_f / Activity.only(:inbox_submission_received).size.to_f)}" unless Activity.only(:inbox_submission_received).size.zero?
    puts "================\n"
  end
  
end
