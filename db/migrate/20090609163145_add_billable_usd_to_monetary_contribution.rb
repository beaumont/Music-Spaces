class AddBillableUsdToMonetaryContribution < ActiveRecord::Migration
  def self.up
    add_column :monetary_contributions, :billable_usd, :decimal, :precision => 11, :scale => 6
  end

  def self.down
    remove_column :monetary_contributions, :billable_usd
  end
end
