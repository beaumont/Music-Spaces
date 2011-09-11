class EncodingDetector

  def new_guess_encoding(data)

    require 'rchardet'

    t0 = Time.now
    cd = CharDet.detect(data)
    encoding = cd['encoding']
    confidence = cd['confidence'] # 0.0 <= confidence <= 1.0
    return cd
  end

  def old_guess_encoding(data)

    require 'UniversalDetector'

    t0 = Time.now
    cd = UniversalDetector::chardet(data)
    encoding = cd['encoding']
    confidence = cd['confidence'] # 0.0 <= confidence <= 1.0
    return cd
  end

  def detect(data, options = {})
    rnew = new_guess_encoding(data)
    rold = old_guess_encoding(data)
    log.debug "new, old detector's results: #{[rnew, rold].inspect}"
    info = (rold['confidence'] || 0) >= rnew['confidence'] ? rold : rnew
    win1251_encoding = 'windows-1251'
    if [rnew, rold].any?{|hash| hash['encoding'] == win1251_encoding}
      info['encoding'] = win1251_encoding
      info['confidence'] = 10.0 #priority encoding
    end
    result = options[:extended] ? info : info['encoding']
    log.debug "result for #{data}: #{result.inspect}"
    result
  end

  def self.instance
    @@instance ||= EncodingDetector.new
  end

  def decode(string, source_encoding = nil)
    source_encoding = detect(string) if !source_encoding
    Iconv.iconv('utf-8', source_encoding, string).first
  rescue => e
    log.warn "coudn't decode data %s from encoding %s: %s" % [string, source_encoding, e.inspect]
    if source_encoding == 'utf-8'
      false
    else
      #may be it was utf?
      decode(string, 'utf-8')
    end
  end
end