class ContentController < ApplicationController
    before_filter :force_plain_http, :only => [:show] 
    before_filter :login_required, :except => [:show, :download, :download_bundle, :invite_guest_to_user_circle,
                                               :played, :comments] #:recent
    before_filter :load_owner, :only => [:remove_krugi_id]
    before_filter :load_prefixed_content_id, :only => [:show]
    before_filter :verify_content_url_path, :only => [:show]
    before_filter :handle_content_exclusions, :only => [:show, :comments]

    before_filter :force_content_subdomain, :only => [:show]

    before_filter :store_location, :only => [:show, :recent, :comments]
    skip_before_filter :verify_authenticity_token, :only => [:album_order, :download, :show]
    before_filter :handle_dl_link_expiration, :only => :download_bundle

    skip_before_filter :run_basic_auth, :only => [:show, :played]

    attr_accessor :skip_path_verification
    
    verify :method => :post, :only => [ :invite_guest_to_user_circle, :remove_from_album ],
      :redirect_to => {:controller => '/'}

    # Download downloadable track or other stand-alone content item.  Music Albums downloads go through download_bundle
    def download
      redirect_to(explore_path) and return unless params[:id]
      # TODO: cipher this so that someone can't easily download all of the content
      @track = Track.downloadable.find_by_id(params[:id])
      if @track && @track.public?        
        KarmaPoint.create_from_id(session[:karma_point_id], :content => @track, :action => :download)
        redirect_to @track.s3_url if @track.respond_to?(:s3_url)
        Activity.send_message(@track, @track.user, :content_download_initiated, :to_user => current_actor)
      else
        flash[:error] = 'Track not found or hidden'.t
        redirect_to(explore_path)
      end
    end
    
    def chooser
      if params[:type] && params[:type] == 'Image'
        @stream = Image.active.find(:all, :conditions => { :user_id => params[:id], :cat_id => [Content::CATEGORIES[:image][:id]]}, :limit => 50, :order => 'created_at desc')
      else 
        @stream = Content.active.find(:all, :conditions => { :user_id => params[:id], :cat_id => [Content::CATEGORIES[:image][:id]]}, :limit => 50, :order => 'created_at desc')
      end
      render :partial => 'chooser'
    end

    # Show paginated comments of the given content
    def comments
      @comments = Comment.active.belonging_to(@entry).paginate(:all,
          :order => "#{Comment.right_column_name} DESC", 
          :page => params[:page], :per_page => setpagesize)
    end
    
    
    def show
      params[:format] = 'html'
      @user = @entry.user
      if DonationProcessors.in_successful_payment_handler?(self)
        flash.now[:success] = "Thank you for supporting {{user_name}}'s '{{content_title}}'" / [@entry.user.display_name,
                                                                                                @entry.title]
        PublicQuestionHelper::set_question_artist_id(@user, self, :now => true, :force_show => true) unless @entry.downloadable?

        if session[:dl_link_on_donation]
          invite_id, content_id = session[:dl_link_on_donation]
          if content_id.to_i == @entry.id
            session[:dl_link_on_donation] = nil
            invite = Invite.find_by_id(invite_id)
            invite.put_link_to_download(content_id) if invite
          end
        else
          if !logged_in? && params[:download] != 'false' && @entry.downloadable?
            @dl_link_needed = true
            session[:dl_link_needed] = @entry.id
          end
        end
      end

      unless current_user.is_self_or_owner?(@entry.user)
        ContentStat.mark_async(:viewed!, {:content => @entry, :user_id => logged_in? ? current_user.id : nil, :ip => request.remote_ip})
      end
      if @entry.is_a?(Pvtmessage)
        @context_user = @entry.me
                
        # No pagination for pvtmessage comments
        @comments = Comment.active.belonging_to(@entry).find(:all, :order => "#{Comment.right_column_name} DESC")

        render(:action => 'privatemessage')
      end
      @show_post_options = show_post_options(@entry)
      @post_options = [:track] if @entry.is_a?(MusicAlbum) 
      @post_options = [:project] if (@user && @user.collection?)
      @post_options = [:track, :video, :image, :writing, :folder] if @entry.is_a?(FolderWithDownloadables)

      @comments = Comment.active.belonging_to(@entry).find(:all, :limit => 5,
                                                           :order => "#{Comment.right_column_name} DESC")
      if @entry.is_a?(Inbox)
        page_size = setpagesize(5)
        @inbox_items = if params[:order] == 'popularity'
          Content.paginate_by_sql("SELECT count(v.id) votes_count, contents.* FROM contents INNER JOIN inbox_items ON contents.id = inbox_items.content_id LEFT JOIN votes v ON v.voteable_id = contents.id AND v.voteable_type = 'Content' AND v.type = 'UpVote' WHERE (inbox_items.inbox_id = #{@entry.id}) group by contents.id order by votes_count desc, position desc", :per_page => page_size, :page => params[:page])
        else
          Content.paginate_by_sql("SELECT contents.* FROM contents INNER JOIN inbox_items ON contents.id = inbox_items.content_id WHERE (inbox_items.inbox_id = #{@entry.id}) order by position desc", :per_page => page_size, :page => params[:page])
        end
      end

      if @entry.is_a?(MusicContest)
        @max_page_size = 10
        page_size = setpagesize(5, :max => @max_page_size, :local => true)
        @submission_tracks = @entry.tracks_at_level(level_to_select, {:order => (params[:order] || default_contest_tracks_order)}, :per_page => page_size, :page => params[:page])
      end

      @goodies_button = false
      @goodies_button = true if !@goodies_button && !@entry.is_a?(Tps::Content) && !Tps::Goodie.of_content(@entry).blank?
      @goodies_button = true if !@goodies_button && @entry.is_a?(Tps::Content) && @entry.stopped? && !Tps::Goodie.of_content(@entry.related_content).blank?

      @fb_embeddable_music = @entry.is_a?(Track) || @entry.is_a?(Album) && !@entry.is_a?(Inbox) && !@entry.tracks.empty?

      @contribute_rightaway = (params[:contribute] == 'true' || params[:download] == 'true')
      @contribute_rightaway = false if DonationProcessors.in_successful_payment_handler?(self)
      @download = (params[:contribute] != 'true' && params[:download] != 'false')
      if use_cache?
        render_cached([@entry.id, @entry.action_cache_key_suffix(self), boolean_param_value(params[:contribute]),
                       boolean_param_value(params[:download])].flatten, 10.hours,
                      {:controller => "content", :action => "show", :id => params[:id]})
      end
    end

    # Enable downloading of album contents for albums where donations are NOT requested
    def download_bundle
      @bundle = Content.find(params[:id])
      @album = Content.find(@bundle.downloadable_album_id) #@bundle.bundle_for doesn't want to work for some reason
      raise Kroogi::NotFound unless @album.is_a?(Album)
      failure = "Folder does not allow downloads".t unless @album.is_a?(BasicFolderWithDownloadables) # FolderWithDownloadables become Albums when not downloadable -- allow to get to here, give meaningful error message
      if failure
        flash[:warning] = failure
        redirect_to(content_url(@album)) and return
      end
      unless user_has_downloaded?(@album)
        Activity.send_message(@album, current_user(:include_inactivated => true), :content_downloaded, {},
                              :from_related => params[:from_related])
        if current_user(:include_inactivated => true).is_a?(Guest)
          cookies[content_downloaded_cookie(@album)] = {:value => "1" , :expires => 2.days.from_now,
                                                        :domain => cookie_domain}
        end
      end
      KarmaPoint.create_from_id(session[:karma_point_id], :content => @bundle, :action => :download)
      
      redirect_to @bundle.s3_url
    end

    def remove_from_album
      @content = Content.active.find(params[:id])
      album = Content.active.find(params[:album_id])
      raise Kroogi::NotPermitted unless album && album.is_a?(Album) # Handle album subclasses
      unless album.is_a?(MusicAlbum)
        @content.remove_from_album(album)
      else
        return unless check_undeletability
        @content.destroy
      end
      render :text => ''
    end
    
    def remove_album_association
      bundle = Content.active.find(params[:id])
      @album = Content.active.find(params[:album_id])
      raise Kroogi::NotPermitted unless @album && @album.is_a?(Album) # Handle album subclasses
      raise Kroogi::NotPermitted unless bundle.is_a?(CoverArt) || bundle.is_a?(Bundle)
      raise Kroogi::NotPermitted unless permitted?(@album.user, :content_edit)
      return unless check_undeletability(bundle)
      bundle.destroy
      unless params[:llocale]
        respond_to do |wants|
          wants.js { render :nothing => true}
        end
      else
        @update_locales = APP_CONFIG.languages_short.keys - ['fr', params[:llocale]]
      end
    end
    
    def album_order
      params[:album_list_id].each_with_index do |id, position|
        AlbumItem.update(id, :position => position+1)
      end 
      render :text => ''
    end
    
    # remove "sticky" status from announcement
    def choose_stickyness
      announcement = Announcement.find_by_board_id(params[:id])
      check_edit_permission(announcement)
      announcement.stick_or_unstick!
      redirect_to user_url_for(current_actor)
    end

    def move_to_notes
      announcement = Board.find(params[:id])
      check_edit_permission(announcement)
      if announcement.sticky?
        announcement.stick_or_unstick!
        flash[:success] = 'Announcement was successfully moved to Notes section'.t
      else
        flash[:warning] = 'It was already in Notes section'.t
      end
      redirect_to userpage_path(announcement.user)
    end

    def downloads_report
      @entry = Content.find(params[:id])
      return access_denied unless can_view_donations_for?(@entry.user)

      @downloads = @entry.downloads.paginate(:all, :order => 'id desc',
        :page => params[:page], :per_page => setpagesize)

      @since = @entry.created_at
      @todays_count = @entry.downloads.count(:conditions => 
          ['created_at between ? and ?', Date.today.to_time,
          Date.today.to_time.end_of_day])

      @title = title_for_show(@entry) + ' :: %s' % 'downloads report'.t
      set_paging_header @downloads, :entity_name => 'download',
        :many_pages_case => 'Displaying downloads %1$d - %2$d'.t
    end
    
    def invite_guest_to_user_circle
      invite = Invite.guest_to_user_circle(params[:guest_invite], @locale)

      invite.errors.add_to_base('Email is not valid'.t) unless invite.
        user_email.match(User::EMAIL_REGEX)

      if Invite.find_by_user_email_and_inviter_id(invite.user_email, 
          invite.inviter_id)

        invite.errors.add_to_base("Invitation to join {{author}}'s Kroogi is already sent to {{guest_email}}" / [invite.inviter.display_name, invite.user_email])
      end

      Locale.with_locale(@locale) do
        invite.save! if invite.errors.blank?
      end
      @guest_invite = invite
    end

    def recent
      @title = 'Recent Content'.t
      @content_html_headers = true
      @force_not_contributed = true #let's cache it with Donate buttons for logged in users
      params[:page_size] = 50 if params[:page_size] && params[:page_size].to_i > 50
      #params[:page] = 5 if !logged_in? && params[:page] && (params[:page].to_i * setpagesize) > NewContent::max_entries
      unless read_fragment(recent_content_cache_key)
        @content, @pager = NewContent.recent_content(:page => params[:page] || 1, :per_page => setpagesize)
      end
    end

    def played
      track = Track.find_by_id(params[:id])
      ContentStat.mark_async(:played!, {:content => track, :user_id => logged_in? ? current_user.id : nil, :ip => request.remote_ip}) if track
      render :text => 'ok', :layout => false
    end

    def user_has_downloaded?(content)
      u = current_user(:include_inactivated => true)
      return cookies[content_downloaded_cookie(content)] if u.is_a?(Guest)
      u.has_downloaded?(content)
    end

    def accept_contest_terms
      content = Content.find(params[:id])
      terms = TermsAndConditions.find(params[:terms_id])
      content.create_terms_acceptance(current_user, terms)
      redirect_to content_url(content)
    end

    def fresh_contents
      entry = Content.find_by_id(params[:id])

      render :update do |page|
        page.replace "content_items_#{entry.id}", :partial => '/content/album_tracks_and_stuff',
             :locals => {:entry => entry, :no_contents_text => 'This folder is empty'.t}
        if (entry.is_a?(MusicAlbum))
          page.replace_html "music_album_attributes", :partial => "/content/music_album_attributes", :locals => {:entry => entry}
          page.replace_html "edit_content_links", :partial => '/content/sidebar/edit_content', :locals => {:entry => entry}
        end
      end unless entry.nil?
    end

    private

    def load_owner
      return @user if @user
      raise Kroogi::NotPermitted unless params[:user_id]
      @user = (params[:user_id] == current_actor.id ? current_actor : User.find_by_id(params[:user_id]))
      @user = nil unless @user && @user.active?
    end

    # Both show and comments use this to make sure users aren't trying to view image thumbs, blocked items, etc.
    def handle_content_exclusions
      @entry ||= Content.find(@content_id || params[:id])
      raise Kroogi::NotFound if @entry.class.name.to_s == 'ImageThumbnail'
      raise Kroogi::NotFound if @entry.featured_album?
      @entry.calc_in_inbox_by_user_data
      raise Kroogi::NotPermitted unless @entry.is_view_permitted? ||
              (permitted?(current_user, :moderate) && @entry.restriction_level >= Content.allow_moderators_to_view_this_circle_and_further) ||
              (current_user.admin? && params[:force_view])
      unless @entry.active?
        flash[:warning] = "This content item has been blocked by the moderation team, and is no longer available for viewing".t
        if permitted?(current_user, :moderate)
          return false
        else
          redirect_to(explore_path) and return false
        end
      end
    end

    def title_for_show(entry)
      "#{entry.user.login} :: #{entry.title_long}"
    end

    def handle_dl_link_expiration
      bundle_id, expires, sig = params[:id], params[:expires], params[:sig]
      sig ||= params['amp;sig']
      if bundle_id && b = Bundle.find_by_id(bundle_id)
        c = b.bundle_for
      end
      msg = 'The URL you specified has expired. Please use fresh download link.'.t
      target_url = c ? content_url(c) : (current_subdomain ? user_url_for(current_subdomain) : explore_path) 
      unless bundle_id && expires && sig
        flash[:error] = msg 
        redirect_to target_url and return false
      end
      unless download_signature(bundle_id, expires) == sig
        flash[:error] = msg
        redirect_to target_url and return false
      end
      if expires.to_i <= Time.now.to_i
        flash[:error] = msg
        redirect_to target_url and return false                
      end
      true
    end

    def show_post_options(entry)
      return false if entry.is_a?(Inbox)
      return false if entry.is_a?(MusicContest)
      return false if entry.is_folder_for_pictures_from_notes?
      entry.is_a?(Album) && entry.editable? && permitted?(entry.user, :content_add)
    end

    helper_method :recent_content_cache_key
    def recent_content_cache_key
      cache_key_with_locale(current_user.guest?, params[:page] || 1, setpagesize)
    end

    helper_method :level_to_select
    def level_to_select
      (params[:select_level] || -1).to_i
    end

    helper_method :default_contest_tracks_order
    def default_contest_tracks_order
      MusicContest::LATEST_TRACKS_ORDER_NAME
    end

    def check_edit_permission(content)
      raise Kroogi::NotPermitted unless permitted?(content.user, :content_edit, :content => content)
    end

    def load_prefixed_content_id
      @content_id_raw = params[:id]
      redirect_to '/' and return unless @content_id_raw 
      if @content_id_raw['-']
        @content_id = @content_id_raw.split('-').first.to_i
      else
        @content_id = @content_id_raw.to_i 
      end
    end

    def verify_content_url_path
      return if skip_path_verification
      return if params[:method] == 'uploader' #not important there

      @entry = Content.find(@content_id) if @content_id  
      if !@content_id
        log.debug "force_prefixed_content_ids: content id not found (raw one is #{@content_id_raw})"
        raise Kroogi::NotFound
      else
        normalized_params = params.clone
        if normalized_params.delete(:old_player_id)
          normalized_params.merge!(:download => true) if @entry.downloadable?
        end
        path = content_url(@entry, normalized_params.merge(:only_path => true))
        if (uri = request.request_uri) != path
          log.debug "force_prefixed_content_ids: #{path} expected, not #{uri}"
          if @entry.is_a?(Album) && !@entry.downloadable?
            downloadable_path = content_url(@entry, normalized_params.merge(:only_path => true, :force_downloadable => true))
            log.debug "downloadable_path is #{downloadable_path}"
            if downloadable_path == uri
              #correct downloadable path was requested for non-downloadable FWD or MusicAlbum - we consider that it's non-downloadable temporarily
              redirect_to(content_url(@entry, normalized_params), :status => :found)
              return
            end
          end
          redirect_to(content_url(@entry, normalized_params), :status => :moved_permanently)
        end
      end
    end

    def force_content_subdomain
      return if RAILS_ENV == 'test'
      if current_subdomain.to_s.downcase != @entry.user.login.downcase
        redirect_to(content_url(@entry, params), :status => :moved_permanently)        
      end
    end

    def force_plain_http
      if request.ssl?
        #warning: this only works if both http and https are on default ports
        redirect_to({
          :protocol => 'http://',
          :subdomain => current_subdomain, #it skips subdomain if this is not specified, hm
        }, :status => :moved_permanently)
      end
    end
end
