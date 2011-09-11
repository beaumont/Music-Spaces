class GoodieCanBeDownloadable < ActiveRecord::Migration
  def self.up
    add_column :tps_goodies, :downloadable_album_id, :integer
  end

  def self.down
  end
end
