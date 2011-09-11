class AddSynopsisToFeatured < ActiveRecord::Migration
  def self.up
    add_column :featured_items, :synopsis, :string
    add_column :featured_items, :synopsis_ru, :string
  end

  def self.down
    remove_column :featured_items, :synopsis
    remove_column :featured_items, :synopsis_ru
  end
end
