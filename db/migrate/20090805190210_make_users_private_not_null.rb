class MakeUsersPrivateNotNull < ActiveRecord::Migration
  def self.up
    User.update_all('private = false', 'private is null')
    change_column :users, :private, :boolean, :null => false, :default => false    
  end

  def self.down
  end
end
