class AddEditorialToFeaturedItems < ActiveRecord::Migration
  def self.up
    add_column :featured_items, :db_store_id, :integer
  end

  def self.down
    remove_column :featured_items, :db_store_id
  end
end
