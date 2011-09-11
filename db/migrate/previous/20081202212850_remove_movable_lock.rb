class RemoveMovableLock < ActiveRecord::Migration

  def self.up
    remove_column :movable_version, :lock
  end

  def self.down
    add_column :movable_version, :lock, :boolean, :default => false
  end
end
