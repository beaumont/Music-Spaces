class AddMinimumWebMoneyAccountTypeToAccountSettings < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :webmoney_passport_minimum, :integer, :default => 130 # Personal Account
  end

  def self.down
    remove_column :account_settings, :webmoney_passport_minimum
  end
end
