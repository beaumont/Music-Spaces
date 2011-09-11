class FixAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :connect_friends, :boolean, :default => true
  end

  def self.down
    remove_column :accounts, :connect_friends
  end
end
