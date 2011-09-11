class Admin::DigitalDownloadController < Admin::BaseController  
  before_filter :load_owner,   :only => [:new, :create]
  before_filter :load_content, :only => [:edit, :publish, :preview, :destroy, :update]
  before_filter :load_tracks,  :only => [:new, :edit, :create, :update]

  in_place_edit_for :preset_terms_and_conditions, :title
  in_place_edit_for :preset_terms_and_conditions, :title_ru
  in_place_edit_for :preset_terms_and_conditions, :body
  in_place_edit_for :preset_terms_and_conditions, :body_ru
  
  # Return the body as-is, without stripping HTML code
  def unformatted_terms_body
    render_unformatted_field(PresetTermsAndConditions.find(params[:id]), :body)
  end
  
  def index
    list
    render :action => 'list'
  end

  def list
    @albums = Content.paginate :per_page => 25, :page => params[:page], :order => 'popularity desc, id asc',
                               :conditions => ['type in (?)', [MusicAlbum.name, FolderWithDownloadables.name]]
    
    @tracks = Track.downloadable.paginate :per_page => 25, :page => params[:track_page]
    @terms = PresetTermsAndConditions.find(:all)
    @weekly_top = Content.weekly_top_contributions(:limit => 25)
  end
  
  def add_terms
    redirect_to(:action => :index) and return unless request.post?
    
    @terms_and_conditions = PresetTermsAndConditions.new(params[:terms_and_conditions])
    if @terms_and_conditions.save
      flash[:success] = 'Added your new terms'.t
    else
      flash[:warning] = 'Error adding your new terms!'.t
    end
    list
    render :action => 'list'
  end
  
  def delete_terms
    @terms = PresetTermsAndConditions.find(params[:id])
    if @terms.owning_folders.count > 0
      flash[:warning] = "Can only delete terms that are not being used"
    else
      @terms.destroy
      flash[:success] = "Removed '%s'" / [@terms.title]
    end
    redirect_to :action => :index
  end
  
  def new
    @content = FolderWithDownloadables.new
    @content.author = @user
    raise Kroogi::NotPermitted unless @content.author
    @content.user_id = @user.id
    @content.user = @user
    @content.is_in_startpage = false
    @content.is_in_gallery = false
    @selected_tracks = []
  end
  
  # Downloadable track, NOT in rainbows. Given a track_id, make that track downloadable
  def start_download
    @track = Track.find_by_id(params[:track_id])
    if @track.nil? then flash[:error] = 'No track exists with ID %s' / [h(params[:track_id])]
    elsif !@track.public? then flash[:error] = 'The specified track ("%s") is not publicly viewable' / [@track.title_short]
    elsif @track.downloadable? then flash[:warning] = 'The specified track ("%s") was already downloadable' / [@track.title_short]
    else 
      params[:track_id] = nil # Don't autofill the text field if it's already been added
      @track.toggle_downloadable!(true)
      flash[:success] = 'The specified track ("%s") has been marked as downloadable' / [@track.title_short]
    end
    redirect_to :action => :list, :track_id => params[:track_id]
  end

  # Downloadable track, NOT in rainbows. Given a track_id, make that track NOT downloadable
  def stop_download
    @track = Track.find_by_id(params[:track_id])
    if @track.nil? then flash[:error] = 'No track exists with ID %s' / [h(params[:track_id])]
    elsif !@track.public? then flash[:error] = 'The specified track ("%s") is not publicly viewable' / [@track.title_short]
    elsif !@track.downloadable? then flash[:warning] = 'The specified track ("%s") was already not downloadable' / [@track.title_short]
    else 
      params[:track_id] = nil # Don't autofill the text field if it's already been added
      @track.toggle_downloadable!(false)
      flash[:success] = 'The specified track (%s - "%s") is no longer downloadable' / [@track.id, @track.title_short]
    end
    redirect_to :action => :list, :track_id => params[:track_id]
  end

  def toggle_visiblity_for_non_eng
    @content = Content.find_by_id(params[:content_id])
    if @content.nil? then flash[:error] = 'No Content exists with ID {{id}}' / [h(params[:content_id])]
    else
      if @content.content_i18n
        @content.content_i18n.update_attribute(:hide_from_eng_top, params[:hide_from_eng_top])
      else
        ContentI18n.create(:content_id => @content.id, :hide_from_eng_top => params[:hide_from_eng_top])
      end
      expire_weekly_top_cache
      visibility = (params[:hide_from_eng_top] == '1') ? 'hided' : 'visible'
      flash[:success] = "The specified music albums ({{id}} - '{{title}}') is now #{visibility} for non-english user (explore page)" / [@content.id, @content.title_short]
    end
    redirect_to :action => :list
  end

  def edit
    @selected_tracks = @content.album_contents.empty? ? [] : @content.album_contents.collect{|preview| preview.id}
    render :action => 'new'
  end
  
  def publish
    if request.post?
      Content.transaction do
        @content.attributes = params[:content]
        # featured album assignment/removal
        in_featured_album = @content.albums.detect{|album| album.featured_album?}
        if !in_featured_album && @content.is_in_startpage
          @content.albums << Album.active.find_or_create_featured_for(@content.user)
        elsif in_featured_album && !@content.is_in_startpage
          @content.remove_from_album(in_featured_album)
        end
        @content.save!
        @content.update_security_of_children
        if params[:send_message]
          Activity.send_message(@content, @content.author, :published_album)
        end
      end
      redirect_to :action => "list"
    end
  end
  
  def preview
  end

  
  def create
    @content = FolderWithDownloadables.new(params[:content])
    begin
      Content.transaction do
        @content.user_id = @user.id
        @content.cat_id = Content::CATEGORIES[:album][:id]
        @content.created_by_id = @content.author_id
        @content.relationshiptype_id = Relationshiptype.nobody
        @content.save!
        
        unless params[:album_content].blank?
          Track.active.find(params[:album_content]).each do |preview|
            preview.albums << @content
            preview.save!
          end
        end

        @content.set_or_update_cover_art(params[:cover_art])
        @content.set_or_update_cover_art(params[:file_bundle])
      end
      redirect_to :action => "list"
    rescue => exception
      logger.debug " #{exception.inspect} #{exception.backtrace.join()}"
      render :action => 'new'
    end

  end
  
  
  def update
    Content.transaction do
      @content.attributes = params[:content]
      @content.save!
      
      unless params[:file_bundle][:uploaded_data].blank?   
        @content.bundle.first.attributes = params[:file_bundle]
        @content.bundle.first.editing_file = true
        @content.bundle.first.save!
      end
      
      unless params[:cover_art][:uploaded_data].blank?   
        @content.cover_art.attributes = params[:cover_art]
        @content.cover_art.editing_file = true
        @content.cover_art.save!
      end
      
      
      # preview track list editing, non destructive, would've been simpler to just replace, but wanna preserve order
      # if no edit to track list is made
      found = []
      unless params[:album_content].blank?
        Track.active.find(params[:album_content]).each do |preview|
          if @content.album_contents.detect{|existing_preview| existing_preview.id == preview.id}.nil?
            preview.albums << @content
            preview.save!
          else
            found << preview.id
          end
        end
      end
      @content.album_contents.select{|existing_preview| found.include?(existing_preview.id) == false}.each do |delete_preview|
        delete_preview.remove_from_album(@content)
      end
      
    end
    redirect_to :action => "list"
  end
  
  

  def destroy
    begin
      Content.transaction do
        @content.album_contents.each do |member|
          member.destroy unless member.is_a?(Track)
        end
        @content.album_contents.each {|x| x.remove_from_album(self) }
        @content.destroy
      end
    rescue => e
      just_notify(e)
      flash[:error] = 'Sorry, the deletion failed, please try again'.t
    end
    redirect_to :action => 'list'
  end
  
  def content_attrib
    content = Content.find(params[:id])
    render :text => content.read_attribute(params[:attrib])
  end

  def set_content_attrib
    content = Content.find(params[:id])
    attrib = params[:attrib]
    previous = content.read_attribute(attrib)
    value = params[:value]
    content.write_attribute(attrib, value)
    value = previous unless content.save_without_validation
    render :partial => "/shared/in_place_value", :object => value
  end


  protected
  
  def load_owner
      return @user if @user
      @user = @content.user if @content && !@content.user_id.nil?
      unless @user
        uid = User.find_by_login(params[:projectname]) if params[:projectname]
        uid ||= params[:content][:user_id] if params[:content]
        raise Kroogi::NotPermitted unless uid
        @user = User.active.find(uid)
      end
      return @user
  end  
  
  def load_content
      content_id = params[:content][:id] unless params[:content].blank?
      content_id ||= params[:id] if params[:id]
      raise Kroogi::NotPermitted unless content_id
      @content = Content.active.find(content_id)
      load_owner
  end
  
  def load_tracks
    @tracks =  Track.active.find(:all, :limit => 250, :order => 'title', :conditions => ['user_id = ? and title is not null', @user.id])
  end

  # Force english -- otherwise translations don't work
  def set_locale
    Locale.set 'en-US'
  end

  def expire_weekly_top_cache
    [APP_CONFIG.hostname, APP_CONFIG.ru_host].each do |domain|
      ['en', 'ru'].each do | lang |
        expire_fragment(weekly_top_section_key(lang, domain))
      end
    end
  end

end
