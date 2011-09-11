class AddMonetarySupportToAccountSetting < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :collected_usd, :decimal, :precision => 11, :scale => 2, :default => 0
    add_column :account_settings, :balance_usd, :decimal, :precision => 11, :scale => 2, :default => 0
    add_column :account_settings, :waiting_period, :integer, :default => 60
  end

  def self.down
    remove_column :account_settings, :waiting_period
    remove_column :account_settings, :balance_usd
    remove_column :account_settings, :collected_usd
  end
end
