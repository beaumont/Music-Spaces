class AlterImpactCounter < ActiveRecord::Migration
  def self.up
     add_column :impact_counters, :to_user_id, :integer
  end

  def self.down
    remove_column :impact_counters, "to_user_id"
  end
end
