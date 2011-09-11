class UpdateFromCollectionFeedEntriesFlag < ActiveRecord::Migration
  def self.up
    unless RAILS_ENV == 'production' #already there
      ids = CollectionProject.find(:all).map(&:id); nil
      fe_ids = FeedEntryActivity.find(:all, :conditions => {:from_user_id => ids}).map(&:feed_entry_id).uniq; nil
      FeedEntry.update_all('from_collections = 1', ['id in (?)', fe_ids])
    end
  end

  def self.down
  end
end
