# == Schema Information
# Schema version: 20081006211752
#
# Table name: activity_counts
#
#  id               :integer(11)     not null, primary key
#  user_id          :integer(11)     not null
#  activity_type_id :integer(4)
#  total            :integer(6)      default(0), not null
#  unread           :integer(6)      default(0), not null
#

class ActivityCounts < ActiveRecord::Base
end
