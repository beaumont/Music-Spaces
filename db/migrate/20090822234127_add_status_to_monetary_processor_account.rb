class AddStatusToMonetaryProcessorAccount < ActiveRecord::Migration
  def self.up
    add_column :monetary_processor_accounts, :status, :string
    MonetaryProcessorAccount.connection.execute("UPDATE monetary_processor_accounts set status = account_type, account_type = '' WHERE type = 'PaypalAccount'")
    MonetaryProcessorAccount.connection.execute("UPDATE monetary_processor_accounts set status = 'verified'                      WHERE type = 'WebMoneyAccount'")
  end

  def self.down
    remove_column :monetary_processor_accounts, :status
  end
end
