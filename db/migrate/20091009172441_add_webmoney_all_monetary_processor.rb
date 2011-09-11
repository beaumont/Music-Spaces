class AddWebmoneyAllMonetaryProcessor < ActiveRecord::Migration
  def self.up
    execute "UPDATE monetary_processors SET allow_donation = FALSE WHERE short_name like 'webmoney%' "
    MonetaryProcessor.create(:name => "WebMoney",
                             :short_name => "webmoney_all",
                             :display_order => 20,
                             :donation_account_identifier => "",
                             :allow_donation => true,
                             :allow_withdrawal => false,
                             :allow_donations_in_regions => "NA EU RU OTHER")
  end

  def self.down
    MonetaryProcessor.delete_all(:name => "WebMoney")
  end
end
