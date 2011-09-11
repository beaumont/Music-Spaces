# == Schema Information
# Schema version: 20090211222143
#
# Table name: moderation_events
#
#  id              :integer(11)     not null, primary key
#  user_id         :integer(11)
#  type            :string(255)
#  message         :text
#  reportable_type :string(255)
#  reportable_id   :integer(11)
#  flag_type       :integer(11)     default(0)
#  created_at      :datetime
#  updated_at      :datetime
#  reason          :string(255)
#

# == Schema Information
# Schema version: 20081224151519
#
# Table name: moderation_events
#
#  id              :integer(11)     not null, primary key
#  user_id         :integer(11)
#  type            :string(255)
#  message         :text
#  reportable_type :string(255)
#  reportable_id   :integer(11)
#  flag_type       :integer(11)     default(0)
#  created_at      :datetime
#  updated_at      :datetime
#  reason          :string(255)
#

class Moderation::Report < Moderation::Event
  
  
  def kind
    'Reported'.t
  end
  
  
end
