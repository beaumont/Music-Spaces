class ExpireRelationships < ActiveRecord::Migration
  def self.up
    Relationship.transaction do
      add_column :relationships,            :expires_at,  :datetime, :default => '2038-01-01', :null => false
      add_column :relationships,            :privacylevel,     :integer,  :default => 0, :null => false, :limit => 4
    end
  end

  def self.down
    Relationship.transaction do
      remove_column :relationships,            :expires_at
      remove_column :relationships,            :privacylevel
    end
  end
end
