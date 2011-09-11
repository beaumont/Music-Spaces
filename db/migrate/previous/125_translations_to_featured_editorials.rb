class TranslationsToFeaturedEditorials < ActiveRecord::Migration
  def self.up
    add_column :featured_items, :db_store_ru_id, :integer
    add_index :featured_items, :db_store_ru_id
  end

  def self.down
    remove_column :featured_items, :db_store_ru_id
    remove_index :featured_items, :db_store_ru_id
  end
end
