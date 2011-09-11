class AlterContents7 < ActiveRecord::Migration
  def self.up
    add_column :contents, :artist, :string, :limit => 80
    add_column :contents, :album, :string, :limit => 80
    add_column :contents, :year, :integer, :limit => 4
    add_column :contents, :genre, :string, :limit => 60
    add_column :contents, :bitrate, :integer, :limit => 4
    add_column :contents, :chanels, :string, :limit => 10
    add_column :contents, :samplerate, :integer, :limit => 4
    add_column :contents, :length, :integer, :limit => 6
  end

  def self.down
    remove_column :contents, :artist
    remove_column :contents, :album
    remove_column :contents, :year
    remove_column :contents, :genre
    remove_column :contents, :bitrate
    remove_column :contents, :chanels
    remove_column :contents, :samplerate
    remove_column :contents, :length
  end
end
