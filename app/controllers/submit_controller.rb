class SubmitController < ApplicationController

  before_filter :login_required

  before_filter :load_content, :only => [:music, :image, :edit,
    :add_to_inbox__find_user, :add_to_inbox__do_add, :archive_inbox,
    :activate_inbox, :make_downloadable, :generate_zip, :remove_downloads, :edit_album, :change_contest_image,
    :add_contest_originals, :update_bundle_label, :edit_contest_track_properties, :promote_contest_item, :edit_fundbox]

  before_filter :load_any_content, :only => [:delete]

  before_filter :load_owner, :only => [:inbox, :announcement,
    :topic, :blog, :writing, :video, :upload_image, :upload_music, :pvtmsg,
    :album, :project, :music_album, :edit_album, :music_contest, :fundbox,
    :music, :image, :edit, :delete, 
    :add_to_inbox__find_user, :add_to_inbox__do_add, :archive_inbox,
    :activate_inbox, :make_downloadable, :generate_zip, :remove_downloads, :change_contest_image,
    :add_contest_originals, :update_bundle_label, :edit_contest_track_properties
  ]

  before_filter :check_add_permission, :only => [:inbox, :announcement,
    :topic, :blog, :writing, :video, :upload_image, :upload_music, :pvtmsg,
    :album, :project, :music_album, :music_contest, :fundbox,
    :music, :image,
    :add_to_inbox__find_user, :add_to_inbox__do_add, :archive_inbox,
    :activate_inbox,
  ]

  before_filter :check_edit_permission, :only => [:edit_contest_track_properties, :delete, :edit, :edit_album,
    :make_downloadable, :generate_zip, :remove_downloads, :change_contest_image, :add_contest_originals,
    :update_bundle_label]
  
  before_filter :check_undeletability, :only => [:delete]
  before_filter :check_editability, :only => [:edit, :edit_album]

  before_filter :allow_donations_for_content, :only => [:make_downloadable, :generate_zip]
  before_filter :check_contents_when_making_downloadable, :only => [:make_downloadable, :generate_zip]
  before_filter :check_if_already_when_making_downloadable, :only => [:make_downloadable, :generate_zip]
  before_filter :check_money_when_making_downloadable, :only => [:make_downloadable, :generate_zip]

  verify :method => :post, :only => [:delete, :update, :generate_zip, :remove_downloads, :update_bundle_label,
    :promote_contest_item, :add_music, :upload_with_tool, ], :redirect_to => { :controller => '/'}

  skip_before_filter :verify_authenticity_token, :only => [:upload_with_tool]
  prepend_before_filter :set_session_for_tool, :only => [:upload_with_tool]
  after_filter :dump_response, :only => [:upload_with_tool]

  before_filter :fundbox_allowed?, :only => [:edit_fundbox, :fundbox]
  before_filter :fix_dateformat, :only => [:edit_fundbox, :fundbox]

  EMBEDDED_IMAGE_KEY = :embedded_image

  # ==============================================================================
  # = Different from the rest -- adding existing content to other users' inboxes =
  # ==============================================================================

  # Finds the user+inboxes for the ajaxy sidebar search
  def add_to_inbox__find_user
    @other_user = User.active.find_by_login(params[:name])
    already_in = @content.inboxes.map(&:id)
    @avail_inboxes = @other_user.inboxes.select{|x| !already_in.include?(x.id) && !x.archived? && x.accepts?(@content) && x.is_view_permitted?} if @other_user
  end

  # Actually adds content item to inbox from ajax sidebar. Called by itself, or from other methods
  def add_to_inbox__do_add
    @inbox = params[:inbox] ? Inbox.active.find(params[:inbox]) : @for_inbox
    if @inbox && @inbox.accepts?(@content) && !@content.inboxes.include?(@inbox) && !@inbox.archived?
      @inbox_item = InboxItem.new(:inbox_id => @inbox.id, :content_id => @content.id,
         :allow_take_to_showcase => @inbox.require_allowing_content_adoption? ? true : params[:allow_take_to_showcase],
         :user_id => current_actor.id, :original_content_id => @content.original_content_id)
      if @inbox_item.save
        Activity.send_message(@inbox_item, current_actor, :submitted_to_inbox)
        Activity.send_message(@inbox_item, current_actor, :inbox_submission_received)
      else
        respond_to do |wants|
          wants.html { flash[:warning] = "Your content has been added to your account, but not to '{{name}}' inbox. Reason: {{reason}}" / [@inbox.title, @inbox_item.errors.full_messages.join(';')]}
          wants.js {}
        end
      end
    end
  end
  
  def add_user_to_collection_inbox
    unless user = User.find_by_login(params[:login])
      flash[:warning] = 'Unable to find a user with the specified Kroogi name'.t
      redirect_to(:controller => 'content', :action => 'show', :id => params[:id]) and return
    end
    
    inbox = Inbox.active.find(params[:inbox])
    unless inbox && inbox.user.collection?
      flash[:warning] = 'The specified inbox does not exist, or does not accept Kroogi users as submissions'.t
      redirect_to(:controller => 'content', :action => 'show', :id => params[:id]) and return
    end
    
    if inbox.contains_user?(user) || user == inbox.user
      flash[:warning] = 'The specified user has already been submitted to this inbox'.t
      redirect_to(:controller => 'content', :action => 'show', :id => params[:id]) and return
    end
    
    new_item = ProjectAsContent.new(:body_project_name => params[:login], :user_id => current_actor, :cat_id => Content::CATEGORIES[:project][:id])
    new_item.save!
    inbox_item = InboxItem.new(:inbox_id => inbox.id, :content_id => new_item.id, :allow_take_to_showcase => true,
                               :user_id => current_actor.id, :original_content_id => new_item.original_content_id)
    if inbox_item.save
      Activity.send_message(inbox_item, current_actor, :submitted_to_inbox, {:to_user => current_actor})
      Activity.send_message(inbox_item, current_actor, :inbox_submission_received, {:to_user => inbox.user})
    end
    # "Successfully added user '%s' to the inbox of collection".t
    # "Successfully added project '%s' to the inbox of collection".t
    # "Successfully added collection '%s' to the inbox of collection".t
    flash[:success] = "Successfully added #{user.entity_name_for_human} '%s' to the inbox of collection" /
      [user.login]
    redirect_to(:controller => 'content', :action => 'show', :id => params[:id]) and return
  end
  
  # Remove the specified item from the specified inbox (accessible to both content and item owners)
  def remove_from_inbox
    @content = Content.active.find(params[:id])
    @inbox = Inbox.active.find(params[:inbox_id])
    
    # Can only remove from active (not archived) inboxes, and then only if you own the content or the inbox
    raise Kroogi::NotPermitted unless !@inbox.archived? && current_actor.is_self_or_owner?(@content.user, @inbox.user)
    @content.remove_from_inbox(@inbox)
    flash[:success] = "Removed '%s' from '%s'" / [@content.title_long, @inbox.title_long]
    redirect_to content_url(current_actor.is_self_or_owner?(@inbox.user) ? @inbox : @content)
  end
  
  # Adopt content (create a copy of the specified content item for the inbox owner)
  def adopt_from_inbox
    @content = Content.active.find(params[:id])
    @inbox = Inbox.active.find(params[:inbox_id])
    @album = Album.active.find_by_id(params[:target_id])
    @album = nil unless @album && current_actor.is_self_or_owner?(@album.user)
    @album ||= current_actor.featured_album if @content.is_a?(ProjectAsContent)

    if @inbox.get_connector(@content).allow_take_to_showcase?
      @new_copy = @content.clone_content_from_inbox(@inbox)
      @new_copy.assign_to_album(@album) if @album
      flash[:success] = "Copied '%s' to %s" / [@content.title_long, @album ? @album.title_long : 'your Content'.t]
      redirect_to @inbox.user.collection? ? userpage_path(@inbox.user) : content_url(@new_copy)
    else
      flash[:warning] = "Error attempting to copy '%s' to your Content" / [@content.title_long]
      redirect_to content_url(@inbox)
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:warning] = "Error attempting to copy '%s' to your Content: %s" / [@content.title_long, e.message]
    redirect_to content_url(@inbox)
  end
  
  # Archive the inbox so nothing new can be added/removed
  def archive_inbox
    flash[:success] = @content.archived? ? "Folder is already archived".t : ("Archived folder '%s'" / [@content.title_long])
    @content.update_attribute(:archived, true)
    redirect_to content_url(@content)
  end
  
  # Activate (unarchive) inbox so items can again be added/removed
  def activate_inbox
    flash[:success] = !@content.archived? ? "Folder is already active".t : ("Activated folder '%s'" / [@content.title_long])
    @content.update_attribute(:archived, false)
    redirect_to content_url(@content)
  end

  def add_project
    multiple_or_single_content(params[:content]) do |id, data|
      data.delete('album_id')
      @content = ProjectAsContent.new(data)
      @content.cat_id = Content::CATEGORIES[:project][:id]
      check_if_uploading_to_inbox
      author = load_owner
      check_add_permission
      @content.user_id = author.id
      @content.is_in_gallery = true
      @content.is_in_startpage = true
      begin
        Content.transaction do
          @content.assign_to_featured_album
          @content.save! if @content.new?
          @content.make_container_interested if !author.private?
          Activity.send_message(@content, author, :added_project_to_collection)
          add_to_inbox__do_add
        end
        msg = "Successfully added " + @content.body_project.
          entity_name_for_human  + " '%s' to this collection"
        
        flash[:success] = msg / @content.title
        redirect_to user_path_options(@content.user)
      rescue ActiveRecord::RecordInvalid
        render :action => :project, :new => true
      rescue => exception
        flash[:error] = 'Sorry, this operation failed, please try again'.t
        just_notify(exception)
        render :action => 'project', :new => true
      end
    end
  end

  # =========================================
  # = First screens for various media types =
  # =========================================

  def album
    #prepare_new_album extracted for reuse from spec
    prepare_new_album unless @content
  end

  def edit_album
    if params[:no_tracks]
      @album_contents = @content.album_contents_items.all(:include => :content, :conditions => ["contents.type != ?", Track.name])
    elsif params[:only_tracks]
      @album_contents = @content.album_contents_items.all(:include => :content, :conditions => ["contents.type = ?", Track.name])
    end
    log.debug "@album_contents are %s" % @album_contents.inspect
    render :action => :album 
  end

  def music_album
    prepare_new_album(MusicAlbum) unless @content
  end

  def inbox
    unless @content
      @content = Inbox.new
      set_content_defaults
    end
    @content.is_in_gallery = false
  end

  def announcement
    @content = Board.new
    set_content_defaults
    @content.is_in_gallery = false
  end

  def topic
    @content = Board.new(:foruser_id => params[:foruser_id])
    @content.user_id = @user.id
    @content.user = @user
  end

  def blog
    raise 'Not Permitted'
  end

  def writing
    @content = Textentry.new
    @content.cat_id = Content::CATEGORIES[:writing][:id]
    set_content_defaults
    check_if_uploading_to_inbox
  end

  def video
    @content = Video.new
    set_content_defaults
    check_if_uploading_to_inbox
  end

  def pvtmsg
    @context_user = User.find_by_id(params[:foruser_id])  # Make kroogi_fluff bar in this users' context
    @context_user = nil unless @context_user && @context_user.active?
    @content = Pvtmessage.new(:foruser_id => params[:foruser_id])
    @content.user_id = @user.id
    @content.user = @user
  end

  def project
    @content = ProjectAsContent.new
    set_content_defaults
    check_if_uploading_to_inbox
  end

  def music
    @content.is_in_gallery = true
    @content.is_in_startpage = !@content.albums.detect{|a| !a.featured_album?}
    @content.update_blank_owner(@user.login)
    check_if_uploading_to_inbox
  end

  def image
    if @content.cat_id == Content::CATEGORIES[:image][:id]
      @content.is_in_startpage = !@content.albums.detect{|a| !a.featured_album?}
      @content.is_in_gallery = true
    end
    @content.update_blank_owner(@user.login)
    check_if_uploading_to_inbox
  end

  def fundbox
    if request.post?
      uploaded_data = params[:content].delete(:uploaded_data)
      album_id = params[:content].delete(:album_id)
      @content = Tps::Content.new(params[:content].merge(:user_id => current_actor.id, :is_in_gallery => false))
      Content.transaction do
        @content.save!
        upload_images_for_fundbox(uploaded_data)
        @content.assign_to_album(album_id)
        flash[:success] = 'FundBox successfully created.'.t + ' ' + flash[:success].to_s
        redirect_to :action => :edit_fundbox, :id => @content.id
        return
      end
    end
    prepare_new_album(Tps::Content)
    render :action => 'fundbox'
  end

  def edit_fundbox
    if request.post?
      uploaded_data = params[:content].delete(:uploaded_data)
      album_id = params[:content].delete(:album_id)
      Content.transaction do
        @content.update_attributes!(params[:content].merge(:user_id => current_actor.id, :is_in_gallery => false))
        upload_images_for_fundbox(uploaded_data)
        @content.assign_to_album(album_id)
        flash[:success] = 'FundBox successfully updated.'.t + ' ' + flash[:success].to_s
        redirect_to :action => :edit_fundbox, :id => @content.id
        return
      end
    end
    @images = @content.images if @content
    render :action => 'fundbox'
  end

  # =======================================
  # = Actually adding various media types =
  # =======================================

  def upload_image
    load_projects if params[:is_from_setting_center]
    @content = Image.new
    @content.user_id = @user.id
    @content.cat_id = (params[:cat_id].blank? ? Content::CATEGORIES[:image][:id] : params[:cat_id])
  end

  def upload_music
    @content = Track.new
    @content.user_id = @user.id
    @content.cat_id = Content::CATEGORIES[:track][:id]
  end

  def upload
    #@user = User.find_by_id(10)
    #@content = Track.find(5971)
    #assign_to_album(5153)
    #@uploaded = [Track.find(5971)]
    #render :template => "submit/music" and return
    #@uploaded = Image.find(:all, :limit => 4, :order => 'created_at desc', :conditions => "user_id=10")
    #render :template => "submit/image" and return
    unless request.post? && params[:content]
      redirect_to userpage_path(current_actor) and return
    end
    @album = Album.active.find(params[:for_album]) unless params[:for_album].blank? 

    media = (params[:content][:cat_id].to_i == Content::CATEGORIES[:track][:id] ? Track : Image)
    name_of_action = media == Image ? 'image' : 'music'

    # This is for backward compatibility to support if content is uploaded and is not a multiple upload
    uploaded_data = params[:content].delete(:uploaded_data)
    uploaded_data = uploaded_data.is_a?(Hash) ? uploaded_data.values : [uploaded_data]

    # Loop through array of uploaded files
    @uploaded = []
    upload_errors = []
    uploaded_data.each do |data|
      next if (data && data.size.zero?) and uploaded_data.size > 1
      begin
        return unless upload_file(data, media, name_of_action, params) == :continue
      rescue Errno::ETIMEDOUT, Errno::ECONNRESET
        upload_errors << amazon_timeout_message
      rescue ActiveRecord::RecordInvalid
        upload_errors << @content.errors.full_messages.join("<br/>")
      # rescue => exception
      #   upload_errors << "Sorry, upload failed for file %s" / [@content.title]
      #   just_notify(exception)
      #   break
      end

    end
    flash[:error] = upload_errors.join("<br/>") unless upload_errors.empty?
    if @uploaded.empty?
      flash.delete(:success)
      flash[:warning] = "No file came from you. Possibly it's inexistent now or you have no read access to it.".t
      # If we got here, and @uploaded is empty, return to the upload page
      go_to = if params[:content][:cat_id] == Content::CATEGORIES[:avatar][:id]
        {:controller => 'profile', :action => 'edit_avatar', :id => current_actor.profile.id}
      else
        error_action = "upload_#{name_of_action}"
        error_action = 'add_track_to_contest' if @album.is_a?(MusicContest)
        {:action => error_action, :user_id => params[:content][:user_id], :for_album => params[:for_album]}
      end
      redirect_to go_to and return
    else
      flash[:success] = "%d %s successfully uploaded" / [@uploaded.size, @content.class.name.downcase.t]
    end
    params[:new] = true
    redirect_to(:action => 'edit_contest_track_properties', :id => @content.id) and return if @album.is_a?(MusicContest)
    render :template => "submit/#{name_of_action}"
  end


  def edit
    @title = "Edit %s '{{title}}'" % @content.entity_name_for_human.titleize
    @title = @title / @content.title_short(20)
    #"Edit Music Album '{{title}}'".t
    #"Edit Music Contest '{{title}}'".t
    choose_edit_action(@content)
  end
  
  def update
    @updated = []
    multiple_or_single_content(params[:content]) do |id, data|
      @content = Content.active.find_by_id(id)
      return if !load_owner
      return if !check_editability
      check_edit_permission
      @user = current_actor

      #convert FolderWithDownloadables to Album if there are no files attached
      params[:downloadable] = false if @content.is_a?(FolderWithDownloadables) && @content.bundles.blank?

      # Switch between Album and FolderWithDownloadables, and reload, if appropriate
      if @content.class == FolderWithDownloadables && !params[:downloadable]
        @content.contribution_setting.destroy if @content.contribution_setting 
        @content.update_attribute(:type, Album.name)
        @content = Content.find(@content.id)
      elsif @content.class == Album && params[:downloadable]
        @content.update_attribute(:type, FolderWithDownloadables.name)
        @content = Content.find(@content.id)
        @content.build_fwd_details if !@content.fwd_details
      end
      
      begin
        Content.transaction do
          album_id = data.delete(:album_id)
          
          # Handle userpic logic if is an image
          make_userpic_p = data.delete(:use_as_kroogi_image)
          @content.update_userpic!(make_userpic_p.to_i != 0) if @content.is_a?(Image) && make_userpic_p

          begin
            # FWD - specific updates: to attached file bundles
            multiple_files_upload(params[:file_bundle]) do |id, bundle_data|
              bundle_data[:id] = id
              @content.set_or_update_bundle(bundle_data) unless bundle_data[:uploaded_data].blank?
            end if @content.respond_to?(:set_or_update_bundle)

            # cover art image
            @content.set_or_update_cover_art(params[:cover_art]) if @content.respond_to?(:set_or_update_cover_art)

            # embedded image
            @content.set_or_update_embedded_image(params[EMBEDDED_IMAGE_KEY])
          rescue TypeError => e
            flash[:error] = "The file upload failed. Please try again".t
            choose_edit_action(@content) and return
          end

          # Do normal assignment
          @content.attributes = data
          
          # Announcement-specific updates
          if @content.respond_to?(:announcement)
            @content.announcement.attributes = params[:announcement] 
          end
          
          # Uploading new file?
          if @content.respond_to?(:editing_file)
            @content.editing_file = !data[:uploaded_data].blank?
          end

          # Copyright info
          @content.update_blank_owner(@user.login)
          @content.set_specific_params_before_saving(params)
          @content.save!
          @content.update_security_of_children if @content.is_a?(Album) && !@content.is_a?(Inbox)

          # Album assignment
          unless album_id.blank? || @content.container_album && @content.container_album.id == album_id.to_i
            raise Kroogi::NotPermitted unless permitted?(Album.find(album_id).user, :content_edit)
          end
          @content.change_album(album_id)

          # Featured album assignment
          unless @content.is_a?(BasicFolderWithDownloadables)
            featured_album = @content.albums.detect{|album| album.featured_album?}
            if featured_album.nil? && @content.is_in_startpage
              @content.assign_to_featured_album
            elsif featured_album && !@content.is_in_startpage
              @content.remove_from_album(featured_album)
            end
          end

          @content.update_specific_params(params)
        end
        flash[:success] = 'Update successful'.t
        @updated << @content
        # FIXME this is horrible validation handling
      rescue ActiveRecord::RecordInvalid => e
        flash[:error] = e.to_s
        redirect_to(:action => 'edit', :id => @content) and return
      rescue Kroogi::NotPermitted => e
        raise e
      rescue => exception
        flash.now[:error] = 'Sorry, the content update failed, please try again'.t
        just_notify(exception)
        choose_edit_action(@content) and return
      end
    end
    return if redirect_to_param
    if @updated.size > 1
      if @for_inbox
        redirect_to content_url(@for_inbox)
      else
        redirect_to :controller => 'user', :action => 'gallery', :id => @content.user
      end
    else
      redirect_to content_url(@content)
    end
  end

  def add_music
    @updated = []
    album_id= ''
    multiple_or_single_content(params[:content]) do |id, data|
      @content = Track.active.find(id)
      check_if_uploading_to_inbox
      author = load_owner
      check_add_permission # just to kick off security (verifies has rights to add)
      begin
        album_id = data.delete(:album_id)
        Content.transaction do
          # tracks are always in gallery?
          @content.is_in_gallery = true
          @content.update_attributes!(data)
          @content.assign_to_album(album_id)
          @content.assign_to_featured_album
          add_to_inbox__do_add
        end
        @updated << @content
      rescue ActiveRecord::RecordInvalid
        @content = Track.new unless @content
        render :action => 'music', :new => true and return
      rescue => exception
        handle_add_music_error(exception) and return
      end
    end

    handle_add_music_error(nil) and return unless @content
    unless @updated.size > 1
      flash[:success] = "Added '{{track_title}}' track successfully" / @content.title
      if album_id.empty?
        redirect_to :controller => 'user', :action => 'gallery', :id => @content.user
      elsif !@content.container_album
        redirect_to content_url(@content)
      else
        redirect_to content_url(@content.container_album)
      end
    else
      redirect_to @for_inbox ? content_url(@for_inbox) : {:controller => 'user', :action => 'gallery', :id => @content.user}
    end

  end

  def add_image
    @updated = []
    album_id = ""
    multiple_or_single_content(params[:content]) do |id, data|
      @content = Image.active.find(id)
      check_if_uploading_to_inbox
      author = load_owner
      check_add_permission
      begin
        album_id = data.delete(:album_id)
        use_as_kroogi_image = !data.delete(:use_as_kroogi_image).to_i.zero?
        Content.transaction do
          @content.update_attributes!(data)
          @content.is_in_startpage = false if use_as_kroogi_image
          @content.update_userpic!(use_as_kroogi_image)
          @content.assign_to_album(album_id)
          @content.assign_to_featured_album
          add_to_inbox__do_add
        end
        @updated << @content
      rescue ActiveRecord::RecordInvalid
        @content = Image.new unless @content
        render :action => 'image', :new => true and return
      rescue => exception
        flash[:error] = 'Sorry, this operation failed, please try again'.t
        just_notify(exception)
        render :action => 'image', :new => true and return
      end
    end
    redirect_to @for_inbox ? content_url(@for_inbox) : album_id.empty? ? {:controller => 'user', :action => 'gallery', :id => @content.user} : content_url(album_id) 
  end


  def add_blog
    raise 'Not Permitted'
  end

  def add_inbox
    begin
      @content = Inbox.new # Keep creation and attribute setting steps separate, b/c delegation not in place before initialize
      @content.attributes = params[:content]
      author = load_owner
      check_add_permission
      @content.user_id = author.id
      @content.cat_id = Content::CATEGORIES[:inbox][:id]
      @content.is_in_gallery = false # never in gallery
      @content.save!
      @cover_art = @content.set_or_update_cover_art(params[:cover_art])
      @content.save!
      Activity.send_message(@content, author, :published_inbox)
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = e.message
      render :action => 'inbox', :new => true and return
    rescue => exception
      raise exception
      flash[:error] = 'Sorry, this operation failed, please try again'.t
      just_notify(exception)
      render :action => 'inbox', :new => true and return
    end
    redirect_to content_url(@content)
  end
  
  def add_music_album
    add_album(MusicAlbum)
  end
  
  def add_music_contest
    @partial = 'header'
    if add_album(MusicContest, :redirect => false)
      return if redirect_to_param
      redirect_to :action => 'change_contest_image', :id => @content.id      
    end
  end

  def add_album(klass = Album, options = {})
    options[:rescue_action] ||= klass.name.underscore
    options[:activity_type] ||= ("published_" + klass.name.underscore).to_sym
    options[:redirect] = true unless options.has_key?(:redirect) 

    unless request.post? && params[:content]
      redirect_to userpage_path(current_actor) and return
    end

    data = params[:content] # no multiple_or_single_content here for now

    # for some reason we're getting is_in_startpage => 0 in separate array, w/ is_in_startpage => 1 in the main array 
    data = data.first if data.is_a?(Array) 

    # unable to duplicate, but a production error had {content_id => {the params we need}}
    data = data.values.first if data.keys.size == 1

    params[:new] = true
    album_id = data.delete(:album_id)
    if (klass == Album) && params[:downloadable]
      @content = FolderWithDownloadables.new
    else
      @content = klass.new
      data.reject! do |key, value|
        %w(terms terms_ru number_of_tracks require_terms_acceptance).include?(key)
      end
    end
    
    @content.attributes = data
    author = load_owner
    check_add_permission

    # Handle errors... general error handling here is functional, but horrendous :(
    if @content.is_a?(FolderWithDownloadables) && params[:file_bundle].all?{|b| b[:uploaded_data].blank?}
      if @content.is_a?(FolderWithDownloadables)
        @contribution_setting = ContributionSetting.new(params[:contribution_setting])
      end
      flash[:error] = "Don't forget to attach a file to be downloaded!".t
      render :action => options[:rescue_action], :new => true and return
    end

    begin
      Content.transaction do
        @content.user_id = author.id
        @content.is_in_gallery = true # always in gallery
        @content.cat_id = Content::CATEGORIES[:album][:id]
        @content.save!
        @content.assign_to_album(album_id)
        @content.assign_to_featured_album
        Activity.send_message(@content, author, options[:activity_type])# if params[:alert_on_post]

        if @content.is_a?(BasicFolderWithDownloadables)
          @cover_art = @content.set_or_update_cover_art(params[:cover_art])
          multiple_files_upload(params[:file_bundle]) do |id, bundle_data|
            bundle_data[:id] = id
            @bundle = @content.set_or_update_bundle( bundle_data )
          end unless @content.is_a?(MusicAlbum)
        end

        @content.save_contribution_settings(params) if @content.is_a?(FolderWithDownloadables) 
      end
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = e.message
      render :action => options[:rescue_action], :new => true and return
    rescue => exception
      flash[:error] = 'Sorry, this operation failed, please try again'.t
      just_notify(exception)
      render :action => options[:rescue_action], :new => true and return
    end
    if request.xhr?
      render :text => @content.id
    elsif options[:redirect]
      redirect_to content_url(@content) and return
    end
    true
  end

  def add_writing
    album_id = ''
    multiple_or_single_content(params[:content]) do |id, data|
      album_id = data.delete(:album_id)
      @content = Textentry.new(data)
      @content.cat_id = Content::CATEGORIES[:writing][:id]
      check_if_uploading_to_inbox
      author = load_owner
      check_add_permission
      @content.user_id = author.id
      begin
        Content.transaction do
          @content.is_in_gallery = true
          @content.save!
          @content.assign_to_album(album_id)
          @content.assign_to_featured_album
          Activity.send_message(@content, author, :published_writing)
          add_to_inbox__do_add
        end
      rescue ActiveRecord::RecordInvalid
        render :action => 'writing', :new => true and return
      rescue => exception
        flash[:error] = 'Sorry, this operation failed, please try again'.t
        just_notify(exception)
        render :action => 'writing', :new => true and return
      end
    end
    redirect_to album_id.empty? ? {:controller => 'user', :action => 'gallery', :id => @content.user} : content_url(album_id)
  end

  def add_video
    album_id = ''
    multiple_or_single_content(params[:content]) do |id, data|
      album_id = data.delete(:album_id)
      @content = Video.new(data)
      check_if_uploading_to_inbox
      author = load_owner
      check_add_permission
      @content.user_id = author.id
      begin
        Content.transaction do
          @content.is_in_gallery = true
          @content.cat_id = Content::CATEGORIES[:video][:id]
          @content.save!
          @content.assign_to_album(album_id)
          @content.assign_to_featured_album
          Activity.send_message(@content, author, :published_video)
          add_to_inbox__do_add
        end
      rescue ActiveRecord::RecordInvalid
        render :action => 'video', :new => true and return
      rescue => exception
        flash[:error] = 'Sorry, this operation failed, please try again'.t
        just_notify(exception)
        render :action => 'video', :new => true and return
      end
    end
    redirect_to album_id.empty? ? {:controller => 'user', :action => 'gallery', :id => @content.user} : content_url(album_id)
  end

  rescue_urls :add_pvtmsg => :pvtmsg
  def add_pvtmsg
    @content = Pvtmessage.new(params[:content])
    raise Kroogi::NotPermitted unless permitted?(@content.foruser, :write_pvtmessage)
    #@content.title ||= 'No subject'.t
    author = load_owner
    check_add_permission
    @content.send!(author)
    redirect_to user_path_options(@content.foruser, :controller => '/activity', :action => 'dialogue', :with => author.id)
  end

  def add_announcement
    multiple_or_single_content(params[:content]) do |id, data|
      @content = Board.new
      author = load_owner
      check_add_permission
      @content.user = author
      begin
        Content.transaction do
          data[:relationshiptype_id] ||= Relationshiptype.everyone
          @content.attributes = data unless data.blank?
          @content.sticky = params[:is_announcement]
          @content.is_in_gallery = false
          @content.cat_id = Content::CATEGORIES[:announcement][:id]
          @content.save!
          #we could create a gallery-friendly Image here, but we don't yet because we don't ask for ownership when creating
          @cover_art = @content.set_or_update_embedded_image(params[EMBEDDED_IMAGE_KEY])
          Activity.send_message(@content, author, @content.sticky? ? :published_announcement : :published_usernote)
          @content.user.set_notes_tab_active
        end
        flash[:success] = unless @content.sticky?
          'Note was successfully posted'.t
        else
          'Announcement was successfully posted'.t
        end
      rescue ActiveRecord::RecordInvalid => invalid
          if invalid.record.is_a?(CoverArt)
            flash[:error] = "#{invalid.record.errors.full_messages}"
          else
            flash[:error] = 'Sorry, this operation failed, please try again'.t
          end
          redirect_to announcements_page_path(@content.user) and return if params[EMBEDDED_IMAGE_KEY]
          render :action => 'announcement', :new => true and return
      rescue => exception
          just_notify(exception)
          if params[EMBEDDED_IMAGE_KEY]
            flash[:error] = 'Sorry, this operation failed, please try again'.t
            redirect_to user_path_options(@content.user) and return
          end
          flash.now[:error] = 'Sorry, this operation failed, please try again'.t
          render :action => 'announcement', :new => true and return
      end
    end
    redirect_to announcements_page_path(@content.user)
  end

  def announcements_page_path(user)
    options = {}
    options.merge!(:action => 'about') if user.collection?
    user_path_options(user, options)
  end

  def add_topic
    raise 'Not Permitted'
  end

  def delete
    content = @content
    raise Kroogi::NotPermitted if content && content.is_a?(Inbox) && !content.inbox_items.empty? # Can only archive inboxes with contents

    album = content.container_album
    content.empty! if content.is_a?(Album)
    owner = content.user
    begin
      content.destroy
      if params[:submission_cancel] && content.is_a?(Track)
        msg = 'Track submission was successfully cancelled'.t
      end
      msg ||= content.removal_success_message
      flash[:success] = msg
    rescue => exception
      just_notify(exception)
      raise exception unless RAILS_ENV == 'production'
      flash[:error] = 'Sorry, the deletion failed, please try again'.t
    end
    if @content.cat_id.to_i == Content::CATEGORIES[:announcement][:id]
      redirect_to userpage_path(owner)
    else
      if album
        redirect_to content_url(album)
      else
        redirect_to :controller => 'user', :action => 'gallery', :id => content.user
      end
    end
  end

  def make_downloadable
    @contribution_setting = @content.build_contribution_setting
  end

  def generate_zip
    @content.save_contribution_settings(params)
    @content.generate_zip
    flash[:success] = 'Zip file for this Music Album was successfully generated'.t
    redirect_to content_url(@content)
  end

  def remove_downloads
    @content.bundles.destroy_all
    @content.contribution_setting.destroy if @content.contribution_setting
    flash[:success] = 'Zip file for this Music Album was successfully removed'.t
    if @content.show_donation_button
      @content.show_donation_button = false
      @content.save!
    end
    redirect_to content_url(@content)
  end

  def music_contest
    @content = MusicContest.new
    @content.accepts_submissions = true
    @partial = 'header'
    set_content_defaults
  end

  def change_contest_image
    @title = "Change Cover Image of Contest '{{title}}'" / @content.title_short(20)
    @partial = "change_image"
    render :action => 'music_contest'
  end

  def add_contest_originals
    @title = "Add Originals for Contest '{{title}}'" / @content.title_short(20)
    @partial = "add_originals"
    # only content which has an owner with a valid payment system can be downloadable
    @part_allowed = @content.user.account_setting.has_an_approved_account_set?
    render :action => 'music_contest'
  end

  def update_bundle_label
    raise "bundle is expected!" unless @content.is_a?(Bundle)
    #parameter is not 'locale' because it would switch current user's locale
    I18n.with_locale(params[:llocale]) do
      @content.title = params[:label]
      @content.save!
    end
    render :nothing => true
  end

  def add_track_to_contest
    @contest = MusicContest.active.find(params[:for_album])
    raise Kroogi::NotPermitted unless permitted?(@contest.user, :content_add, :album => @contest)

    @content = Track.new
    @content.cat_id = Content::CATEGORIES[:track][:id]
    @content.user = @contest.user 

    @title = "Upload Track to Contest '{{title}}'" / @contest.title_short(20)
    @partial = "add_track"
    render :action => 'contest_track'
  end

  def edit_contest_track_properties
    @contest = @content.albums.find_by_type('MusicContest')
    @album = @contest
    @title = "Edit Contest Track '{{title}}' Properties" / @content.title_short(20)
    @partial = "edit_track_properties"    
    render :action => 'contest_track'
  end

  def promote_contest_item
    raise Kroogi::NotFound unless @content.music_contest_item?
    contest = @content.container_album
    raise Kroogi::NotPermitted unless permitted?(contest.user, :content_edit)
    if @content.contest_submission.promote_level
      flash[:success] = 'The track has been successfully promoted'.t
    else
      flash[:error] = @content.contest_submission.errors.full_messages.join(';')
    end
    redirect_to content_url(@content)
  end

  def upload_with_tool
    filename = params['Filename']
    if filename.downcase.ends_with?('.mp3')
      media, initializer_action = Track, :music
    else
      media, initializer_action = Image, :image
    end
    album = Content.find(params[:album_id])
    content_user = album.user
    unless permitted?(content_user, :content_add, :album => album)
      render :json => {:error => UploaderErrors::PERMISSION_DENIED, :error_message => 'no permissions to add to album'.t} and return
    end
    new_params = {:filename => filename, :for_album => album, :ownership => params[:ownership] || 'me',
                  :content => {:user_id => content_user.id, :owner => params[:owner]}}
    @uploaded = []
    begin
      upload_file(params['Filedata'], media, initializer_action, new_params)
      attribs = %w(artist title year genre album).map {|key| [key, (params[key] || '').chomp]}.reject {|key, value| value.blank?}.to_hash
      @content.update_attributes!(attribs.merge({
              :tag_list => params[:tags],
              :show_donation_button => (params[:request_contribution] == 'true'),
              }))
    rescue Errno::ETIMEDOUT, Errno::ECONNRESET, SocketError
      render :json => {:error => UploaderErrors::REMOTE_STORAGE_ACCESS, :error_message => amazon_timeout_message} and return
    rescue UploadQuotaExceeded
      render :json => {:error => UploaderErrors::QUOTA_EXCEEDED, :error_message => @content.errors.full_messages.join('; '),
                       :quota => content_user.upload_quota, :quota_used => content_user.upload_quota_used} and return
    rescue ActiveRecord::RecordInvalid
      render :json => {:error => UploaderErrors::INVALID_FILE, :error_message => @content.errors.full_messages.join('; ')} and return
    end
    log.debug "successful return"
    render :json => {:quota => content_user.upload_quota, :quota_used => content_user.upload_quota_used}
  end

  private
  
  def multiple_files_upload(obj)
    log.debug "multiple_files_upload: obj is %s" % obj.inspect
    return false if obj.nil?
    obj.each do |hash|
      yield hash.delete(:id), hash
    end
  end

  # Handle running once or multiple times, depending on params.
  def multiple_or_single_content(obj)
    log.debug "multiple_or_single_content: obj is %s" % obj.inspect
    return false if obj.nil?

    if obj.is_a?(Hash)
      if obj[:id]
        yield obj[:id], obj
      elsif obj.values.first.is_a?(Hash)
        obj.each do |id, data|
          yield id, data
        end
      else
        yield nil, obj
      end
    # If recieved an array of items (e.g. content[][title])
    elsif obj.is_a?(Array)

      # For some reason we're getting an array, the second entry of which is the "reject" (not used) is_in_startpage and the needed relationshiptype_id, from creating writing
      if obj.size == 2 && obj[1].keys.size == 2 && obj[1].keys.all?{|key| %w(relationshiptype_id is_in_startpage).include?(key)}
        obj = [obj[0].reverse_merge!(obj[1])]
      end

      # TODO : this is fucked up. add_writing w/ donation button checked gives us an array of three hashes, with rejects further down... upload logic needs to be rewritten to cleanly handle multiple AND single
      if obj.size > 1 && obj[1..-1].all?{|hash| hash[:title].nil?}
        keep = obj[0]
        obj[1..-1].each do |additional|
          keep.reverse_merge!(additional)
        end
        obj = [keep]
      end
      
      obj.each do |hash|
        yield hash.delete(:id), hash
      end
    else
      yield nil, obj
    end
  end

  def choose_edit_action(content)
    case content.class.to_s
    when Image.name
      render :action => 'image'
    when CoverArt.name
      render :action => 'image'
    when Track.name
      render :action => 'music'
    when Video.name
      render :action => 'video'
    when Textentry.name
      render :action => 'blog' if @content.cat_id == Content::CATEGORIES[:blog][:id]
      render :action => 'writing' if @content.cat_id == Content::CATEGORIES[:writing][:id]
    when Board.name
      if @content.cat_id == Content::CATEGORIES[:announcement][:id]
        render :action => 'announcement' 
      end
      render :action => 'topic' if @content.cat_id == Content::CATEGORIES[:topic][:id]
    when Album.name
      @contribution_setting = ContributionSetting.new
      render :action => 'album'
    when FolderWithDownloadables.name
      @contribution_setting = @content.contribution_setting
      render :action => 'album'
    when MusicAlbum.name
      render :action => 'music_album'
    when MusicContest.name
      @partial = "header"
      render :action => 'music_contest'
    when Inbox.name
      render :action => 'inbox'
    when ProjectAsContent.name
      render :action => 'project'
    end
  end

  def load_owner    
    @user ||= @content.user if @content && !@content.user_id.nil?
    unless @user
      uid = params[:user_id] 
      uid ||= params[:content][:user_id] if params[:content]
      @user = User.find_by_id(uid) if uid
      @user = nil unless @user && @user.active?
    end
    @user ||= current_actor
    return @user
  end

  def load_content
    raise Kroogi::NotPermitted unless params[:id]
    @content = Content.active.find(params[:id])
  end 

  def load_any_content
    raise Kroogi::NotPermitted unless params[:id]
    @content = Content.find(params[:id])
  end

  def check_if_uploading_to_inbox
    if params[:for_inbox] && @for_inbox.nil?
      @for_inbox = Inbox.find(params[:for_inbox])
      @for_inbox = nil unless @for_inbox.accepts?(@content) && @for_inbox.is_view_permitted?
    end
  end

  # Consolidate the defaults for uploaded/created content items
  def set_content_defaults
    @content.user_id = @user.id
    @content.user = @user
    @content.is_in_startpage = !@content.albums.detect{|a| !a.featured_album?}
    @content.is_in_gallery = true
    @content_kind_displayname = "New #{@content.entity_name_for_human.titleize}".t
    @title = @user.login + ' :: ' + @content_kind_displayname
    #'New Music Album'.t
    #'New Music Contest'.t
  end

  def prepare_new_album(klass = Album)
    @content = klass.new
    set_content_defaults
    @content.donation_button_label = 'Download'.t
    @contribution_setting = ContributionSetting.new    
  end

  def check_editability
    unless @content.editable?
      flash[:error] = 'This item is not editable now'.t
      redirect_to content_url(@content)
      return false
    end
    true
  end

  def check_contents_when_making_downloadable
    if @content.tracks.empty?
      flash[:error] = 'This Music Album has no tracks'.t
      redirect_to content_url(@content)
      false
    else
      true
    end
  end

  def check_if_already_when_making_downloadable
    if @content.downloadable?
      flash[:warning] = 'This Music Album is already downloadable'.t
      redirect_to content_url(@content)
      false
    else
      true
    end
  end

  def check_money_when_making_downloadable
    unless @content.donatable? && @content.user.account_setting.has_an_approved_account_set?
      flash[:error] = "You cannot make it downloadable until you have some payment system attached".t
      redirect_to content_url(@content)
      false
    else
      true 
    end
  end

  def handle_add_music_error(exception)
    flash[:error] = 'Sorry, this operation failed, please try again'.t
    just_notify(exception) if exception
    render :action => 'music', :new => true
  end

  def check_add_permission
    @album ||= Album.active.find_by_id(params[:for_album]) unless params[:for_album].blank?
    raise Kroogi::NotPermitted unless permitted?(@user, :content_add, :album => @album)    
  end
  
  def check_edit_permission
    raise Kroogi::NotPermitted unless permitted?(@user, :content_edit, :content => @content)
  end

  def redirect_to_param
    unless params[:redirect_to].blank?
      r = params[:redirect_to]
      r = content_url(@content) if r  == '[show_content]'
      redirect_to(r)
      true
    end
  end

  def allow_donations_for_content
    unless @content.show_donation_button
      @content.show_donation_button = true
      @content.save!
    end
    true
  end

  def upload_file(data, media, initializer_action, params)
    # Empty tempfile (only one file field has to be populated during multiple upload, so 0 size uploads are valid, but skipped)
    @content = media.new(params[:content])
    check_if_uploading_to_inbox
    @content.just_uploaded = true
    @content.uploaded_data = data
    @content.set_ownership_from_params(params[:ownership], params[:content][:owner])
    @content.is_in_gallery = false
    @content.is_in_startpage = false
    load_owner and check_add_permission
    Content.transaction do
      @content.title ||= @content.filename
      if @content.cat_id.to_i == Content::CATEGORIES[:userpic][:id]
        @content.is_in_gallery = true
        @content.make_userpic!
        @content.assign_to_album(params[:for_album])
        @content.save! if @content.new?

        #wizard hook
        if params[:is_for_wizard]
          if params[:userpic_same_as_project] == '1'
            user_profile = current_user.profile
            user_profile.userpic_id = @content.id
            user_profile.save!
            user_profile.userpic.update_attributes(:cat_id => Content::CATEGORIES[:image][:id]) if user_profile.userpic
          end
          redirect_to(:controller => 'wizard',
                      :action => params[:next_step],
                      :id => @content.user.id) and return

        end
        if params[:is_from_setting_center]
          flash[:success] = 'Details were successfully updated.'.t
          redirect_to :controller => 'preference', :action => 'show', :id => @content.user.id and return
        else
          redirect_to(:controller => 'submit', :action => 'image', :id => @content, :cat_id => Content::CATEGORIES[:userpic][:id], :new => true, :for_album => params[:for_album], :for_inbox => params[:for_inbox]) and return
        end
      elsif @content.cat_id.to_i == Content::CATEGORIES[:avatar][:id]
        @content.relationshiptype_id = Relationshiptype.everyone
        @content.save!
        profile = @content.user.profile
        unless profile.avatar
          profile.avatar_id = @content.id
          profile.save!
        end
        if params[:set_as_default]
          profile.update_attribute(:avatar_id, @content.id)
        end

        #wizard hook
        if params[:is_for_wizard]
          profile.avatar_id = @content.id
          profile.save!
          if params[:avatar_same_as_project] == '1'
            user_profile = current_user.profile
            user_profile.avatar_id = @content.id
            user_profile.save!
          end
          redirect_to(:controller => 'wizard',
                      :action => params[:next_step],
                      :id => @content.user.id) and return
        end
        if params[:is_from_setting_center]
          flash[:success] = 'Details were successfully updated.'.t
          redirect_to :controller => 'preference', :action => 'show', :id => @content.user.id and return
        else
          redirect_to :controller => 'profile', :action => 'edit_avatar', :id => @content.user.profile.id and return
        end
      else
        # Set defaults
        @content.assign_to_album(params[:for_album])
        send(initializer_action)
        @content.save!
        @uploaded << @content
      end
      unless @album.is_a?(MusicContest)
        Activity.send_message(@content, @content.user, media == Track ? :published_track : :published_image)        
      else
        opts = {}
        opts = {:add_friends_of => current_actor} if @album.public?
        Activity.send_message(@content, @content.user, :published_track, opts)
      end
      flash[:success] = "Upload was succesfull!".t
    end
    return :continue
  end

  def set_session_for_tool
    if params[:user_id].blank? || params[:user_id_sign].blank?
      render :json => {:error => UploaderErrors::PERMISSION_DENIED, :error_message => 'bad user_id'} and return
    end
    if sign_with_session_secret(params[:user_id]) != params[:user_id_sign]
      render :json => {:error => UploaderErrors::PERMISSION_DENIED, :error_message => 'bad user_id'} and return
    end
    user = User.find(params[:user_id])
    render :json => {:error => UploaderErrors::PERMISSION_DENIED, :error_message => 'bad user_id'} and return unless user.active?
    session[:user] = user.id
  end

  def amazon_timeout_message
    'Sorry, we are experiencing problems with our content hosting service right now. Try again in a few minutes.'.t
  end

  def fix_dateformat
    return unless request.post?
    end_date = params[:content][:end_date]
    begin
      params[:content][:end_date] = Date.strptime(end_date, I18n.t('date.formats.birthday')).to_s(:db) unless end_date.blank?
    rescue => e
      logger.debug("Problem with date format: #{e}")
    end
  end

  def fundbox_allowed?
    raise Kroogi::NotPermitted unless current_actor.tps_setup_enabled?
  end

  def upload_images_for_fundbox(uploaded_data)
    iparams = {:user_id => @content.user_id, :owner => nil, :is_in_gallery => false,
               :is_in_startpage => false, :just_uploaded => true, :relationshiptype_id => @content.relationshiptype_id}

    return if uploaded_data.blank?
    uploaded_data = uploaded_data.is_a?(Hash) ? uploaded_data.values : [uploaded_data]

    @uploaded = []
    upload_errors = []
    uploaded_data.each do |data|
      next if (data && data.size.zero?) && uploaded_data.size > 1
      begin
        @image = Tps::Image.new(iparams)
        @image.uploaded_data = data
        @image.set_ownership_from_params('me', nil)
        Content.transaction do
          @image.title ||= @image.filename
          @image.albums << @content
          @image.save!
          @uploaded << @image
        end
      rescue Errno::ETIMEDOUT, Errno::ECONNRESET
        upload_errors << amazon_timeout_message
      rescue ActiveRecord::RecordInvalid
        upload_errors << @image.errors.full_messages.join("<br/>")
      end
    end

    flash[:error] = upload_errors.join("<br/>") unless upload_errors.empty?
    unless @uploaded.empty?
      flash[:success] = "%d %s successfully uploaded" / [@uploaded.size, 'Images'.downcase.t]
    end
  end

end
