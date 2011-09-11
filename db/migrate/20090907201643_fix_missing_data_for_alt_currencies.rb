class FixMissingDataForAltCurrencies < ActiveRecord::Migration
  def self.up
    # Fixes EUR/RUR
    MonetaryDonation.find_all_by_currency_id(2).each{|v| v.valid? ; v.save(false) }
    MonetaryDonation.find_all_by_currency_id(3).each{|v| v.valid? ; v.save(false) }
 end

  def self.down
  end
end
