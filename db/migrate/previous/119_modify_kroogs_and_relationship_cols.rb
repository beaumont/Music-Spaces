class ModifyKroogsAndRelationshipCols < ActiveRecord::Migration
  def self.up
    add_column :monetary_contributions, :user_kroog_id, :integer, :null => true
    remove_column :monetary_contributions, :relationship_id
    change_column :relationships, :expires_at, :datetime, :default => '2038-01-01'.to_time, :allow_nil => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration.new("This isn't going to happen. Sorry dog.")
  end
end
