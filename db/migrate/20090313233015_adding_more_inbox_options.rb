class AddingMoreInboxOptions < ActiveRecord::Migration
  def self.up
    add_column :extra_inbox_fields, :require_allowing_content_adoption, :boolean, :default => false
  end

  def self.down
    remove_column :extra_inbox_fields, :require_allowing_content_adoption
  end
end
