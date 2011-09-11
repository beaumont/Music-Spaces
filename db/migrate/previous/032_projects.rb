class Projects < ActiveRecord::Migration
  def self.up
      create_table :projects_users, :options => 'TYPE=MyISAM', :force => true do |t|
          t.column :user_id, :integer, :null => false
          t.column :project_id, :integer, :null => false
          t.column :created_at, :datetime, :null => false
          t.column :created_by_id, :integer, :default => 0, :null => false
      end
      rename_table :activitycounts, :activity_counts
      
      add_column :contents,     :created_by_id, :integer, :default => 0, :null => false
      add_column :comments,     :created_by_id, :integer, :default => 0, :null => false
      add_column :favorites,    :created_by_id, :integer, :default => 0, :null => false
      add_column :votes,        :created_by_id, :integer, :default => 0, :null => false
      add_column :taggings,     :created_by_id, :integer, :default => 0, :null => false
      add_column :profile_questions, :created_by_id, :integer, :default => 0, :null => false

      add_column :contents,     :updated_by_id, :integer, :default => 0, :null => false
      add_column :profile_questions, :updated_by_id, :integer, :default => 0, :null => false
      
      add_column :profile_questions, :created_at, :datetime, :default => '1970-01-01', :null => false
      add_column :profile_questions, :updated_at, :datetime, :default => '1970-01-01', :null => false
      
      ProfileQuestion.update_all ['created_at = ?', Time.now]
      ProfileQuestion.update_all ['updated_at = ?', Time.now]
      
  end

  def self.down
    drop_table :projects_users
    rename_table :activity_counts, :activitycounts

    remove_column :contents, :created_by_id
    remove_column :comments, :created_by_id
    remove_column :favorites, :created_by_id
    remove_column :votes, :created_by_id
    remove_column :taggings, :created_by_id
    remove_column :profile_questions, :created_by_id
    
    remove_column :contents, :updated_by_id
    remove_column :profile_questions, :updated_by_id

    remove_column :profile_questions, :created_at
    remove_column :profile_questions, :updated_at
  end
end