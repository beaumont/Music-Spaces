class AlterComments < ActiveRecord::Migration
  def self.up
    remove_column :comments, "parent_id"
    add_column :comments, :parent_id, :integer, :null => true
    add_column :comments, :lft, :integer, :null => true
    add_column :comments, :rgt, :integer, :null => true
  end

  def self.down
    remove_column :comments, "parent_id"
    remove_column :comments, "lft"
    remove_column :comments, "rgt"
  end
end
