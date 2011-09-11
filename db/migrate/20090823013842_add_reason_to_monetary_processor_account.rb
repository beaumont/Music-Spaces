class AddReasonToMonetaryProcessorAccount < ActiveRecord::Migration
  def self.up
    add_column :monetary_processor_accounts, :reason, :string
    MonetaryProcessorAccount.connection.execute("
      UPDATE monetary_processor_accounts, account_settings
      SET monetary_processor_accounts.reason = account_settings.paypal_denial_reason
      WHERE monetary_processor_accounts.id = account_settings.id
    ")
  end

  def self.down
    remove_column :monetary_processor_accounts, :reason
  end
end
