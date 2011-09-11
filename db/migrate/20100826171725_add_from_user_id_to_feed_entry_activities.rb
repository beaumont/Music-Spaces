class AddFromUserIdToFeedEntryActivities < ActiveRecord::Migration
  def self.up
    add_column :feed_entry_activities, :from_user_id, :integer rescue nil     
    add_index :feed_entry_activities, [:feed_entry_id, :from_user_id] rescue nil

  end

  def self.down
  end
end
