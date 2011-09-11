class MakeAlbumItemPositionNullable < ActiveRecord::Migration
  def self.up
    change_column :album_items, :position, :integer, :default => 0, :null => true
  end

  def self.down
  end
end
