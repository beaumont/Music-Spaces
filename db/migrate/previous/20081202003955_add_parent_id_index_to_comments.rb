class AddParentIdIndexToComments < ActiveRecord::Migration
  def self.up
    add_index :comments, :parent_id
  end

  def self.down
    remove_index :comments, :parent_id
  end
end
