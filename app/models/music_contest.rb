class MusicContest < BasicFolderWithDownloadables

  has_one :details, :class_name => 'MusicContestDetails', :foreign_key => 'content_id', :dependent => :destroy
  after_save {|x| x.details.save if x.details.changed?}

  has_many :submissions, :class_name => 'ContestSubmission', :foreign_key => 'contest_id'
  
  validates_presence_of     :title
  delegate :create_terms_acceptance, :need_terms_acceptance_of, :to => :details
  
  def entity_name_for_human
    #'Music Contest'.t
    'Music Contest'
  end

  def number_of_tracks
    album_contents_items.count(:include => :content, :conditions => ["type = 'Track'"])
  end

  def downloadable?
    !bundles.empty?
  end

  def album_menu_item_caption
    "#{self.title_short(25)} ('Music Contest'.t})"
  end

  def inclusion_allowed?(content_to_include)
    return content_to_include.new? && accepts_submissions? 
  end

  def commentable?
    self.active?
  end

  def details_object
    details || build_details
  end

  %w(accepts_submissions start_date end_date).each do |attr_name|
    delegate attr_name.to_sym,       :to => :details_object
    delegate "#{attr_name}=".to_sym, :to => :details_object
  end
  delegate :accepts_submissions?, :to => :details_object

  %w(second_title).map{|field| [field, "_#{field}", "#{field}_ru"]}.flatten.each do |attr_name|
    delegate attr_name.to_sym,       :to => :details_object
    delegate "#{attr_name}=".to_sym, :to => :details_object
  end

  def cover_art
    result = super
    result ||= Content.find_by_id(APP_CONFIG.music_contest_default_cover)
    result ||= Image.active.first 
    result
  end
  
  def navigation_within_parent(parent_id)
    # For contests, only page between other contests
    Album.navigation(self, :what_we_are_iterating_over => self.user.all_contents.music_contests.all(:order => 'id'))
  end

  LATEST_TRACKS_ORDER_NAME = 'latest'
  POPULAR_TRACKS_ORDER_NAME = 'popular' 

  def tracks_at_level(level, options = {}, pagination_options = {})

    sql = 'SELECT contents.*, contest_submissions.level, count(votes.id) votes_count FROM contents ' +
           'INNER JOIN album_items ON contents.id = album_items.content_id ' +
           'INNER JOIN contest_submissions ON contest_submissions.content_id = contents.id ' +
           'LEFT JOIN votes ON votes.type = \'UpVote\' and votes.voteable_id = contents.id AND votes.voteable_type = \'Content\' ' +
           'WHERE (album_items.album_id = %s) and contents.type = \'Track\' and level >= %s ' +
           'GROUP BY contents.id'

    sql = sql % [self.id, level]

    order = options.delete(:order)
    if order.to_s == LATEST_TRACKS_ORDER_NAME
      sql += ' ORDER BY contents.created_at desc'
    elsif order.to_s == POPULAR_TRACKS_ORDER_NAME
      sql += ' ORDER BY votes_count desc, contents.created_at desc'
    end
    
    result = pagination_options.empty? ? Content.find_by_sql(sql) : Content.paginate_by_sql(sql, pagination_options) 
    result
  end

  def tracks
    tracks_at_level(-1)
  end
  
  def action_cache_key_suffix(controller)
    key = [updated_at.to_i, comment_count]

    latest_bundle = bundles.find(:first, :order => 'updated_at desc')
    key << (latest_bundle ? latest_bundle.updated_at.to_i : nil)
    
    last_submission_updated = submissions.find(:first, :order => 'updated_at desc')
    key << (last_submission_updated ? last_submission_updated.updated_at.to_i : nil)

    controller.params[:order] ||= LATEST_TRACKS_ORDER_NAME
    controller.params[:select_level] ||= -1
    
    key << controller.params[:order]
    key << controller.params[:select_level]
    key << controller.params[:page] || 1
    key << controller.getpagesize

    key
  end

  def update_specific_params(params)
    if params[:bundles] && params[:bundles].is_a?(Hash)
      params[:bundles].each do |bundle_id, attribs|
        bundle = Bundle.find_by_id(bundle_id)
        next unless bundle #it could be deleted in another browser session, so it's legal
        bundle.update_attributes(attribs)
      end
    end

    TermsAndConditions.create_or_update!(params[:terms], details)
  end

  def multiple_uploader_needed?(kind = nil)
    false
  end

  protected

end
