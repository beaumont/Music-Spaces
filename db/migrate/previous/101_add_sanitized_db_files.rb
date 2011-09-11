class AddSanitizedDbFiles < ActiveRecord::Migration
  def self.up
    add_column :contents, :sanitized_db_store_id, :integer
  end

  def self.down  
    remove_column :contents, :sanitized_db_store_id
  end
end
