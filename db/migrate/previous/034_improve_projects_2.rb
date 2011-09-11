class ImproveProjects2 < ActiveRecord::Migration
  def self.up
     drop_table :projects_users
     create_table :projects_users, :options => 'TYPE=MyISAM', :id => false, :force => true do |t|
        t.column :user_id, :integer, :null => false
        t.column :project_id, :integer, :null => false
        t.column :created_at, :datetime, :null => false
        t.column :created_by_id, :integer, :default => 0, :null => false
    end 
    add_index :projects_users, [:user_id, :project_id], :primary => true
  end

  def self.down
      create_table :projects_users, :options => 'TYPE=MyISAM', :force => true do |t|
          t.column :user_id, :integer, :null => false
          t.column :project_id, :integer, :null => false
          t.column :created_at, :datetime, :null => false
          t.column :created_by_id, :integer, :default => 0, :null => false
      end
  end
end