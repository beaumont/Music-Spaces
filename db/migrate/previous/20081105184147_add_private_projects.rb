class AddPrivateProjects < ActiveRecord::Migration
  def self.up
    add_column :users, :is_private, :boolean, :default => false
  end

  def self.down
    remove_column :users, :is_private
  end
end
