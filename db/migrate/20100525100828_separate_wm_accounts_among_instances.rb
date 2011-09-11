class SeparateWmAccountsAmongInstances < ActiveRecord::Migration
  def self.up
    rename_column 'monetary_processor_accounts', 'parent_account', 'external_id'
    MonetaryProcessorAccount.update_all('external_id = account_identifier', ['type = ?', 'WebMoneyAccount'])
    MonetaryProcessorAccount.update_all('account_identifier = account_setting_id', ['type = ?', 'WebMoneyAccount'])
  end

  def self.down
  end
end
