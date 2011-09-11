class AddPayPalVerificationToAccountSetting < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :paypal_verified, :boolean, :default => false
    add_column :account_settings, :paypal_transaction, :string # verification transaction id
    add_column :account_settings, :paypal_pending, :boolean, :default => false
  end

  def self.down
    remove_column :account_settings, :paypal_pending
    remove_column :account_settings, :paypal_transaction
    remove_column :account_settings, :paypal_verified
  end
end
