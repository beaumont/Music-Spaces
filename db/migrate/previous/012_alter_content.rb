class AlterContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :is_in_gallery, :boolean, :default => false
  end
  def self.down
    remove_column :contents, :is_in_gallery
  end
end