class TpsCanBeStopped < ActiveRecord::Migration
  def self.up
    add_column :tps_content_details, :stopped, :boolean, :default => false
    Tps::ContentDetails.update_all('stopped = 0')
    change_column(:tps_content_details, :stopped, :boolean, :null => false, :default => false)
  end

  def self.down
  end
end
