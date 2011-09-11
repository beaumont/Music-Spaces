class AddIsReconnectWithFbFriendsToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :is_reconnect_with_fb_friends, :boolean, :default => 0
  end

  def self.down
    remove_column :preferences, :is_reconnect_with_fb_friends
  end
end
