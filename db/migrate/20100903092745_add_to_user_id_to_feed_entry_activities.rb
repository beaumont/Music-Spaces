class AddToUserIdToFeedEntryActivities < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == 'production' #already there
      add_column :feed_entry_activities, :to_user_id, :integer
      add_index :feed_entry_activities, [:to_user_id, :from_user_id]

      FeedEntry.delete_all
      FeedEntryActivity.delete_all
      FeedEntry.migrate_friendfeed_activities({})
    end
  end

  def self.down
  end
end
