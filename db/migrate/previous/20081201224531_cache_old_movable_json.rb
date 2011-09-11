class CacheOldMovableJson < ActiveRecord::Migration
  def self.up
    add_column :movable_version, :last_movable_data_id, :integer
  end

  def self.down
    remove_column :movable_version, :last_movable_data_id
  end
end
