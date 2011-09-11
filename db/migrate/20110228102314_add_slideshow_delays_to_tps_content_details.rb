class AddSlideshowDelaysToTpsContentDetails < ActiveRecord::Migration
  def self.up
    add_column :tps_content_details, :slideshow_delays, :integer, :default => 1
  end

  def self.down
    remove_column :tps_content_details, :slideshow_delays
  end
end
