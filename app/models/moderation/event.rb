# == Schema Information
# Schema version: 20081224151519
#
# Table name: moderation_events
#
#  id              :integer(11)     not null, primary key
#  user_id         :integer(11)
#  type            :string(255)
#  message         :text
#  reportable_type :string(255)
#  reportable_id   :integer(11)
#  flag_type       :integer(11)     default(0)
#  created_at      :datetime
#  updated_at      :datetime
#  reason          :string(255)
#

class Moderation::Event < ActiveRecord::Base
  set_table_name 'moderation_events'
  serialize :reason, Array
  xss_terminate :except => [:reason]
  
  named_scope :reports, :conditions => ['type=?', 'Moderation::Report']
  named_scope :blocks, :conditions => ['type=?', 'Moderation::Block']
  named_scope :uniq_items, :group => 'reportable_type, reportable_id'

  named_scope :for_users, :conditions => {:reportable_type => ['BasicUser', 'AdvancedUser', 'Project']}
  named_scope :for_content, :conditions => {:reportable_type => Content::VALID_SUBCLASS_NAMES}

  named_scope :order, lambda { |order_str| {:order => order_str}}
  
  belongs_to :user
  alias_method :reporter, :user
  belongs_to :reportable, :polymorphic => true
  
  after_create :notify_admins

  REPORT_CATEGORIES = [
    'Copyright violation',
    'Offensive or sexually explicit content',
    'Individual or group attacks'
  ]
  
  BLOCK_CATEGORIES = [
    'Copyright violation',
    'Sexually explicit content',
    'Individual or group attacks',
    'TOS agreement violation',
  ]

  USER_CATEGORIES = [
    'Copyright violation',
    'Offensive or sexually explicit content',
    'Individual or group attacks',
    'Unauthorized use of login credentials',
    'Forging or impersonating any person or identity',
    'Unauthorized solicitation',
    'Unlawful activities',
    'TOS agreement violation',
  ]

  # Wrapper around categories to translate them as necessary -- can't translate on strings directly, b/c only translated once when class is loaded
  def self.categories(type)
    case type
    when :report then REPORT_CATEGORIES.collect{|x| [x.t, x]}
    when :block then BLOCK_CATEGORIES.collect{|x| [x.t, x]}
    when :block_user then USER_CATEGORIES.collect{|x| [x.t, x]}
    else []
    end
  end

  # Not invidual events, but the uniq items they happened to
  def self.items(type = nil)
    all_items = self.find(:all, :group => 'reportable_type, reportable_id').map(&:reportable)

    to_be_returned = if type.nil? then all_items
    elsif type == :user           then all_items.select{|x| x.is_a?(User)}
    elsif type == :content        then all_items.select{|x| x.is_a?(Content)}
    else                               all_items
    end
    return to_be_returned
  end


  # Return the user responsible for the thing being reported, regardless of what kind of thing it is
  def responsible_user
    if reportable.is_a?(User)
      reportable
    elsif reportable.is_a?(Content)
      reportable.user
    else
      nil
    end
  end
    
  def kind
    'Generic Event'.t
  end
  
  # Reason is now an array -- stringify it prettily
  def display_reason
    return nil if reason.to_s.blank?
    reason.to_sentence
  end
  
  def validate
    errors.add_to_base("Must have an attached 'reportable' item".t) unless reportable
    errors.add_to_base("Must either select or describe the reason for your report".t) if reason.blank? && message.blank?
    if self.instance_of?(Moderation::Report)
      errors.add_to_base("Invalid report reason selected".t) if reason && !reason.all?{|r| REPORT_CATEGORIES.include?(r)}
    end
    if self.instance_of?(Moderation::Block)
      if reportable.is_a?(User)
        errors.add_to_base("Invalid block reason selected".t) if reason && !reason.all?{|r| USER_CATEGORIES.include?(r)}
      else
        errors.add_to_base("Invalid block reason selected".t) if reason && !reason.all?{|r| BLOCK_CATEGORIES.include?(r)}
      end
    end
  end
  
  protected
  
  def notify_admins
    if reportable.is_a?(Content)
      content_url = "http://#{reportable.user.login}.#{APP_CONFIG.hostname}/content/show/#{reportable.id}"
      msg = "#{reportable.user.display_name}'s \"#{reportable.title || 'Untitled'}\", #{content_url} for #{display_reason || 'an unknown reason.'}"
    else
      user = reportable
      user_url = "http://#{user.login}.#{APP_CONFIG.hostname}"
      msg = "kroogi user #{user.title_long}, #{user_url} for #{display_reason || 'an unknown reason.'}"
    end
    msg += "\nMessage from #{reporter.login}: #{self.message}" if self.message
    if self.is_a?(Moderation::Report)
      msg  = "#{reporter.login} has reported " + msg
    elsif self.is_a?(Moderation::Block)
      msg  = "#{reporter.login} has blocked " + msg
    end
    AdminNotifier.async_deliver_kroogi_admin_alert(msg)
  end
  
end
