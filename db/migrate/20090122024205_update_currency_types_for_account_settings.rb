class UpdateCurrencyTypesForAccountSettings < ActiveRecord::Migration
  def self.up
    recs = CurrencyType.update_all("message_to_donors = 'Thank you for your donation!', message_to_donors_ru = 'Thank you for you donation!'", "accountable_type = 'AccountSetting'")
    puts "#{recs} updated"
  end

  def self.down
  end
end
