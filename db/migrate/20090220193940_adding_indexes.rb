class AddingIndexes < ActiveRecord::Migration
  def self.up
    add_index :activities, [:from_user_id, :created_at]
  end

  def self.down
    remove_index :activities, [:from_user_id, :created_at]
  end
end
