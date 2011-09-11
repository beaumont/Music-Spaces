# == Schema Information
# Schema version: 20090211222143
#
# Table name: feedbacks
#
#  id            :integer(11)     not null, primary key
#  user_id       :integer(11)
#  complaint     :text
#  environment   :text
#  ip            :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  sent_from     :string(255)
#  junk          :boolean(1)
#  created_by_id :integer(11)     default(0), not null
#  updated_by_id :integer(11)     default(0), not null
#

# == Schema Information
# Schema version: 20090115130316
#
# Table name: feedbacks
#
#  id            :integer(11)     not null, primary key
#  user_id       :integer(11)
#  complaint     :text
#  environment   :text
#  ip            :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  sent_from     :string(255)
#  junk          :boolean(1)
#  created_by_id :integer(11)     default(0), not null
#  updated_by_id :integer(11)     default(0), not null
#

class Feedback < ActiveRecord::Base
  belongs_to :user
  has_many :replies, :class_name => 'Pvtmessage', :foreign_key => :parent_id
  
  validates_presence_of :complaint, :on => :create, :message => "can't be blank"
end
