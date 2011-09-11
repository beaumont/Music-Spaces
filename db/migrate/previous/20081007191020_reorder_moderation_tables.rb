class ReorderModerationTables < ActiveRecord::Migration
  def self.up
    rename_table :reports, :moderation_events
  end

  def self.down
    rename_table :moderation_events, :reports
  end
end
