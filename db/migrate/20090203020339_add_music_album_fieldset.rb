class AddMusicAlbumFieldset < ActiveRecord::Migration
  def self.up
    create_table :extra_music_album_fields do |t|
      t.belongs_to :music_album
      t.boolean :require_terms_acceptance, :default => false
      t.string :number_of_tracks
      t.integer :terms_db_store_id, :terms_db_store_ru_id, :terms_and_conditions_id
      t.timestamps
    end
    add_index :extra_music_album_fields, :music_album_id
    
    FolderWithDownloadables.find(:all).each do |ma|
      unless ma.extra_fieldset && !ma.extra_fieldset.new_record?
        extra = ma.build_extra_fieldset
        extra.number_of_tracks = ma['number_of_tracks'].to_s
        extra.save
      end
    end
    
    remove_column :contents, :number_of_tracks
  end

  def self.down
    add_column(:contents, :number_of_tracks, :integer) unless Content.column_names.include?("number_of_tracks")
    
    ExtraFieldset::FolderWithDownloadables.find(:all).each do |ex|
      ma = FolderWithDownloadables.find_by_id(ex.music_album_id)
      if ma.nil?
        puts "Skipping fieldset with no attached music album (id: #{ex.id})"
      else
        ma['number_of_tracks'] = ex.number_of_tracks.to_i
        ma.save
      end
    end
    
    drop_table :extra_music_album_fields
  end
end
