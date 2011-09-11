class PaypalWebmoneyDoNotSupportTellingUsFeeAmounts < ActiveRecord::Migration
  def self.up
    add_column :monetary_contributions, :amount_transferred_after_fees, :decimal, :precision => 10, :scale => 2
    MonetaryContribution.find(:all, :conditions => 'amount_paid_before_fees is not null').each do |mc|
      mc.update_attribute(:amount_transferred_after_fees, mc.auth_amount)
      mc.update_attribute(:auth_amount, mc.amount_paid_before_fees)
    end
    remove_column :monetary_contributions, :amount_paid_before_fees
  end

  def self.down
    add_column :monetary_contributions, :amount_paid_before_fees, :decimal, :precision => 10, :scale => 2
    MonetaryContribution.find(:all, :conditions => 'amount_transferred_after_fees is not null').each do |mc|
      mc.update_attribute(:auth_amount, mc.amount_transferred_after_fees)
      mc.update_attribute(:amount_paid_before_fees, mc.auth_amount)
    end
    remove_column :monetary_contributions, :amount_transferred_after_fees
  end
end
