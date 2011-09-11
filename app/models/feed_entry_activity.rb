#  create_table "feed_entry_activities", :force => true do |t|
#    t.column "feed_entry_id",    :integer, :null => false
#    t.column "activity_type_id", :integer
#    t.column "content_id",       :integer
#    t.column "content_type",     :string
#    t.column "activity_id",      :integer, :null => false
#    t.column "position",         :integer
#    t.column "from_user_id",     :integer
#    t.column "to_user_id",       :integer
#  end
#
class FeedEntryActivity < ActiveRecord::Base
  belongs_to :activity
  belongs_to :feed_entry 
  belongs_to :content, :polymorphic => true
  belongs_to :from_user
  named_scope :to_user,  lambda {|who| { :conditions => ['to_user_id = ?', who]} }
  named_scope :for_content, lambda { |thing| { :conditions => {:content_type => Activity.content_types(thing), :content_id => thing.id} } }
  named_scope :from_user,  lambda {|who| { :conditions => ['from_user_id = ?', who]} }

  def self.set_to_user_id(condition = "")
    self.connection.update("update feed_entry_activities fea inner join feed_entries fe on fe.id = fea.feed_entry_id set fea.to_user_id = fe.to_user_id " + condition)
  end

  #substract existing follower's friend feed activities from passed activities and returns result  
  def self.substract_existing(activities, follower)
    existing = Set.new(self.to_user(follower).all(:conditions => {:activity_id => activities.map(&:id)}).map(&:activity_id))
    activities.reject {|a| existing.include?(a.id)}
  end
end
