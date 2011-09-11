class ExistingInRainbowsToNewStructure < ActiveRecord::Migration
  def self.up
    unless Content.column_names.include?('downloadable_album_id')
      add_column :contents, :downloadable_album_id, :integer, :default => nil
    end

    
    FolderWithDownloadables.find(:all).each do |ma|
      # Album covert art is now a new class, so albums can contain Images
      if ca = ma.has_image? ? ma.images.first : nil
        ca.update_attributes(:cat_id => Content::CATEGORIES[:cover_art][:id], :downloadable_album_id => ma.id)
        ca.update_attribute(:type, 'CoverArt')
      end
      
      # Album bundle is now associated w/ has_many
      ma.album_contents_items.select {|x| x.content.is_a? Bundle}.collect{|x| x.content}.each do |b|
        b.update_attribute(:downloadable_album_id, ma.id)
      end
      
      # Start showing music albums in the gallery
      ma.update_attribute(:is_in_gallery, true)
    end
    
    # Now that neither cover art nor bundles are using the album_items table, let's clean up a bit
    ma_ids = FolderWithDownloadables.all.map(&:id)
    unless ma_ids.empty?
      puts "Clearing obsolete album_item entries for #{ma_ids.size} MusicAlbums"
      all_music_album_contents = AlbumItem.find(:all, :conditions => {:album_id => ma_ids}, :include => :content)
      bundle_ids = all_music_album_contents.select{|x| x.content.is_a?(Bundle)}.map(&:id)
      ca_ids = all_music_album_contents.select{|x| x.content.is_a?(Image)}.map(&:id)
      content_ids_to_remove = bundle_ids + ca_ids
      AlbumItem.delete_all ["id in (?)", content_ids_to_remove] unless content_ids_to_remove.empty?
    end
  end

  def self.down
    # raise "Not yet implemented (probably never going back to old style)"
    # remove_column :contents, :downloadable_album_id
  end
end
