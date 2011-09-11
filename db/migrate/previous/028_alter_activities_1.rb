class AlterActivities1 < ActiveRecord::Migration
  def self.up
    remove_column :activities, :login
    remove_column :activities, :for_user_id
    add_column :activities, :from_user_id, :integer
    add_column :activities, :from_username, :string, :limit => 30
    add_column :activities, :content_id, :integer
    add_column :activities, :content_type, :integer
    
  end
  def self.down
    remove_column :activities, :content_id
    remove_column :activities, :content_type
  end
end