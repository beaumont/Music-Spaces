class IntroducePublishMaActivity < ActiveRecord::Migration
  def self.up
    updated = MusicAlbum.connection.update("update activities, contents set activities.activity_type_id = %s where activities.content_id = contents.id and activities.content_type = 'Content' and contents.type = 'MusicAlbum' and activities.activity_type_id = %s" % [Activity::ACTIVITIES[:published_music_album][:id], Activity::ACTIVITIES[:published_album][:id]])
    puts "%s: %s activites updated" % [self.class.name, updated]
  end

  def self.down
  end
end
