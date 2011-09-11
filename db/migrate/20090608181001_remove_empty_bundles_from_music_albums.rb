class RemoveEmptyBundlesFromMusicAlbums < ActiveRecord::Migration
  def self.up
    Bundle.find(:all, :conditions => "filename is null").select{|b| b.bundle_for.is_a?(MusicAlbum)}.each{|b| b.delete}
  end

  def self.down
  end
end
