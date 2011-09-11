require "#{RAILS_ROOT}/app/models/content"
class FixItemSecurities < ActiveRecord::Migration
  def self.up
    puts "Cycling through all albums and ensuring proper privacy settings for nested items"
    
    # The permissions process is recursive, so let's just start at the top level - skip all albums that are in other albums (except showcase)
    all_album_ids = Album.find(:all, :select => :id).map(&:id)
    puts "Found #{all_album_ids.size} total albums"
    
    showcase_album_ids = Album.find(:all, :select => :id, :conditions => ['cat_id = ?', Content::CATEGORIES[:featured_album][:id]]).map(&:id)
    puts "Found #{showcase_album_ids.size} showcase albums"

    
    albums_in_other_albums = AlbumItem.find(:all, :select => 'distinct content_id', :conditions => ['content_id in (?) and album_id not in (?)', all_album_ids, showcase_album_ids]).map(&:content_id)
    puts "Found #{albums_in_other_albums.size} albums in other albums (besides showcase), now looking for the opposite"
    
    does_not_want = (albums_in_other_albums + showcase_album_ids).uniq
    top_level_albums = Album.find(:all, :conditions => ['id not in (?)', does_not_want])
    puts "Found #{top_level_albums.size} top level albums (not in showcase), now cycling through them"
    
    top_level_albums.each_with_index do |a, index|
      puts "#{index} of #{top_level_albums.size}" if index % 500 == 0
      next if a.cat_id == Content::CATEGORIES[:featured_album][:id]
      
      # If this album is a top-level album, exclusind
      a.set_permissions_to( a.relationshiptype_id )
    end

  end

  def self.down
  end
end