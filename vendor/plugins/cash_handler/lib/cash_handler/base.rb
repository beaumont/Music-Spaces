module CashHandler
  class Base
    include Singleton

    # Init the CashHandler (and cache)
    def initialize
      @cache = CashHandler::Cache.new
    end
    
    # Fetches the exchange rate of a currency against the USD
    def get(code, options={:against => :usd})
      code = normalize_code(code)
      against = normalize_code(options[:against])
      return 1 if code == against
      @cache.get(code) / @cache.get(against)
    end
    
    # Converts a value from one currency to another
    def convert(value, from, to)
      return value if !value || value == 0
      value * get(from, :against => to)
    end

    def normalize_code(code)
      code = code.to_s.upcase
      code = 'RUB' if code == 'RUR'
      code
    end

    def reload_cache
      @cache.expire
      @cache.get('USD')
    end
  end
end
