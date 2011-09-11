class CategorizeFeedEntries < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == 'production' #there asynchronously
      FeedEntry.categorize_feed_entries('log')
    end
  end

  def self.down
  end
end
