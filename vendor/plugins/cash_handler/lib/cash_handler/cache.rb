module CashHandler
  
  # Stores a cache of conversion values as rates against the USD
  class Cache
    CACHE_KEY = 'currency_rates'
    
    # Forces an expiry of the cache
    def expire
      Rails.cache.delete(CACHE_KEY)
    end
    
    # Fetches a cached value for given currency
    def get(code)
      if rates[code]
        rates[code]
      else
        # Can't find a rate by that code
        raise CashHandler::Exception.new("'#{code}' is not a supported currency code")
      end
    end

    protected
    def rates
      Rails.cache.fetch(CACHE_KEY) do
        log.debug "fetching rates!"
        result = CashHandler::Parser.fetch_rates
        result
      end
    end
        

    extend ActiveSupport::Memoizable

    memoize :rates if APP_CONFIG.instance_caching_for_currency_rates

  end
end
