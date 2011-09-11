class AddYandexMonetaryProcessor < ActiveRecord::Migration
  def self.up
    MonetaryProcessor.create(:name => "Yandex",
                             :short_name => "yandex",
                             :display_order => 17,
                             :donation_account_identifier => "",
                             :allow_donation => true,
                             :allow_withdrawal => false,
                             :allow_donations_in_regions => "NA EU RU OTHER")
  end

  def self.down
    MonetaryProcessor.delete_all(:name => "Yandex")
  end
end
