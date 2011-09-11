class AddPaypalDenialReasonToAccountSetting < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :paypal_denial_reason, :string
  end

  def self.down
    remove_column :account_settings, :paypal_denial_reason
  end
end
