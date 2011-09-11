class CreateImpactCounters < ActiveRecord::Migration
  def self.up
    create_table :impact_counters do |t|
      t.integer :user_id, :null => false
      t.integer :content_id, :null => false
      t.integer :counter_kind_id
      t.integer :total, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :impact_counters
  end
end
