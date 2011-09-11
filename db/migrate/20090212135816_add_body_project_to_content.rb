#this is for User/Project content items for Collections
class AddBodyProjectToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :body_project_id, :integer
  end

  def self.down
    remove_column :contents, :body_project_id
  end
end
