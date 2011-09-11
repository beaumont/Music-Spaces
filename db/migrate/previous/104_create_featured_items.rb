class CreateFeaturedItems < ActiveRecord::Migration
  def self.up
    create_table :featured_items do |t|
      t.belongs_to :item
      t.string :item_type
      t.boolean :is_content, :is_project, :currently_featured
      t.timestamps
    end
    add_index :featured_items, :currently_featured
  end

  def self.down
    drop_table :featured_items
  end
end
