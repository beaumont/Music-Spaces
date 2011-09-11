class Playing < ActiveRecord::Migration
  def self.up
    add_column :playlist_items, :is_playing, :boolean, :default => false
    add_index(:playlist_items, [:playlist_id, :position])
    add_index(:playlist_items, [:playlist_id, :is_playing])
  end

  def self.down
    remove_column :playlist_items, :is_playing
  end
end
