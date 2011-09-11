class AddingStatIndices < ActiveRecord::Migration
  def self.up
    add_index :stats, :created_at
  end

  def self.down
    remove_index :stats, :created_at
  end
end
