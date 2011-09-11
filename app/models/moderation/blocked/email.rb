# == Schema Information
# Schema version: 20090211222143
#
# Table name: blocked_emails
#
#  id                 :integer(11)     not null, primary key
#  email              :string(255)     default(""), not null
#  created_at         :datetime
#  updated_at         :datetime
#  created_by_id      :integer(11)
#  updated_by_id      :integer(11)
#  blocked_because_of :string(255)
#

# == Schema Information
# Schema version: 20081224151519
#
# Table name: blocked_emails
#
#  id                 :integer(11)     not null, primary key
#  email              :string(255)     not null
#  created_at         :datetime
#  updated_at         :datetime
#  created_by_id      :integer(11)
#  updated_by_id      :integer(11)
#  blocked_because_of :string(255)
#

class Moderation::Blocked::Email < ActiveRecord::Base
  set_table_name 'blocked_emails'
  serialize :blocked_because_of, Array
  xss_terminate :except => [:blocked_because_of]

  # When saving emails, automatically strip out weird characters
  def email=(str)
    self['email'] = self.class.base_email(str)
  end
  
  # For matching purposes, remove all . characters and strip out the + from email+something@place.com
  def self.base_email(eml)
    (user, domain) = eml.to_s.split('@')
    return '' unless user && domain
    clean_user = user.gsub('.', '').gsub(/\+.*/, '')
    "#{clean_user}@#{domain}"
  end
  
  # Find or create by email
  def self.add(user)
    existing = email_is_blocked?(user.email)
    existing ||= self.new(:email => user.email, :blocked_because_of => [])
    existing.blocked_because_of << user.id
    existing.save

    return existing
  end
  
  # Returns true if the given email, once converted into its base form, is in the block table
  def self.email_is_blocked?(unknown)
    self.find_by_email( base_email(unknown) )
  end
  
  # There are multiple users per email, so if two users were blocked with same email, the email record should record both of them
  # If one is restored, it will be removed from the email block. If the last user is restored, the email block will be lifted.
  def self.clear_blocked_user(user)
    existing = email_is_blocked?( user.email )
    return true unless existing
    
    new_blockers = existing.blocked_because_of - [user.id]
    if new_blockers.empty?
      existing.destroy
    else
      existing.update_attribute(:blocked_because_of, new_blockers)
    end
  end

end
