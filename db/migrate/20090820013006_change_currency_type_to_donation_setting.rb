class ChangeCurrencyTypeToDonationSetting < ActiveRecord::Migration
  def self.up
    rename_table :currency_types, :donation_settings
  end

  def self.down
    rename_table :donation_settings, :currency_types
  end
end
