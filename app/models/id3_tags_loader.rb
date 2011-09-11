require 'mp3info'
module Id3TagsLoader
    def detect_encoding(values)
      values = values.select {|v| !v.blank?}
      decoder = EncodingDetector.instance
      encodings = values.map{|value| decoder.detect(value.to_s, :extended => true)}
      weights = {}
      encodings.each do |info|
        weights[info['encoding']] ||= 0
        weights[info['encoding']] += info['confidence'] if info['confidence'] > 0.6 
      end

      #we assume combinations of utf and non-utf (non-latinic) field encodings don't happen

      #select non-latinic encodings
      nonlatinics = encodings.map {|e| e['encoding']}.select {|e| e != 'ascii'}
      #find encoding with max confidence
      e = nonlatinics.max {|a, b| weights[a] <=> weights[b]}
      #it's nil if there's no non-latinic fields
      e || 'ascii'
    end

    def decode_id3_tags(filepath)
      begin
        info = Mp3Info.new(filepath)
      rescue => e
        log.debug "Mp3Info couldn't parse the file - probably header or tail was too short. Underlying exception: #{e.inspect}"
        return {}
      end

      data = {:title => info.tag.title, :artist => info.tag.artist, :album => info.tag.album}

      return {} if data.values.all? {|x| x.blank?}
      encoding = self.detect_encoding(data.values)
      decoder = EncodingDetector.instance
      data.map do |key, value|
        value = decoder.decode(value.to_s, encoding)
        value = nil if value == false #decoding failure case. we don't want to pass undecoded string here 'cause it can break SQL statement (resulting in upload failure)
        value = value.chars[1..-1] if value && value.to_json.starts_with?("\"\\ufeff")
        [key, value]
      end.reject {|key, value| value.blank?}.to_hash.merge(:genre => info.tag.genre_s, :year => info.tag.year)
    end
    
    def load_id3_tags
      if !self.temp_path.blank? && File.exists?(self.temp_path)
        #tag = ID3Lib::Tag.new(track.temp_path)
        # logger.debug "Tag #{tag.inspect}"
        # switching to Mp3Info for tag extraction, since it's encoding-aware and we're using it already anyway - AK
        # unless true # WAS: tag.empty?
        #    track.title = tag.title
        #    track.artist = tag.artist
        #    track.album = tag.album
        #    track.year = tag.year
        #    track.genre = tag.genre
        # end

        #we don't specify output :encoding here because we want to do the
        #  convertation ourselves
        info = Mp3Info.new(self.temp_path)
        # logger.debug info.inspect
        self.bitrate = info.bitrate
        self.samplerate = info.samplerate
        self.length = info.length.to_i
        self.chanels = info.channel_mode

        self.title  = info.tag.title
        self.artist = info.tag.artist
        self.album  = info.tag.album
        self.genre  = info.tag.genre_s
        self.year = info.tag.year

        self.attributes = decode_id3_tags(self.temp_path)

        logger.info self.inspect

      else
        logger.error "[Track] This should never happen for #{self.temp_path}"
      end
    end
end