class AddUserStates < ActiveRecord::Migration
  def self.up
    add_column :users, :state, :string, :default => 'active'
    remove_column :users, :status
  end

  def self.down
    remove_column :users, :state
    add_column :users, :status, :integer, :default => 1
  end
end
