#  create_table "monetary_processors", :force => true do |t|
#    t.column "name",                       :string
#    t.column "short_name",                 :string
#    t.column "allow_withdrawal",           :boolean,  :default => false
#    t.column "allow_donation",             :boolean,  :default => false
#    t.column "created_at",                 :datetime
#    t.column "updated_at",                 :datetime
#    t.column "allow_donations_in_regions", :string,                      :null => false
#    t.column "display_order",              :integer,                     :null => false
#    t.column "currency",                   :string
#  end
#
class MonetaryProcessor < ActiveRecord::Base
  # Processors which are available for withdrawals
  def self.available_for_withdrawals
    all(:conditions => ['allow_withdrawal = ?', true],
        :order => "display_order" )
  end

  def self.available_for_donations
    all(:conditions => ['allow_donation = ?', true],
        :order => "display_order" )
  end

  def self.available_for_donations_in_region(re)
    all(:conditions => "allow_donation = 1 AND allow_donations_in_regions LIKE     '%#{re}%'",
        :order => "display_order" )
  end

  def self.not_available_for_donations_in_region(re)
    all(:conditions => "allow_donation = 1 AND allow_donations_in_regions NOT LIKE '%#{re}%'",
        :order => "display_order" )
  end

  def detach
    return true
  end

  %w(paypal smscoin movable_broker yandex webmoney_all).each do |code|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def self.#{code}
        MonetaryProcessor.find_by_short_name('#{code}')
      end
    RUBY
  end

  #TODO: this really asks for separate MonetaryProcessor subclasses 
  def workers
    return %w(webmoney_rur webmoney_usd webmoney_eur).map {|x| MonetaryProcessor.find_by_short_name(x)} if short_name == 'webmoney_all'
    return [self.class.paypal] if short_name == "credit_card"  
    return [self]
  end

  def minimum_possible
    #TODO: introduce inheritance here and move it to YandexMonetaryProcessor
    if short_name == 'yandex'
      0.05
    else
      0.01
    end
  end
end
