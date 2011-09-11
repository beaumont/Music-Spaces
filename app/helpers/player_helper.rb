module PlayerHelper
  def player_vars(tracks, options = {})
    album_id = options[:album_id]
    tsparams = []
    options.each do |key, value|
      tsparams << "#{key}=#{value}"       
    end
    tracks.each_with_index do |t,i|
      i += 1
      unless t.length.nil?
        q, r = t.length.divmod(60)
        duration = "songduration#{i}=" + q.to_s + ":" + format('%02d', r.to_s)
      end

      tsparams << "trackid#{i}=#{t.id}"
      tsparams << duration if duration
      tsparams << [['songtitle', t.title], ['songartist', t.artist], ['songurl', t.public_filename]].map do |name, value|
        "#{name}#{i}=#{CGI::escape(value.to_s)}"
      end
    end
    tsparams.join("&")
  end

  def player_height(tracks)
    tracks.count > 1 ? 153 : 118
  end

  def player_height_for_fb(entry)
    tracks = [entry] if entry.is_a?(Track)
    tracks = entry.tracks if entry.is_a?(Album)
    tracks ||= []
    tracks.count > 1 ? 150 : 115
  end

  #
  # accepted options:
  # :album_id
  # :track_id (mutually exclusive with :album_id)
  # :entry (that is transformed to one of above internally)
  # :tracks (alternative to :album_id/:track_id for other cases) 
  # :only_public - flters out non-public tracks (default is false)
  # :allow_blocked - allows blocked tracks (default is false)  
  def calc_playlist_vars_by_options(data_options)
    entry = data_options.delete(:entry)
    data_options[:album_id] = entry.id if entry.is_a?(Album) && entry.player_embeddable?
    data_options[:track_id] = entry.id if entry.is_a?(Track)
    vars = {}
    contest_mode = data_options[:contest_mode]
    if tracks = data_options[:tracks]
      vars[:tracks] = tracks
    end
    if album_id = data_options[:album_id]
      content = Album.find_by_id(album_id)
      return vars unless content
      vars[:tracks] ||= content.tracks
      vars[:id_param] = :album_id
      contest_mode = true if content.is_a?(MusicContest) unless data_options.has_key?(:contest_mode)
    end
    if track_id = data_options[:track_id]
      content = Content.find_by_id(track_id)
      return vars unless content
      vars[:tracks] = [content]
      vars[:id_param] = :track_id
      contest_mode = true if content.music_contest_item? unless data_options.has_key?(:contest_mode)
    end
    vars[:tracks] ||= []
    vars[:tracks] = vars[:tracks].select {|t| t.is_a?(Bundle) || (t.is_a?(Track) && t.is_view_permitted?)} #TODO: it's a hack. make Bundle's is_view_permitted? return true
    vars[:tracks] = vars[:tracks].select {|t| t.public?} if data_options[:only_public] #this is for 'embed this' function
    vars[:tracks] = vars[:tracks].reject {|t| t.blocked?} unless data_options[:allow_blocked]
    vars[:context_album_id] = data_options[:context_album_id] 

    vars[:content] = content if content

    if contest_mode
      vars[:tracks].each do |track|
        artist = truncate(track.artist.strip, :length => 22) if track.artist
        artist = track.created_by.login if artist.blank?
        track.title =  artist + ': ' + (track.title || 'No Title'.t)
      end
      vars[:ui_params] = {:hide_artists => true}
    end

    vars
  rescue Exception => e
    raise "calc_playlist_vars_by_options failed for data: #{data_options.inspect}. Original exception is #{e.inspect}" 
  end

  def playlist_xml_params(options)
    str = render(:partial => "/player/play_list.xml.erb", :locals => options)
    CGI::escape str.squish
  end

  def player_url_for_fb(content)
    player_embed_id_param_name = content.is_a?(Track) ? 'track_id' : 'album_id'
    
    flashvars_param = "playlist_url=" + CGI::escape("http://#{APP_CONFIG.hostname}/player/embedded_play_list.xml?" +
            "#{player_embed_id_param_name}=#{content.id}&player_mode=facebook_embedded")
    
    "http://kroogi.com/flash/#{RAILS_ENV == 'production' ? '' : 'test/'}audioplayer.swf?#{flashvars_param}"
  end
end
