# == Schema Information
# Schema version: 20081006211752
#
# Table name: favorites
#
#  id             :integer(11)     not null, primary key
#  user_id        :integer(11)
#  favorable_type :string(30)
#  favorable_id   :integer(11)
#  created_at     :datetime
#  updated_at     :datetime
#  created_by_id  :integer(11)     default(0), not null
#

class Stats::Favorite < Stat
end
