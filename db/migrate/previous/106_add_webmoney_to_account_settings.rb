class AddWebmoneyToAccountSettings < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :webmoney_wmz, :string, :limit => 13
    add_column :account_settings, :webmoney_wme, :string, :limit => 13
    add_column :account_settings, :webmoney_wmr, :string, :limit => 13
  end

  def self.down
    remove_column :account_settings, :webmoney_wmz
    remove_column :account_settings, :webmoney_wme
    remove_column :account_settings, :webmoney_wmr
  end
end
