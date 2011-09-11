class AddReferenceItemToTrackings < ActiveRecord::Migration
  def self.up
    add_column :trackings, :reference_item_id, :integer
    add_column :trackings, :reference_item_type, :string
    # No index, b/c I don't anticipate ever search by this
  end

  def self.down
    remove_column :trackings, :reference_item_id
    remove_column :trackings, :reference_item_type
  end
end
