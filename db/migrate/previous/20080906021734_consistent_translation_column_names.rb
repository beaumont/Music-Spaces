class ConsistentTranslationColumnNames < ActiveRecord::Migration
  def self.up
    rename_column :relationshiptypes, :explanation_ru_db_store_id, :explanation_db_store_ru_id
    rename_column :featured_items, :db_store_id, :editorial_db_store_id
    rename_column :featured_items, :db_store_ru_id, :editorial_db_store_ru_id
  end

  def self.down
    rename_column :relationshiptypes, :explanation_db_store_ru_id, :explanation_ru_db_store_id
    rename_column :featured_items, :editorial_db_store_id, :db_store_id
    rename_column :featured_items, :editorial_db_store_ru_id, :db_store_ru_id
  end
end
