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

class Tracking::SiteInvitation < Tracking
  alias_method :user, :tracked_item
  alias_method :invited_by, :tracking_user
  alias_method :invite, :reference_item
  
  def self.find_inviter_of(u)
    #TODO: user types should be smaller, let's see later
    self.find(:first, :conditions => {:tracked_item_id => u.id, :tracked_item_type => ['User', 'BasicUser', 'AdvancedUser', 'Project']})
  end
  
  def validate
    errors.add_to_base("Tracked item must be a User or Project for Tracking::SiteInvitation".t) unless self.tracked_item.is_a?(User)
  end
end
