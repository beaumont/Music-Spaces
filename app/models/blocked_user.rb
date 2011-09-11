class BlockedUser < ActiveRecord::Base

  validates_uniqueness_of :blocked_user_id, :scope => [:blocked_by_id, :blocked_type]

  BLOCKED_TYPES = {
    :pvt_message => "Pvtmessage",
    :comment => "Comment"
  }

  named_scope :by_pvt, :conditions => {:blocked_type => BLOCKED_TYPES[:pvt_message]}
  named_scope :by_comment, :conditions => {:blocked_type => BLOCKED_TYPES[:comment]}

  belongs_to :blocked_user, :class_name => "User"

end