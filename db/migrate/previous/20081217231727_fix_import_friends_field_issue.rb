class FixImportFriendsFieldIssue < ActiveRecord::Migration
  def self.up
    rename_column :accounts, :import_friends, :allow_friends
  end

  def self.down
    rename_column :accounts, :allow_friends, :import_friends
  end
end
