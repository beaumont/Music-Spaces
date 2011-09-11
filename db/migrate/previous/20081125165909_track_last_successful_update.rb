class TrackLastSuccessfulUpdate < ActiveRecord::Migration
  def self.up
    add_column :movable_version, :last_updated, :datetime, :nil => true
  end

  def self.down
    remove_column :movable_version, :last_updated
  end
end
