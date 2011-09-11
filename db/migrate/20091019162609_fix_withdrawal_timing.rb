class FixWithdrawalTiming < ActiveRecord::Migration
  def self.up
    MonetaryDonation.connection.execute('alter table account_settings alter waiting_period set default 30')
    MonetaryDonation.connection.execute('update account_settings set waiting_period = 30')
    MonetaryDonation.connection.execute('update monetary_transactions set available_at = available_at - INTERVAL 30 DAY')
  end

  def self.down
  end
end
