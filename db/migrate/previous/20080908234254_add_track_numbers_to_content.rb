class AddTrackNumbersToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :number_of_tracks, :integer
  end

  def self.down
    remove_column :contents, :number_of_tracks
  end
end
