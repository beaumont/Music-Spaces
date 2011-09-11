class AddIndexOnContentToFeedEntryActivities < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == 'production' #already there
      add_index :feed_entry_activities, ['activity_id'], :name => 'index_feed_entry_activities_on_activity_id' rescue nil      
      add_index :feed_entry_activities, ['content_type', 'content_id'], :name => 'index_feed_entry_activities_on_content'      
    end
  end

  def self.down
  end
end
