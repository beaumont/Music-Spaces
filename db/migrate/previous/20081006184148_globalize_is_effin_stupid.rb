class GlobalizeIsEffinStupid < ActiveRecord::Migration
  
  class DbFile < ActiveRecord::Base
  end
  
  def self.up
    remove_column :db_store, :content_ru
    remove_column :db_store, :content_fr
    
    rename_column :contents, :sanitized_db_store_id, :post_db_store_id
    add_column :contents, :post_db_store_ru_id, :integer
    add_column :contents, :post_db_store_fr_id, :integer
    
    Textentry.all.each do |te|
      db_file = DbFile.find_by_id(te.db_file_id)
      te.post = db_file.data if db_file
      te.save(false)
    end
    
    Board.all.each do |b|
      db_file = DbFile.find_by_id(b.db_file_id)
      b.post = db_file.data if db_file
      b.save(false)
    end
  end

  def self.down
    remove_column :contents, :post_db_store_fr_id
    remove_column :contents, :post_db_store_ru_id
    rename_column :contents, :db_store_id, :sanitized_db_store_id
    add_column :db_store, :content_fr, :text
    add_column :db_store, :content_ru, :text
  end
end
