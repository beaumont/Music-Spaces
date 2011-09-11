class AddStateChangedOnDateToContentAndUser < ActiveRecord::Migration
  def self.up
    add_column :users, :state_changed_at, :datetime
    add_column :contents, :state_changed_at, :datetime
  end

  def self.down
    remove_column :users, :state_changed_at, :datetime
    remove_column :contents, :state_changed_at, :datetime    
  end
end
