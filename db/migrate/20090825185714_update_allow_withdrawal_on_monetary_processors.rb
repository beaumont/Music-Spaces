class UpdateAllowWithdrawalOnMonetaryProcessors < ActiveRecord::Migration
  def self.up
    execute "UPDATE monetary_processors SET allow_withdrawal = 1 WHERE short_name IN ('paypal', 'webmoney_usd')"
  end

  def self.down
    execute "UPDATE monetary_processors SET allow_withdrawal = 1"
  end
end
