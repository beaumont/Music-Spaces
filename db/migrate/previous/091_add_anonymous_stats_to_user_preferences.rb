class AddAnonymousStatsToUserPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :anonymous_stats, :boolean, :default => false
  end

  def self.down
    remove_column :preferences, :anonymous_stats
  end
end
