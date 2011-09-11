class AddSmscoinMonetaryProcessor < ActiveRecord::Migration
  def self.up
    MonetaryProcessor.create(:name => "SMS",
                             :short_name => "smscoin",
                             :display_order => 60,
                             :allow_donation => false,
                             :allow_withdrawal => false,
                             :allow_donations_in_regions => "NA EU RU OTHER")
    MonetaryProcessor.update_all('allow_donation = 0', ['short_name = ?', 'movable_broker'])
  end

  def self.down
  end
end
