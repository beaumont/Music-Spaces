class FixHistoricalPaypalFees < ActiveRecord::Migration
  def self.up
    MonetaryContribution.find(:all, :conditions => {:payment_api => 'paypal'}).each do |mc|
      mc.update_paypal_fees_and_totals
    end
  end

  def self.down
  end
end
