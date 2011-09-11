class AlterActivities3 < ActiveRecord::Migration
  def self.up
    add_column :activities, :created_at, :datetime, :null => false
    add_column :activities, :updated_at, :datetime, :null => false
    
  end
  def self.down
    remove_column :activities, :created_at
    remove_column :activities, :updated_at
  end
end