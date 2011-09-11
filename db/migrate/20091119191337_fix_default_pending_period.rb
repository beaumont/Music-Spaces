class FixDefaultPendingPeriod < ActiveRecord::Migration
  def self.up
    current = AccountSetting.default_withdrawal_waiting_period
    change_column :account_settings, :waiting_period, :integer, :default => nil
    AccountSetting.update_all('waiting_period = null',['waiting_period = ?', current])
  end

  def self.down
    change_column :account_settings, :waiting_period, :integer, :default => 30
  end
end
