class AddingOptionsToInboxItem < ActiveRecord::Migration
  def self.up
    add_column :inbox_items, :allow_take_to_showcase, :boolean, :default => true
  end

  def self.down
    remove_column :inbox_items, :allow_take_to_showcase
  end
end
