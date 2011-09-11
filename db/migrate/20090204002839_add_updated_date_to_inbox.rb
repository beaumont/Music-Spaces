class AddUpdatedDateToInbox < ActiveRecord::Migration
  def self.up
    add_column :extra_inbox_fields, :last_item_added_at, :datetime
  end

  def self.down
    remove_column :extra_inbox_fields, :last_item_added_at
  end
end
