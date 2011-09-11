class CorrectMessagesStatusesFromZero < ActiveRecord::Migration
  def self.up
    Activity.all(:conditions => {:activity_type_id => Activity.limit_type_to(Activity.type_group(:private_feed)), :status => 0 }).
            each {|a| [a.id, a.update_attribute(:status, Status::READ)]}
  end

  def self.down
  end
end
