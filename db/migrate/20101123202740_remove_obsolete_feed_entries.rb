class RemoveObsoleteFeedEntries < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == 'production' #there asynchronously
      FeedEntry.remove_obsolete_feed_entries
    end
  end

  def self.down
  end
end
