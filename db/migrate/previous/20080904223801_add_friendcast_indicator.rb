class AddFriendcastIndicator < ActiveRecord::Migration
  def self.up
    add_column :activities, :friendcast, :boolean, :default => false
    
    puts "Cycling through all activities, this may take a while..."
    Activity.only( Activity.type_group(:content_river) ).find(:all, :include => :content).each do |a|
      a.update_attribute(:friendcast, true) if a.content.is_a?(Content) && !a.user.is_self_or_owner?(a.content.user)
      a.update_attribute(:friendcast, true) if a.activity_type_id == Activity::ACTIVITIES[:created_project][:id] && !a.user.is_self_or_owner?(a.content)
    end
  end

  def self.down
    remove_column :activities, :friendcast
  end
end
