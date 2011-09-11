class AddFeedFilters < ActiveRecord::Migration
  def self.up
    add_column :preferences, :show_feed_music, :boolean, :default => true, :null => false
    add_column :preferences, :show_feed_pics, :boolean, :default => true, :null => false
    add_column :preferences, :show_feed_texts, :boolean, :default => true, :null => false
    add_column :preferences, :show_feed_videos, :boolean, :default => true, :null => false
    add_column :preferences, :show_feed_people, :boolean, :default => true, :null => false
    add_column :preferences, :show_feed_dirs, :boolean, :default => true, :null => false
  end

  def self.down
  end
end
