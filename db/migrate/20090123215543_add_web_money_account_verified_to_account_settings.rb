class AddWebMoneyAccountVerifiedToAccountSettings < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :webmoney_account_verified, :boolean
  end

  def self.down
    remove_column :account_settings, :webmoney_account_verified
  end
end