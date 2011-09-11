class Facebook::UserDetails < ActiveRecord::Base
  set_table_name :fb_user_details

  belongs_to :basic_user, :class_name => "BasicUser", :foreign_key => "user_id"
  belongs_to :advanced_user, :class_name => "AdvancedUser", :foreign_key => "user_id"
  belongs_to :kroogi_user, :class_name => "User", :foreign_key => "user_id"

  belongs_to :user, :class_name => "Facebook::User", :foreign_key => "user_id"
  belongs_to :page, :class_name => "Facebook::Page", :foreign_key => "user_id"

  #named scope
  named_scope :fb_connected_user, :conditions => 'is_fb_connected = 1'
  named_scope :kd_user,           :conditions => 'is_kd_user = 1'
  named_scope :active,            :include => :user, :conditions => ['users.state=?', 'active']

  named_scope :with_fb_ids, lambda{ |fb_ids| {:conditions => {:fb_user_id => fb_ids} } }

  def self.find_connected_user(fb_user_id, opts = {})
    conditions = finder_params(fb_user_id, opts)
    details = self.find(:first, :conditions => conditions)
    if details
      if details.basic_user
        details.basic_user
      elsif details.advanced_user
        details.advanced_user
      end
    end
  end

  def self.find_user(fb_user_id, opts = {})
    conditions = finder_params(fb_user_id, opts)
    details = self.find(:first, :conditions => conditions)
    details.user if details
  end

  def self.find_page(fb_page_id, opts = {})
    conditions = finder_params(fb_page_id, opts)
    details = self.find(:first, :conditions => conditions)
    details.page if details
  end

  def maybe_update(fb_session_key)
    update_attribute(:fb_session_key, fb_session_key) if self.fb_session_key != fb_session_key
    self.user.update_attribute(:state, "active") if self.user.state != "active"
  end

  def self.finder_params(fb_user_id, opts)
    conditions = {:fb_user_id => fb_user_id}
    conditions.merge!({:is_kd_user=> opts[:is_kd_user]}) if opts[:is_kd_user]
    conditions.merge!({:is_fb_connected=> opts[:is_fb_connected]}) if opts[:is_fb_connected]
    conditions
  end
  
end
