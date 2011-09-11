class CreateAlbumItems < ActiveRecord::Migration
  def self.up
    create_table :album_items do |t|
      t.belongs_to :album
      t.belongs_to :content
      t.integer :position, :default => 0, :null => false
      t.integer :created_by_id, :default => 0, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :album_items
  end
end