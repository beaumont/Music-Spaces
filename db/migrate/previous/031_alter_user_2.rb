class AlterUser2 < ActiveRecord::Migration
  def self.up      
    add_column :users, :type, :string, :limit => 10, :default => 'User', :null => false
    add_column :users, :on_behalf_id, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :users, :type
    remove_column :users, :on_behalf_id
  end
end