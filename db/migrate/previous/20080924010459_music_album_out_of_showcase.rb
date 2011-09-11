class MusicAlbumOutOfShowcase < ActiveRecord::Migration
  def self.up
    FolderWithDownloadables.find(:all).each do |m|
      m.update_attribute(:is_in_startpage, false)
      m.albums.clear
    end
  end

  def self.down
  end
end
