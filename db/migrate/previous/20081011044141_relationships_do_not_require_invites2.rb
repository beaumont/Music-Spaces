class RelationshipsDoNotRequireInvites2 < ActiveRecord::Migration
  def self.up
    # Apparently rails isn't smart enough to know that if you're making the default nil, it should allow nil values
    change_column :relationships, :related_entity_id, :integer, :null => true
  end

  def self.down
  end
end
