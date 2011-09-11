class AddJunkMarkToFeedbacks < ActiveRecord::Migration
  def self.up
    add_column :feedbacks, :junk, :boolean, :default => 0
    add_column :feedbacks, :created_by_id, :integer, :limit => 11, :default => 0, :null => false
    add_column :feedbacks, :updated_by_id, :integer, :limit => 11, :default => 0, :null => false
  end

  def self.down
    remove_column :feedbacks, :junk
    remove_column :feedbacks, :created_by_id
    remove_column :feedbacks, :updated_by_id
  end
end
