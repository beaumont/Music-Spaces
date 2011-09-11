class AddCurrencyToMonetaryProcessors < ActiveRecord::Migration
  def self.up
    add_column('monetary_processors', 'currency', :string) rescue nil
    {'usd' => ['paypal', 'webmoney_usd', 'credit_card'], 'rur' => ['webmoney_rur', 'yandex'], 'eur' => ['webmoney_eur']}.each do |code, short_names|
      short_names.each do |sn|
        p = MonetaryProcessor.find_by_short_name(sn)
        p.update_attribute(:currency, code) if p
      end
    end
  end

  def self.down
  end
end
