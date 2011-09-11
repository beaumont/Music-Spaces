class AddCreditCardMonetaryProcessor < ActiveRecord::Migration
  def self.up
    add_column :monetary_processors, :display_order, :integer, :null => false
    execute "UPDATE monetary_processors SET display_order = id * 10"
    add_index :monetary_processors, :display_order
    MonetaryProcessor.create(:name => "Visa, MasterCard, American Express, Discover",
                             :short_name => "credit_card",
                             :display_order => 15,
                             :donation_account_identifier => "",
                             :allow_donation => true,
                             :allow_withdrawal => false,
                             :allow_donations_in_regions => "NA EU RU OTHER")
  end

  def self.down
    MonetaryProcessor.delete_all(:name => "PayPal")
    remove_index  :monetary_processors, :display_order
    remove_column :monetary_processors, :display_order
  end
end
