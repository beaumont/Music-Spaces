class AddInvoiceAgreementToAccountSetting < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :invoice_agreement_accepted_at, :datetime
  end

  def self.down
    remove_column :account_settings, :invoice_agreement_accepted_at
  end
end
