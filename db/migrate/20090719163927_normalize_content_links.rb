class NormalizeContentLinks < ActiveRecord::Migration
  def self.up
    #these two doesn't differ content subtypes
    [[Tagging, 'taggable_type'], [Vote, 'voteable_type']].each do |klass, type_field|
      klass.update_all ['%s = ?' % type_field, 'Content'], ['%s = ?' % type_field, 'MusicAlbum'] 
    end

    #historical mess + some MusicAlbum convertions sideeffects
    [["Comment", "2"], ["Invite", "5"], ["Invite", "6"], ["Content", "12"], ["Content", "100"], ["Content", "101"], ["Content", "102"],
     ["Content", "103"], ["Content", "104"], ["Content", "106"], ["User", "150"], ["User", "300"], ["Content", "301"],
     ["Content", "303"], ["Content", "319"]].each do |content_type, activity_type_id|
      activity_type_id = activity_type_id.to_i
      result = Activity.update_all ['content_type = ?', content_type],
                          ['activity_type_id = ? and content_type != ?', activity_type_id, content_type]
      puts "Updated %s activities for activity_type_id = %s to content_type '%s'" %
              [result, Activity.keyname(activity_type_id).inspect, content_type]
    end
  end

  def self.down
  end
end
