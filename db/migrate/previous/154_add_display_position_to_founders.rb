class AddDisplayPositionToFounders < ActiveRecord::Migration
  def self.up
    add_column :relationships, :display_order, :integer, :default => 0
  end

  def self.down
    remove_column :relationships, :display_order
  end
end
