class AddTypesToMonetaryContributions < ActiveRecord::Migration
  def self.up
    add_column :monetary_contributions, :payment_api, :string
    add_column :account_settings, :donation_amount_wmz, :decimal, :precision => 10, :scale => 2, :null => true
    add_column :account_settings, :donation_amount_wme, :decimal, :precision => 10, :scale => 2, :null => true
    add_column :account_settings, :donation_amount_wmr, :decimal, :precision => 10, :scale => 2, :null => true
  end

  def self.down
    remove_column :monetary_contributions, :payment_api
    remove_column :account_settings, :donation_amount_wmz
    remove_column :account_settings, :donation_amount_wme
    remove_column :account_settings, :donation_amount_wmr
  end
end
