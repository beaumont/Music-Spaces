class FixWaitingPeriodForZeros < ActiveRecord::Migration
  def self.up
    change_column :account_settings, :waiting_period, :integer, :default => nil
    AccountSetting.update_all('waiting_period = NULL WHERE waiting_period = 0')
  end

  def self.down
    change_column :account_settings, :waiting_period, :integer, :default => 0
    AccountSetting.update_all('waiting_period = 0 WHERE waiting_period = NULL')
  end
end
