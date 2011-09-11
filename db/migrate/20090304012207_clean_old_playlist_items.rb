class CleanOldPlaylistItems < ActiveRecord::Migration
  def self.up
    # Just added a before_destroy callback to track to remove any playlist items when the track goes.  Need to get up to speed for existing orphans.
    good_ids = Track.find(:all, :select => [:id]).map(&:id)
    puts "Found #{good_ids.size} tracks in the system"
    removed = PlaylistItem.delete_all ['track_id not in (?)', good_ids]
    puts "Removed #{removed} playlist items referencing non-existant tracks"
  end

  def self.down
  end
end
