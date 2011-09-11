# == Schema Information
# Schema version: 20081216224705
#
# Table name: preferences
#
#  id                   :integer(11)     not null, primary key
#  user_id              :integer(11)     default(1), not null
#  email_notifications  :integer(4)      default(1), not null
#  name_context         :string(255)     default("general")
#  email_locale         :string(255)     default("en")
#  anonymous_stats      :boolean(1)
#  shy_founders_ids     :string(255)
#  show_founders_tab    :boolean(1)      default(TRUE)
#  show_founders_module :boolean(1)      default(TRUE)
#  active_circle_ids    :string(255)     default("--- []")
#  show_last_active     :boolean(1)      default(TRUE)
#  getting_around_open  :boolean(1)      default(TRUE)
#  current_locale       :string(10)
#  email_searchable     :boolean(1)      default(FALSE)
#

class Preference < ActiveRecord::Base
  #skip_caching
  belongs_to :user
  
  # Email settings enumeration
  EMAIL = {:none => 0, :realtime => 1, :digest => 2}
  
  attr_accessor :shy_founders
  
  xss_terminate :except => [:active_circle_ids]
  
  serialize :active_circle_ids, Array
  
  before_save :send_pending_emails
  validates_inclusion_of :fb_like_consolidation, :in => ["always", "never", "ask_me"], :if => Proc.new {|p| !p.fb_like_consolidation.blank?}

  def initialize(attributes = {})
    attributes = (attributes || {}).symbolize_keys
    super(attributes.reverse_merge(:email_searchable => true, :email_notifications => EMAIL[:realtime], :email_locale => I18n.locale))
  end

  def after_create
    # Set default circles
    self.active_circle_ids = user.default_circles 
    self.save!
    
    # Receive own mail
    unless self.user.project?
      receive_emails_for!([self.user.id] + self.user.projects.map(&:id))
      receive_kroogi_notifications_for!([self.user.id] + self.user.projects.map(&:id))
    end
  end

  # TODO: Should be refactored
  def receives_emails_for
    recips = user.things_i_track.email_delivery.tracked_item_is_user.map(&:tracked_item_id)
    recips = User.find(:all, :conditions => {:id => recips}) unless recips.blank?
    return recips.uniq.select {|u| user.is_self_or_owner?(u)}
  end

  def receive_emails_for_user?(uid)
    u = uid.is_a?(User) ? uid : User.find_by_id(uid)
    u && user.is_self_or_owner?(u) && receives_emails_for.include?(u)
  end

  
  # Wrapper to keep existing settings and just add one more
  def also_receive_emails_for(uid)
    u = uid.is_a?(User) ? uid.id : uid
    receive_emails_for!(receives_emails_for.map(&:id) + [u])
  end
  
  # Wrapper to handle logic surrounding Tracking::EmailDelivery creation
  def receive_emails_for!(ids)
    return nil if user.project? 
    project_ids = user.projects.map(&:id) + [user.id]
    tracked_ids = receives_emails_for.map(&:id)
    
    # Remove trackings to projects user no longer follows, or no longer owns
    dead_ids = tracked_ids.select{|t| !project_ids.include?(t) || (ids.nil? || !ids.include?(t))}
    Tracking::EmailDelivery.delete_all ["tracked_item_type='User' and tracked_item_id in (#{dead_ids.join(',')}) and tracking_user_id=?", user.id] unless dead_ids.empty?
    
    return nil if ids.nil?
    
    # Add trackings that don't already exist
    ids.uniq.each do |pid|
      pid = pid.id if pid.is_a?(User)
      if project_ids.include?(pid.to_i) && !tracked_ids.include?(pid)
        Tracking::EmailDelivery.create(:tracking_user_id => user.id, :tracked_item_type => 'User', :tracked_item_id => pid)
      end
    end
    return receives_emails_for
  end

  def receives_kroogi_notifications_for
    recips = user.things_i_track.kroogi_notifications.tracked_item_is_user.map(&:tracked_item_id)
    recips = User.all(:conditions => {:id => recips}) unless recips.blank?
    return recips.uniq.select {|u| user.is_self_or_owner?(u)}
  end

  def receive_kroogi_notifications_for_user?(uid)
    u = uid.is_a?(User) ? uid : User.find_by_id(uid)
    u && user.is_self_or_owner?(u) && receives_kroogi_notifications_for.include?(u)
  end

  # Wrapper to keep existing settings and just add one more
  def also_receive_kroogi_notifications_for(uid)
    u = uid.is_a?(User) ? uid.id : uid
    receive_kroogi_notifications_for!(receives_kroogi_notifications_for.map(&:id) + [u])
  end

  # Wrapper to handle logic surrounding Tracking::EmailDelivery creation
  def receive_kroogi_notifications_for!(ids)
    return nil if user.project?
    project_ids = user.projects.map(&:id) + [user.id]
    tracked_ids = receives_kroogi_notifications_for.map(&:id)

    # Remove trackings to projects user no longer follows, or no longer owns
    dead_ids = tracked_ids.select{|t| !project_ids.include?(t) || (ids.nil? || !ids.include?(t))}
    Tracking::KroogiNotification.delete_all({:tracked_item_type => 'User', :tracked_item_id => dead_ids, :tracking_user_id => user.id}) unless dead_ids.empty?

    return nil if ids.nil?

    # Add trackings that don't already exist
    ids.uniq.each do |pid|
      pid = pid.id if pid.is_a?(User)
      if project_ids.include?(pid.to_i) && !tracked_ids.include?(pid)
        Tracking::KroogiNotification.create(:tracking_user_id => user.id, :tracked_item_type => 'User', :tracked_item_id => pid)
      end
    end
    return receives_kroogi_notifications_for
  end
  
  def shy_founders
    shy_founders_ids.blank? ? [] : shy_founders_ids.split(',').map{|x| x.to_i}
  end
  
  def shy_founders=(input)
    raise "shy_founders can only accept an array or single user" unless input.is_a?(Array) || input.is_a?(User)
    input = [input.id] if input.is_a?(User)
    self.update_attribute(:shy_founders_ids, input.join(','))
  end
  
  def email?
    email_notifications != EMAIL[:none]
  end
  
  def email_digest?
    email_notifications == EMAIL[:digest]
  end
  
  def email_realtime?
    email_notifications == EMAIL[:realtime]
  end

  def send_pending_emails
    # If email notifications was just changed from digest to realtime, send old digest messages
    if email_notifications_changed? && email_notifications_change == [EMAIL[:digest], EMAIL[:realtime]]
      ActivityMail.send_pending_by_user(self.user)
    end
  end

end
