class TrackMovableUpdateIp < ActiveRecord::Migration
  def self.up
    add_column :movable_version, :last_updated_from_ip, :string
  end

  def self.down
    remove_column :movable_version, :last_updated_from_ip
  end
end
