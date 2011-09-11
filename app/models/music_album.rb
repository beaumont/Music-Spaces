require 'utils/file'
class MusicAlbum < BasicFolderWithDownloadables

  validates_length_of :genre, :maximum => 60, :allow_blank => true

  has_many :tracks, :class_name => "Track",
   :finder_sql => 'SELECT contents.* FROM contents INNER JOIN album_items ON contents.id = album_items.content_id ' +
           'WHERE (album_items.album_id = #{id}) and type = \'Track\' order by position asc'


  def entity_name_for_human
    # 'Music Album'.t
    'Music Album'
  end

  def number_of_tracks
    album_contents_items.count(:include => :content, :conditions => ["type = 'Track'"])
  end

  def downloadable?
    !bundles.empty?
  end

  def album_menu_item_caption
    "#{self.title_short(25)} (#{self.downloadable? ? 'Downloadable Music Album'.t : 'Music Album'.t})"
  end

  def generate_zip
    t0 = Time.now

    raise "ALbum shouldn't have bundles yet" unless self.bundles.blank?
    album_path = '%s/tmp/music_album_zips/%s' % [RAILS_ROOT, self.id] 
    FileUtils.mkdir_p album_path
    clear_dir(album_path)
    tracks = self.tracks.to_a
    make_album_txt_files('%s/%s' % [album_path, 'readme_%s.txt'])
    if cover_art
      filepath = '%s/%s' % [album_path, cover_art.filename]
      fetch_content_to_file(cover_art, filepath)
    end
    tracks.each_with_index do |track, i|
      filepath = "%s/track#{track_index_padding(tracks.size)}.mp3" % [album_path, i + 1]
      fetch_content_to_file(track, filepath)
    end
    archive_name = '%s_album_%s.zip' % [self.user.login, self.id]
    Utils::File.pack_to_zip(album_path, :archive_name => archive_name)
    zip_bundle = Bundle.new(:content_type => 'application/zip', :filename => archive_name, :user_id => user_id)

    zip_bundle.temp_path = album_path + '/' + archive_name
    self.bundles << zip_bundle
    `rm -rf #{album_path}`
    
    log.info "%s finished in %ss" % ['generate_zip', Time.now - t0]
  end

  def clear_dir(path)
    `rm -f #{path}/*`
  end

  def fetch_content_to_file (track, filepath)
    cmd = "wget -O #{filepath} #{track.public_filename}"
    if track.class.attachment_options[:storage] == :file_system #this happens in Dev env if there's :avoid_s3 option 
      cmd = "cp %s/public%s %s" % [RAILS_ROOT, track.public_filename, filepath]
    end
    `#{cmd}`
  end

  def editable?
    result = super
    result = !downloadable? if result
    result
  end

  def inclusion_allowed?(content_to_include)
    return false if !super(content_to_include)
    return false unless content_to_include.is_a?(Track)
    return false if self.downloadable?
    true
  end

  def donation_button_label
    downloadable? ? 'Download'.t : 'Listen'.t
  end

  def qualify_for_fb(options = {})
    options.reverse_merge! :must_be_downloadable => true
    
    result = self.user.identity_verified?
    result &&= self.public?
    result &&= self.active?
    result &&= self.downloadable? if options[:must_be_downloadable]
    result &&= self.user.public?
    result
  end

  def commentable?
    self.active?
  end

  def self.facebook_albums(*args)
    options = (args.length > 0) ? args.pop : Hash.new
    options.assert_valid_keys :per_page, :page, :conditions, :cumulative

    conditions = options.delete(:conditions) == 'new' ? 'created_at' : 'popularity'
    order_by = "ORDER BY contents.#{conditions} DESC" if conditions

    select = <<-EOSQL
        SELECT DISTINCT contents.* FROM contents
        INNER JOIN users u ON u.id = contents.user_id AND u.private = 0
             INNER JOIN account_settings a ON u.id = a.user_id
             INNER JOIN monetary_processor_accounts mpa ON mpa.account_setting_id = a.id
                AND mpa.verified_at IS NOT NULL
        INNER JOIN contents bundles on bundles.downloadable_album_id = contents.id and bundles.type = 'Bundle'
        WHERE contents.type = 'MusicAlbum' AND contents.relationshiptype_id = '-2'
          AND contents.state = 'active' AND contents.title is not null and contents.title != ''
        #{order_by}
    EOSQL
    options[:page]       ||= 1
    args.push options
    self.paginate_by_sql(select, *args)
  end

  def tracks_bitrate
    tracks.first && tracks.first.bitrate
  end

  def tracks_length
    tracks.map{|track| track.length || 0 }.sum
  end

  def multiple_uploader_needed?(kind = nil)
    false unless super
    true if kind.nil? || kind == :tracks
  end

  def verbose_param_parts
    artist = self.artist.strip if self.artist
    artist = self.user.display_name if artist.blank? 
    [Russian.translit(artist), Russian.translit(self.title_short(40, false)), self.year || self.created_at.year]
  end

  protected

  def build_album_txt_file(locale)
    template = File.open("#{RAILS_ROOT}/app/views/music_album/readme.txt.erb", 'r') { |f| f.read }
    res = nil
    Locale.with_locale(locale) do
      ERB.new(template, 0, "", "res").result binding
    end
    res
  end
  
  def make_album_txt_files(path)
    ['en', 'ru'].each do |locale|
      str = build_album_txt_file(locale)
      lpath = path % locale
      File.open(lpath, 'w') {|f| f.write(str)}
    end
  end

  def track_index_padding(count)
    digits = 2
    digits = 3 if count >= 100
    digits = 4 if count >= 1000
    "%0#{digits}d"
  end

end
