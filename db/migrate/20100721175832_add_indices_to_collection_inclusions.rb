class AddIndicesToCollectionInclusions < ActiveRecord::Migration
  def self.up
    add_index :collection_inclusions, [:child_pac_id]
    add_index :collection_inclusions, [:child_user_id]
    add_index :collection_inclusions, [:parent_id, :child_is_collection]
  end

  def self.down
  end
end
