class AddSelectedFriendCircleToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :friend_circle, :integer
    add_column :accounts, :import_friends, :boolean, :default => true
    add_column :accounts, :import_mine, :boolean, :default => false
  end

  def self.down
    remove_column :accounts, :import_mine
    remove_column :accounts, :import_friends
    remove_column :accounts, :friend_circle
  end
end
