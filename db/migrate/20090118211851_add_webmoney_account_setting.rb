class AddWebmoneyAccountSetting < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :webmoney_account, :string
  end

  def self.down
    remove_column :account_settings, :webmoney_account
  end
end
