class AddBeforeAfterFeeAmounts < ActiveRecord::Migration
  def self.up
    add_column :monetary_contributions, :amount_paid_before_fees, :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column :monetary_contributions, :amount_paid_before_fees
  end
end
