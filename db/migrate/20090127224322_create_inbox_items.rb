class CreateInboxItems < ActiveRecord::Migration
  def self.up
    create_table :inbox_items do |t|
      t.integer :inbox_id, :content_id
      t.integer :position, :default => 0, :nil => false
      t.integer :created_by_id
      t.timestamps
    end
    add_index :inbox_items, [:inbox_id, :position]
    add_index :inbox_items, :content_id
  end

  def self.down
    drop_table :inbox_items
  end
end
