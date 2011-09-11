class BasicFolderWithDownloadables < Album
  has_many :bundles, :foreign_key => 'downloadable_album_id', :conditions => "type='Bundle'"
  validates_numericality_of :year, :if => lambda {|a| !a.year.blank?} 
  has_one :contribution_setting, :foreign_key => 'content_id'

  def before_save
    self['artist'] ||= self.author.login if self.respond_to?(:author) && self.author # respond_to to keep migrations happy
  end

  # Create bundle (downloadable zip file)
  def set_or_update_bundle(params)
    if params[:id] && bundle = bundles.find_by_id(params[:id])
      bundle.attributes = params
      bundle.editing_file = true
      bundle.save!
    else
      b = bundles.build(params)
      b.init(self)
      b.save!
    end
  end

  def unpublished?
    self.relationshiptype_id == Relationshiptype.founders
  end

  def full_filename
    self.filename
  end

  #can't see why it's so
  #def get_all_contents_of_album(alb)
  #  return alb.album_contents
  #end

  def has_image?
    !images.empty?
  end

  def images
    @images ||= album_contents.select {|x| x.is_a? Image}
  end

  # Because it's a subclass of album
  def self.find_or_create_featured_for(user)
    raise Kroogi::NotPermitted
  end

  # alias_method :css, :post
  alias_method :random_image, :cover_art

  def action_cache_key_suffix(controller)
    dl_flag = controller.user_has_downloaded?(self)
    suffix = dl_flag ? 'dl' : 'not_dl'
    super(controller) + [suffix]
  end

  def downloadable?
    true
  end

  def album_menu_item_caption
    "#{self.title_short(25)} (#{'Downloadable'.t})"
  end
  
  def min_contribution_amount
    return nil unless contribution_setting
    contribution_setting.min_amount
  end

  def recommended_contribution_amount
    return nil unless contribution_setting
    contribution_setting.recommended_amount
  end

  def save_contribution_settings(params)
    build_contribution_setting unless contribution_setting
    contribution_setting.attributes = params[:contribution_setting] || {}
    contribution_setting.update_attribs_from_view
    contribution_setting.save!
  end

  def need_terms_acceptance_of(user)
    false
  end

end