class AddMonetaryProcessors < ActiveRecord::Migration
  def self.up
    add_column    :monetary_processors, :allow_donations_in_regions, :string, :null => false

    MonetaryProcessor.create(:name => "PayPal",         :short_name => "paypal", :donation_account_identifier => "", :allow_donation => true, :allow_withdrawal => true, :allow_donations_in_regions => "NA EU OTHER")
    MonetaryProcessor.create(:name => "WebMoney (USD)", :short_name => "webmoney_usd", :donation_account_identifier => "", :allow_donation => true, :allow_withdrawal => true, :allow_donations_in_regions => "EU RU OTHER")
    MonetaryProcessor.create(:name => "WebMoney (RUR)", :short_name => "webmoney_rur", :donation_account_identifier => "", :allow_donation => false, :allow_withdrawal => true, :allow_donations_in_regions => "EU RU OTHER")
    MonetaryProcessor.create(:name => "WebMoney (EUR)", :short_name => "webmoney_eur", :donation_account_identifier => "", :allow_donation => false, :allow_withdrawal => true, :allow_donations_in_regions => "EU RU OTHER")
    MonetaryProcessor.create(:name => "SMS", :short_name => "sms_eur_rus", :donation_account_identifier => "", :allow_withdrawal => false, :allow_donation => true, :allow_donations_in_regions => "EU RU OTHER")
  end

  def self.down
    remove_column :monetary_processors, :allow_donations_in_regions
  end
end
