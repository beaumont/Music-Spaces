class AddThumbnailIndex < ActiveRecord::Migration
  def self.up
    add_index :contents, :parent_id
  end

  def self.down
    remove_index :contents, :parent_id
  end
end
