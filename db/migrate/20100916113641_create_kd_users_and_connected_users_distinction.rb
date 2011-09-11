class CreateKdUsersAndConnectedUsersDistinction < ActiveRecord::Migration
  def self.up
    add_column :fb_user_details, :is_kd_user, :boolean, :default => 0
    add_column :fb_user_details, :is_fb_connected, :boolean, :default => 0
    Facebook::UserDetails.update_all('is_kd_user = 1')
  end

  def self.down
    remove_column :fb_user_details, :is_kd_user
    remove_column :fb_user_details, :is_fb_connected
  end
end

