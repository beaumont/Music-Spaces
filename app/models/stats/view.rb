# == Schema Information
# Schema version: 20081006211752
#
# Table name: stats
#
#  id           :integer(11)     not null, primary key
#  content_id   :integer(11)
#  user_id      :integer(11)
#  type         :string(255)
#  value        :string(255)
#  ip           :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  content_type :string(20)
#

class Stats::View < Stat
end
