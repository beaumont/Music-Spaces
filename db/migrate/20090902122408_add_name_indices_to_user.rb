class AddNameIndicesToUser < ActiveRecord::Migration
  def self.up
    add_index "users", ['state', 'login'], :name => "users_state_and_login"
    add_index "users", ['state', 'display_name'], :name => "users_state_and_display_name"
    add_index "users", ['state', 'display_name_ru'], :name => "users_state_and_display_name_ru"
  end

  def self.down
  end
end
