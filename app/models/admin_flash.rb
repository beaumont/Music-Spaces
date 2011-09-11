# == Schema Information
# Schema version: 20081006211752
#
# Table name: admin_flashes
#
#  id         :integer(11)     not null, primary key
#  message    :string(255)
#  start      :datetime
#  end        :datetime
#  priority   :integer(11)     default(0)
#  shown      :boolean(1)      default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#  message_ru :string(255)
#

class AdminFlash < ActiveRecord::Base
  xss_terminate :except => [:message]
  translates :message
  
  @@cache_key = "flash_message_array"
  @@last_loaded = nil
  @@messages = []
  cattr_accessor :messages
  
  CACHE_FOR = 12.hours
  
  def self.expire_cache!
    Rails.cache.delete(@@cache_key)
  end
  
  def AdminFlash.messages
    Rails.cache.fetch(@@cache_key, :ttl => CACHE_FOR){ @@messages }
  end
    
  def AdminFlash.messages=(ary)
    @@messages = ary
    Rails.cache.write(@@cache_key, @@messages, :ttl => CACHE_FOR)
  end
  
  def self.random_message
    if messages.empty? #@@last_loaded.nil? || Time.now - CACHE_FOR > @@last_loaded
      cond  = "(start is null or start < #{AdminFlash.quote_value(Time.now)})"
      cond += " and (end is null or end > #{AdminFlash.quote_value(Time.now)})"
      cond += " and (shown = #{AdminFlash.quote_value(true)})"
      AdminFlash.messages = AdminFlash.find(:all, :conditions => cond)
      @@last_loaded = Time.now
      logger.debug "AdminFlash loaded #{@@messages.size} elements into cache"
    end
    AdminFlash.messages[ rand(messages.count) ]
  end

end
