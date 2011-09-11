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

class Tracking::KroogiNotification < Tracking

end
