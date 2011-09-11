class TrackLastAttemptedMovableUpdate < ActiveRecord::Migration
  def self.up
    add_column :movable_version, :last_update_attempted, :datetime
    add_column :movable_version, :last_update_succeeded, :datetime
    add_column :movable_version, :cached_data_digest, :string
    remove_column :movable_version, :last_movable_data_id
  end

  def self.down
    remove_column :movable_version, :last_update_attempted
    remove_column :movable_version, :last_update_succeeded
    remove_column :movable_version, :cached_data_digest
    add_column :movable_version, :last_movable_data_id, :integer
  end
end
