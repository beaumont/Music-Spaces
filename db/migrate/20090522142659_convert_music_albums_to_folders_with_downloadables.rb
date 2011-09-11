class ConvertMusicAlbumsToFoldersWithDownloadables < ActiveRecord::Migration
  def self.up

    ActiveRecord::Base.connection.execute 'RENAME TABLE extra_music_album_fields TO extra_folder_with_downloadables_fields'
    rename_column :extra_folder_with_downloadables_fields, :music_album_id, :folder_id
    Content.update_all ['type = ?', 'FolderWithDownloadables'], ['type = ?', 'MusicAlbum']
    Activity.update_all ['activity_type_id = ?', Activity::ACTIVITIES[:published_album][:id]], ['activity_type_id = ?', 107]
    Content.update_all ['cat_id = ?', Content::CATEGORIES[:album][:id]], ['cat_id = ?', 12]

    [:activities, :content_stats, :stats].each do |table_name|
      change_column table_name, :content_type, :string, :limit => 32
    end

  end

  def self.down
  end
end
