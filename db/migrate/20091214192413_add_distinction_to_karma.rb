class AddDistinctionToKarma < ActiveRecord::Migration
  def self.up
    add_column :karma_points, :action, :string
    add_index :karma_points, :action, :name => "karma_action"
  end


  def self.down
    remove_index :karma_points, :name => :index_name
    remove_column :karma_points, :action
  end
end
