class AddActivationSwitchForPlaylistItems < ActiveRecord::Migration
  def self.up
    add_column :playlist_items, :active, :boolean, :default => true
  end

  def self.down
    remove_column :playlist_items, :active
  end
end
