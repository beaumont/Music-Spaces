class SetToUserIdForOldFeedEntryActivities < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == 'production' #already there
      FeedEntryActivity.set_to_user_id
    end
  end

  def self.down
  end
end
