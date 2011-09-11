class RelationshipsDoNotRequireInvites < ActiveRecord::Migration
  def self.up
    change_column :relationships, :related_entity_id, :integer, :default => nil
  end

  def self.down
  end
end
