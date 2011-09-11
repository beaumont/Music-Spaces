class FixMultihomedAlbums < ActiveRecord::Migration
  def self.up
    AlbumItem.clean_duplicates!
  end

  def self.down
    
  end
end
