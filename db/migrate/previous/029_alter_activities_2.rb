class AlterActivities2 < ActiveRecord::Migration
  def self.up
    remove_column :activities, :content_type
    add_column :activities, :content_type, :string, :limit => 20
    
  end
  def self.down
  end
end