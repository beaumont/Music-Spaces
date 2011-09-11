class ChangeShortNameOnSmsMonetaryProcessor < ActiveRecord::Migration
  def self.up
    execute("UPDATE monetary_processors SET short_name = 'movable_broker' WHERE short_name = 'sms_eur_rus';")
  end

  def self.down
    execute("UPDATE monetary_processors SET short_name = 'sms_eur_rus' WHERE short_name = 'movable_broker';")
  end
end
