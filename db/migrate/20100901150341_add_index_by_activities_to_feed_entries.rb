class AddIndexByActivitiesToFeedEntries < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == 'production' #already there
      execute %Q{
        ALTER TABLE `feed_entry_activities`
        DROP INDEX `index_feed_entry_activities_on_feed_entry_id_and_from_user_id`,
        ADD INDEX index_feed_entry_activities_on_from_user_id_and_feed_entry_id (from_user_id, feed_entry_id)
      }
    end
  end

  def self.down
  end
end
