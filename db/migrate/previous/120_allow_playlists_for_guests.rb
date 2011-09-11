class AllowPlaylistsForGuests < ActiveRecord::Migration
  def self.up
    add_column :playlists, :session_id, :string, :nil => true
    add_index :playlists, [:user_id, :name]
    add_index :playlists, [:user_id, :session_id, :name]
  end

  def self.down
    remove_column :playlists, :session_id
    remove_index :playlists, [:user_id, :name]
    remove_index :playlists, [:user_id, :session_id, :name]
  end
end
