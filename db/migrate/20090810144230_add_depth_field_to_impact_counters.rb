class AddDepthFieldToImpactCounters < ActiveRecord::Migration
  def self.up
    add_column :impact_counters, :depth, :text, :limit => 64.kilobytes + 1
  end

  def self.down
  end
end
