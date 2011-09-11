class FixingTenseInContentStats < ActiveRecord::Migration
  def self.up
    rename_column :content_stats, :plays, :played
    rename_column :content_stats, :plays_today, :played_today
  end

  def self.down
    rename_column :content_stats, :played, :plays
    rename_column :content_stats, :played_today, :plays_today
  end
end
