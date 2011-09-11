class RemovingFaultingInboxField < ActiveRecord::Migration
  def self.up
    remove_column :extra_inbox_fields, :last_item_added_at
  end

  def self.down
    add_column :extra_inbox_fields, :last_item_added_at, :datetime
  end
end
