class AddSponsorFieldToCurrencyTypes < ActiveRecord::Migration
  def self.up
    add_column :currency_types, :sponsorship_prices, :boolean, :default => false
  end

  def self.down
    remove_column :currency_types, :sponsorship_prices
  end
end
