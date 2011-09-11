class AddContentUniquenessToI18n < ActiveRecord::Migration
  def self.up
    remove_column :contents_i18n, :content_type 
    remove_index :contents_i18n, :name => :index_contents_i18n_on_content_id
    add_index :contents_i18n, :content_id, :unique => true
  end

  def self.down
  end
end
