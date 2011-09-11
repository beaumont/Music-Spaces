class AddStuffToContents < ActiveRecord::Migration
  def self.up
    add_column :contents, :artist_ru, :string
    add_column :contents, :album_ru, :string
    add_column :contents, :artist_fr, :string
    add_column :contents, :album_fr, :string
  end

  def self.down
    remove_column :contents, :album_fr
    remove_column :contents, :artist_fr
    remove_column :contents, :album_ru
    remove_column :contents, :artist_ru
  end
end
