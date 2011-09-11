module ControllerCachingMixin
  def escape_cache_key(value)
    #important for memcached and file_store
    value = value.to_s unless value.is_a?(String)
    value.gsub(' ', '+').gsub("\t", '+')
  end

  def hash_to_cache_key_array(params)
    params.to_a.sort_by {|key, value| key.to_s}.map {|key, value| escape_cache_key("#{key}=#{value}")}
  end
  
  def maybe_shorten_cache_key(result)
    limit = Rails.cache.is_a?(ActiveSupport::Cache::FileStore) ? 128 : 250 - 30
    if result.length > limit
      result = Digest::MD5.hexdigest(result) #not very good because it's not 1to1; still better than truncating and such cases are assumed to be more for evil bots
    end
    result
  end

  def guest_partial_cache_key(partial_name, params)
    params = params.map {|key, value| [key, value.is_a?(ActiveRecord::Base) ? value.id : value]}
    result = ([Kroogi.translation_mtime.stamp, I18n.language_code, partial_name] +
            hash_to_cache_key_array(params)).map{|p| escape_cache_key(p)}.join("/")
    log.debug "guest_partial_cache_key is #{result}"
    shorten = maybe_shorten_cache_key(result)
    log.debug "shorten guest_partial_cache_key is #{shorten}" unless shorten == result
    shorten
  end
end