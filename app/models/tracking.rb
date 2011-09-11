# == Schema Information
# Schema version: 20081028193108
#
# Table name: trackings
#
#  id                  :integer(11)     not null, primary key
#  tracking_user_id    :integer(11)
#  tracked_item_id     :integer(11)
#  tracked_item_type   :string(255)
#  type                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  reference_item_id   :integer(11)
#  reference_item_type :string(255)
#

class Tracking < ActiveRecord::Base
  #skip_caching
  belongs_to :tracking_user, :class_name => 'User'
  belongs_to :tracked_item, :polymorphic => true
  belongs_to :reference_item, :polymorphic => true

  named_scope :email_delivery,        :conditions => ['type=?', 'Tracking::EmailDelivery']
  named_scope :site_invitation,       :conditions => ['type=?', 'Tracking::SiteInvitation']
  named_scope :tracked_item_is_user,  :conditions => ['tracked_item_type=?', 'User']
  named_scope :kroogi_notifications,   :conditions => ['type=?', 'Tracking::KroogiNotification']

  
  validates_presence_of :tracked_item_type, :tracked_item_id, :tracking_user_id
end