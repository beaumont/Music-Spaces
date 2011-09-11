# == Schema Information
# Schema version: 20081216224705
#
# Table name: movable_version
#
#  id                    :integer(11)     not null, primary key
#  current               :integer(11)     default(1)
#  last_updated          :datetime
#  last_updated_from_ip  :string(255)
#  last_update_attempted :datetime
#  last_update_succeeded :datetime
#  cached_data_digest    :string(255)
#

require 'digest/md5'
class Movable::Version < ActiveRecord::Base
  # Note:
  # :last_update_attempted - last time update attempted, regardless of outcome
  # :last_update_succeeded - last time update attempted with no errors (may have skipped updating db due to stale data)
  # :last_updated - last time the data in the db was changed
  
  set_table_name 'movable_version'
  
  MAX = 999999.freeze
  cattr_accessor :version

  def self.data_cache=(txt)
    version.update_attribute(:cached_data_digest, Digest::MD5.hexdigest(txt.to_s))
  end

  def self.clear_cache!
    version.update_attribute(:cached_data_digest, nil)
  end

  def self.current
    version.current
  end
  
  # Check data param (presumably retreived from Movable site) against our cached version. Is it worth updating the db?
  def self.data_is_stale?(data)
    return true if data.blank?
    return false if version.cached_data_digest.blank?
    return Digest::MD5.hexdigest(data.to_s) == version.cached_data_digest
  end
  
  # Return the next version. Roll over at MAX and start from 1 again (don't want to forget this process,
  # only to find numbers rolling over years from now)
  def self.next
    cur_ver = current
    cur_ver == MAX ? 1 : (cur_ver + 1)
  end

  def self.previous
    cur_ver = current
    cur_ver == 1 ? MAX : (cur_ver - 1)
  end

  # When saving the version, send an admin alert if the version calculated doesn't match the most recent version present in the db
  def after_save
    db_says_current_is = Movable::Country.find(:first, :order => 'version desc')
    return true unless db_says_current_is
    db_says_current_is = db_says_current_is.version
    db_says_current_is = 1 if db_says_current_is == MAX
    unless self.current == db_says_current_is
      AdminNotifier.async_deliver_admin_alert("Movable::Version's current version (#{self.current}) is NOT the most recent version in the db (#{db_says_current_is}) -- the country list for sending SMS messages is most likely snafued and will need manual fixing.")
    end
  end
  
  # Sets version, cache, and last_updated and last_updated_from_ip
  def self.set!(n, timestamp, data = nil)
    version.update_attributes(:current => n, :last_updated => timestamp)
    self.data_cache = data if data
    if RAILS_ENV == 'production'
      current_ip = `curl -s http://169.254.169.254/latest/meta-data/public-ipv4`.to_s.strip
      unless current_ip.blank? || version.last_updated_from_ip.blank? || current_ip == version.last_updated_from_ip
        AdminNotifier.async_deliver_admin_alert("Movable data has just been updated from #{current_ip}, although the last update was from #{version.last_updated_from_ip}.  Perhaps you should notify Boris @ Movable of the change.")
      end
      version.update_attributes(:last_updated_from_ip => current_ip)
    end
  end
  
  def self.attempt!(timestamp)
    version.update_attribute(:last_update_attempted, timestamp)
  end
  
  def self.success!(timestamp)
    version.update_attribute(:last_update_succeeded, timestamp)
  end
  
  def self.last_succeeded
    version.last_update_succeeded
  end
  
  def self.last_update
    version.last_updated
  end
  
  protected
  
  def self.version
    @@version ||= Movable::Version.find(:first)
    @@version ||= Movable::Version.create
  end
end
