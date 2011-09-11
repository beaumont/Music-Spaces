module LegacyIdHash
  extend self
  DIVIDER     = ']['

  def decode(id_or_hash)
    return nil if id_or_hash.blank?
    id_hash = CGI::unescape(id_or_hash)
    grab_ids_from_hash(id_hash)
  end

  # Wrap up user id with a hash
  def id_to_hash(id)
    return "" unless id
    Base64.encode64(id.to_s + DIVIDER + encode(id)).chomp
  end

  # Returns user_id if successfully extracted from hash -- else, returns nil
  def id_from_hash(h)
    return nil if h.blank?
    # new format
    return h.to_i if h =~ /^[0-9]*$/
    # old format
    (uid, *code) = Base64.decode64(h).split(DIVIDER)
    code = code.join(DIVIDER)
    code == encode(uid) ? uid.to_i : nil
  end

  protected
  def grab_ids_from_hash(id_hash)
    id_hash.split(';').collect{ |h| id_from_hash(h) }
  end

  def encode(id)
    Digest::SHA256.digest("#{id} -- #{hash_secret}")
  end

  def hash_secret
    APP_CONFIG.legacy_id_hash_secret
  end
end
