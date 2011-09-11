class AddLockToUpdate < ActiveRecord::Migration
  def self.up
    add_column :movable_version, :lock, :boolean, :default => false
  end

  def self.down
    remove_column :movable_version, :lock
  end
end
