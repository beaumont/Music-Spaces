class AddReferralToImpactCounters < ActiveRecord::Migration
  def self.up
    add_column :impact_counters, :referral_type, :string
    add_index :impact_counters, :user_id
    add_index :impact_counters, :to_user_id
  end

  def self.down
    remove_index :impact_counters, :to_user_id
    remove_index :impact_counters, :user_id
    remove_column :impact_counters, "referral_type"
  end
end
