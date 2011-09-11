class ConvertMusicAlbumAssociationsToFwd < ActiveRecord::Migration
  def self.up
    to, from = 'FolderWithDownloadables', 'MusicAlbum'
    [[FeaturedItem, 'item_type'], [Comment, 'commentable_type'], [Favorite, 'favorable_type'],
            [Moderation::Event, 'reportable_type'], [SmsPayload, 'payment_for_type'],
            [Tagging, 'taggable_type'], [Vote, 'voteable_type']].each do |klass, field|
      klass.update_all ['%s = ?' % field, to], ['%s = ?' % field, from]
    end
    
    [Activity, ContentStat, Stat].each do |klass|
      klass.update_all ['content_type = ?', to], ['content_type = ?', from]
    end
  end

  def self.down
  end
end
