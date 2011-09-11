class ImproveProjects < ActiveRecord::Migration
  def self.up
      add_column :contents,     :author_id, :integer, :default => 0, :null => false
      add_column :profile_questions, :author_id, :integer, :default => 0, :null => false            
  end

  def self.down
    remove_column :contents, :author_id
    remove_column :profile_questions, :author_id
  end
end