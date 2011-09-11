class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities, :options => 'TYPE=MyISAM', :force => true do |t|
        t.column :login,                     :string, :limit => 30, :null => false
        t.column :user_id,                   :integer, :null => false
        t.column :for_user_id,               :integer
        t.column :activity_count_id,         :integer, :limit => 4, :default => 1, :null => false
        t.column :status,                    :integer, :limit => 4, :default => 1, :null => false
        t.column :db_file_id,                :integer
    end
    
    create_table :activitycounts, :options => 'TYPE=MyISAM', :force => true do |t|
        t.column :user_id,                   :integer, :null => false
        t.column :activity_count_id,         :integer, :limit => 4, :default => 0, :null => false
        t.column :total,                     :integer, :limit => 6, :default => 0, :null => false
        t.column :unread,                    :integer, :limit => 6, :default => 0, :null => false
    end
  end

  def self.down
    drop_table :activities
  end
end
