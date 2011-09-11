# == Schema Information
# Schema version: 20081006211752
#
# Table name: invite_requests
#
#  id               :integer(11)     not null, primary key
#  user_id          :integer(11)
#  circle_id        :integer(11)
#  wants_to_join_id :integer(11)
#  created_at       :datetime
#  updated_at       :datetime
#  state            :string(255)     default("pending")
#  invitation_id    :integer(11)
#

class InviteRequest < ActiveRecord::Base
  include AASM

  belongs_to :user
  alias_method :from_user, :user
  
  belongs_to :wants_to_join, :class_name => 'User'
  alias_method :to_user, :wants_to_join
      
  belongs_to :invitation
  has_one :activity, :as => :content
  
  named_scope :pending,   :conditions => ['state=?', 'pending']
  named_scope :accepted,  :conditions => ['state=?', 'accepted']
  named_scope :rejected,  :conditions => ['state=?', 'rejected']
  named_scope :not_rejected,  :conditions => ['state <> ?', 'rejected']
  named_scope :ordered,       :order => 'created_at desc'

  requests_to_proc = lambda do |thing|
    if thing.is_a?(User)
      {:conditions => {:wants_to_join_id => thing.id}}
    elsif thing.is_a?(UserKroog)
      {:conditions => {:wants_to_join_id => thing.user.id, :circle_id => thing.relationshiptype_id}}
    else raise "Can only request invitation to a user or circle (not damn #{thing.class.name})"
    end
  end

  named_scope :requests_to, requests_to_proc

  aasm_column :state  
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :accepted, :enter => :do_accept
  aasm_state :rejected, :enter => :do_reject

  aasm_event :reject do
    transitions :from => :pending, :to => :rejected
  end

  aasm_event :accept do
    transitions :from => [:pending, :rejected], :to => :accepted
  end

  # Accept the request (that is, send invitation). Sending logic must lie elsewhere, so 
  # Invite before_create accepts any pending requests to no circle, that circle, or further circles
  def do_accept
    InviteRequest.clear_pending_request_activities(self.user, self.wants_to_join)
  end

  # Any necessary logic to deny request here
  def do_reject
    InviteRequest.clear_pending_request_activities(self.user, self.wants_to_join)
  end
  
  
  
  def self.request_invite(user, to_join, circle_id)
    InviteRequest.clear_pending(user, to_join)
    request = InviteRequest.create(:user_id => user.id, :wants_to_join_id => to_join.id, :circle_id => circle_id)
    Activity.send_message(request, user, :sent_getcloser)
  end
  
  
  def circle_name
    wants_to_join.circle_name(self.circle_id)
  end
  
  def wants_to_join_circle
    wants_to_join.circle(self.circle_id)
  end
  
  def is_view_permitted?
    current_actor.is_self_or_owner?(wants_to_join, user)
  end
  
  def self.clear_pending_request_activities(user, to_join, only_these_request_ids = nil)
    if only_these_request_ids.blank?
      Activity.delete_all ['activity_type_id=? and from_user_id=? and user_id=?', Activity::ACTIVITIES[:sent_getcloser][:id], user.id, to_join.id]
    else
      Activity.delete_all ['activity_type_id=? and from_user_id=? and user_id=? and content_id in (?)', Activity::ACTIVITIES[:sent_getcloser][:id], user.id, to_join.id, only_these_request_ids]
    end
  end
  
  # Clear other pending requests, but leave accepted and rejected requests. Clear all activity messages.
  def self.clear_pending(user, to_join)
    xids = InviteRequest.find(:all, :conditions => ['user_id=? and wants_to_join_id=? and state=?', user.id, to_join.id, 'pending']).map(&:id)
    return true if xids.empty?
    
    InviteRequest.delete_all ['id in (?)', xids]
    # InviteRequest.clear_pending_request_activities(user, to_join, xids)
    InviteRequest.clear_pending_request_activities(user, to_join)
  end
  
end
