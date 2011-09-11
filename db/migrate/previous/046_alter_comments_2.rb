class AlterComments2 < ActiveRecord::Migration
  def self.up
    add_column :comments, :avatar_id, :integer
  end

  def self.down
    remove_column :comments, :avatar_id
  end
end
