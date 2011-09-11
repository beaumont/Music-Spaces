module CashHandler
  
  # Parses exchanges rates sourced from x-rates.com
  class Parser
    class << self
      
      # Fetches a hash of up-to-date rates from x-rates.com
      def fetch_rates
        doc = Hpricot(open('http://www.x-rates.com/d/USD/table.html'))
        
        result = CashHandler::CURRENCIES.inject({}) do |collection, currency|
          code = currency.first
          collection[code] = BigDecimal.new((doc/"a[@href=\"/d/USD/#{code}/graph120.html\"]").html)
          collection
        end
        result.merge!({'USD' => 1})
        if result['RUB'] == 0 || !result['RUB']
          AdminNotifier.async_deliver_admin_alert("Our rates provider doesn't have currency rate for RUB. Quick fix needed!")
          #result.merge!('RUB' => BigDecimal.new('0.032734')) #quickfix for NY issue: no RUB rate shown for Jan 03
        end
        result
      end
    end
  end
end
