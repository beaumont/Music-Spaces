class CreatePaypalAccounts < ActiveRecord::Migration
  def self.up
    MonetaryProcessorAccount.connection.execute("
      INSERT INTO  monetary_processor_accounts (account_setting_id, monetary_processor_id, account_identifier, account_type, verified_at, created_at, updated_at, type)
      SELECT a.id, 1, a.paypal_email, a.paypal_status, a.paypal_status_last_updated_at, a.paypal_status_last_updated_at, a.paypal_status_last_updated_at, 'PaypalAccount'
      FROM account_settings as a WHERE a.paypal_email IS NOT NULL AND a.paypal_status IS NOT NULL AND a.paypal_status LIKE 'verified%';    
    ")
    
    add_column :monetary_processor_accounts, :parent_account, :string
    add_column :monetary_processor_accounts, :account_level, :integer
    add_column :monetary_processor_accounts, :minimum_account_level, :integer, :default => 130
    
    MonetaryProcessorAccount.connection.execute("
      INSERT INTO  monetary_processor_accounts (account_setting_id, monetary_processor_id, account_identifier, parent_account, account_type, account_level, minimum_account_level, verified_at, created_at, updated_at, type)
      SELECT a.id, 2, a.webmoney_wmz, a.webmoney_account, 'WMZ', a.webmoney_passport_level, a.webmoney_passport_minimum, a.webmoney_attached_at, a.webmoney_attached_at, a.webmoney_attached_at, 'WebMoneyAccount'
      FROM account_settings as a WHERE a.webmoney_wmz IS NOT NULL AND a.webmoney_account IS NOT NULL AND webmoney_account_verified = 1;
    ")
  end

  def self.down
    remove_column :monetary_processor_accounts, :account_level
    remove_column :monetary_processor_accounts, :account_minimum
    remove_column :monetary_processor_accounts, :parent_account
  end
end
