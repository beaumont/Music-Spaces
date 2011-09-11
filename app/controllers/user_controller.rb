class UserController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:founder_order, :toggle_getting_around, :index]
  
  # TODO: OPEN SYSTEM requires slight action here
  before_filter :login_required, :except => [:feed, :announcements, :announcements_feed, :explore, :index, :gallery, :about, :tags, :comments]

  before_filter :load_user, :except => [:switch, :explore, :following, :projects_have_favorite, :favorite_add, :favorite_remove]
  before_filter :user_required, :only => [:index, :favorites, :gallery, :announcements, :announcements_feed, :comments, :thread, :tags, :tag_cluster, :about] 
  before_filter :project_owner_required, :only => [:pending_founders, :founders_display_options, :make_founder_shy, :founder_order, :edit_founder, :unhide]

  # Requires a @user with activity
  before_filter :login_or_not_a_bum_required, :only => [:index, :gallery, :about]

  after_filter :collect_stats, :only => [:index]
  
  helper_method :featured_content_key, :news_section_key,
    :popular_section_key, :download_section_key

  before_filter :store_location, :only => [:index, :comments]
  skip_before_filter :choose_system_message, :only => [:following]

  skip_before_filter :write_site_activity_log, :only => [:following]
  before_filter :force_locale_in_url, :only => [:explore, :index]


  with_options(:if => proc{ |controller| controller.send(:use_cache?) }) do |c|
    c.caches_action :index,       :expires_in => 5.minutes, :cache_path => proc{|c| c.cache_key_with_locale(
            c.params[:order] || DefaultOrderings::COLLECTION, c.params[:page] || 1,
            c.getpagesize(PageSize::Sets::COLLECTION[0], :session_key => PageSize::Keys::COLLECTION))}
    c.caches_action :about,       :expires_in => 5.minutes, :cache_path => proc{|c| c.cache_key_with_locale}
    c.caches_action :feed,        :expires_in => 5.minutes, :cache_path => proc{|c| c.cache_key_with_locale}
    c.caches_action :announcements, :expires_in => 5.minutes, :cache_path => proc{|c| c.cache_key_with_locale}
    c.caches_action :announcements_feed, :expires_in => 5.minutes, :cache_path => proc{|c| c.cache_key_with_locale}
    c.caches_action :inboxes,     :expires_in => 5.minutes, :cache_path => proc{|c| c.cache_key_with_locale}
    c.caches_action :favorites,   :expires_in => 15.minutes, :cache_path => proc{|c| c.cache_key_with_locale}
    c.caches_action :following,     :expires_in => 10.minutes, :cache_path => proc{|c| c.cache_key_with_locale}
    c.caches_action :gallery,     :expires_in => 10.minutes, :cache_path => proc{|c| c.cache_key_with_locale}
    c.caches_action :comments,    :expires_in => 5.minutes,
                    :cache_path => proc{|c| c.cache_key_with_locale(c.params[:page] || 1, c.getpagesize)}
    c.caches_action :thread,      :expires_in => 5.minutes,
                    :cache_path => proc{|c| c.cache_key_with_locale(c.params[:thread_id])}
    c.caches_action :tags,        :expires_in => 15.minutes,
                    :cache_path => proc{|c| c.cache_key_with_locale(c.params[:tag], !!c.params[:or],
                                                                    c.params[:page] || 1, c.getpagesize)}
  end
 
  TAB_ITEMS_NUM = 25

  verify :method => :post, :only => :toggle_collection_inclusion

  def dissolve_tracks_and_texts(all_content, max_tracks = nil, max_texts = nil, max_others = nil)
    tracks = (all_content.select {|c| c.class == Track} || [])
    tracks = tracks[0..max_tracks - 1] if max_tracks
    texts = (all_content.select {|c| c.class == Textentry} || [])
    texts = texts[0..max_texts - 1] if max_texts
    other_content = (all_content.reject {|c| [Textentry, Track].include?(c.class)} || [])
    other_content = other_content[0..max_others - 1] if max_others
    return tracks, texts, other_content
  end

  def index
    if DonationProcessors.in_successful_payment_handler?(self)
      flash.now[:success] = "Thank you for supporting {{user_name}}" / @user.display_name
      PublicQuestionHelper::set_question_artist_id(@user, self, :now => true, :force_show => true)
    end
    gallery        = @user.featured_album
    featured = gallery.album_contents.select{|g| !g.instance_of?(Board) && !g.is_a?(BasicFolderWithDownloadables) && g.active? && g.is_view_permitted?}
    @featured_tracks, @featured_texts, @featured_other_content = dissolve_tracks_and_texts(featured, 40, 40, 104)

    favorites = @user.all_favorites
    @favorite_tracks, @favorite_texts, @favorite_other_content = dissolve_tracks_and_texts(favorites, 2, 2, 5)

    @announcements  = Board.announcements_of(@user)
    @user_notes  = Board.usernotes_of(@user).paginate(:page => params[:page],
                                                      :per_page => getpagesize(5, :session_key => 'ann_page_size'))
    @activities     = @user.public_activities
    @in_rainbows   = @user.contents.in_rainbows.select{|x| x.is_in_startpage?}.select(&:is_view_permitted?)
    @music_contests = @user.all_contents.music_contests.select(&:is_view_permitted?)
    # tag cloud for user
    @tags = @user.contents.tag_counts(:limit => 50)
    @account_setting = @user.account_setting
    @tab = :kroogi
    @show_getting_around = @user && current_user.is_self_or_owner?(@user) && !@user.project?

    if @user.collection?
      @post_options = [:project]
      @post_content_word = nil
      @collections = @user.inclusions.collections.direct.with_projects.order_by_name

      order = params[:order] if %w(popularity date name).include?(params[:order])
      order ||= DefaultOrderings::COLLECTION
      @page_sizes = PageSize::Sets::COLLECTION
      @projects = @user.inclusions.projects.with_projects.send("order_by_#{order}")
      @include_stopped = !params[:include_stopped].blank?
      unless @include_stopped
        @projects = @projects.unstopped
      end
      @projects = @projects.paginate(:page => params[:page],
                                     :per_page => setpagesize(@page_sizes[0], :session_key => PageSize::Keys::COLLECTION))
      @collection_order = order
    end
  end

  def about
    @activities = @user.public_activities
    @announcements  = Board.announcements_of(@user, :limit => 5).
            paginate(:page => params[:page], :per_page => getpagesize(5, :session_key => 'ann_page_size'))
    @title = 'Visitors Center'.t
  end

  # list of users this person is following
  def following
    respond_to do |wants|
      wants.json { render :json => current_actor.friend_list }
    end
  end

  def follows
  end
  
  # Save user's getting_around preference (pane open or closed)
  def toggle_getting_around
    if @user && current_user.is_self_or_owner?(@user)
      @user.preference.update_attribute(:getting_around_open, params[:state] != 'false')
    end
    render(:nothing => true)
  end
  
  # Show all of the user's inboxes (including archived)
  def inboxes
    (@archived_inboxes, @active_inboxes) = @user.inboxes.partition{|i| i.archived?}
  end
 
  def announcements_feed
    @announcements  = Board.announcements_of(@user, :limit => 50, :kind => :all).select{ |a| a.is_view_permitted? }

    params[:format] = 'rss'
    respond_to do |format|
      format.rss { render(:layout => false) }
    end
   end

  # RSS feed of public information
  def feed
    params[:format] = 'rss'
    @activities     = @user.activities.only( Activity.type_group(:public_feed) ).only_from(@user).newest_first.top(10).with_viewable_content
    @link           = url_for(:controller => 'user', :action => 'index', :id => @user)
    
    content_date = @activities.empty? ? nil : @activities.first.created_at

    # Similar to http://blog.zenspider.com/2005/12/304-not-modified-for-rails.html
    if request.env.include? 'HTTP_IF_MODIFIED_SINCE'
      since_date = Time.parse request.env['HTTP_IF_MODIFIED_SINCE']
      if content_date.nil? || since_date >= content_date
        render :nothing => true, :status => 304
        return true
      end
    end
    
    response.headers['Last-Modified'] = content_date ? content_date.httpdate : Time.now.httpdate
    respond_to do |format|
      format.rss { render(:layout => false) }
    end
  end

  def activity
    @activities     = @user.activities.only( Activity.type_group(:public_feed) ).only_from(@user).newest_first.paginate(:per_page => setpagesize, :page => params[:page])
  end
  
  def delete
    unless current_actor.is_self_or_owner?(@user)
      flash[:warning] = "You can only delete your own accounts. Are you acting as the right user?"
      redirect_to '/activity/list' and return
    end
    
    if request.post? || request.delete?
      proj_or_user = User.find(params[:id])
      kind = proj_or_user.project? ? 'project' : 'account'
      if @user.validate_password(current_user, params[:password])
        if proj_or_user.delete!
          delete_rememberme_token
          flash[:warning] = "%s has been deleted." / proj_or_user.display_name
          redirect_to kind == 'project' ? '/activity/list' : '/'
        else
          flash[:error] = "Unable to delete %s." / proj_or_user.display_name
        end
      else
        flash[:error] = "The password you entered is incorrect!".t
      end
    end
  end
  
  def switch
    if current_user.id.to_s == params[:id] || params[:id].blank?
      current_user.on_behalf_id = 0
      current_user.save_without_validation!
    elsif current_user.projects.detect { |project| project.id.to_s == params[:id] }
      current_user.on_behalf_id = params[:id]
      current_user.save_without_validation!
    end

    # Force ignore stale object
    new_actor = User.find(current_user.id).on_behalf
    (new_actor.livejournal_account.import_friends rescue nil) if new_actor && new_actor.livejournal_account
    new_actor ||= current_user
    redirect_to safe_redirect(params[:url] || home_url(new_actor))
    # redirect_to safe_redirect(params[:url] || userpage_path(new_actor))
    # redirect_to home_url(new_actor)
  end

  
  def favorites
    favorites = @user.all_favorites
    @favorite_tracks, @favorite_texts, @favorite_other_content = dissolve_tracks_and_texts(favorites)    
  end
    
  def pending_founders
    founders
    render :action => 'founders'
  end
  
  def founders
    @tab = :hosts
    @kroog = @user.kroogi_settings.detect{|x| x.relationshiptype_id == Relationshiptype.founders}
    if @kroog.nil?
      @kroog = @user.kroogi_settings.new(:relationshiptype_id => Relationshiptype.founders)
      @kroog.save!
    end
    
    @founders = @user.project_founders
    @invited_founders = @user.invites_i_sent.founders.pending
  end
  
  def unhide
    if @user.private?
      @user.unhide
      if @user.collection?
        flash[:success] = "This collection and its subcollections you own are now open to the public".t
      else
        flash[:success] = "This project is now open to the public".t
      end
    end
    redirect_to userpage_path(@user)
  end
  
  def hide
    unless current_actor.is_self_or_owner?(@user)
      flash[:warning] = "You can only hide your own accounts. Are you acting as the right user?"
      redirect_to '/activity/list' and return
    end

    @user.update_attribute(:private, true) unless @user.private?
    flash[:success] = "This account is now hidden".t
    redirect_to userpage_path(@user) and return
  end
  
  def edit_founder
    @tab = :hosts
    if @user.project_founders_include?(params[:founder_id])
      @founder = User.find(params[:founder_id])
    else
      raise Kroogi::NotFound
    end
    @preference = @user.preference
    @invite = @user.invites_i_sent.founders.sent_to(@founder).first
    
    if request.post?
      invite_ok         = @invite.role_name == params[:role_name] || @invite.update_attribute(:role_name, params[:role_name])
      new_shy_founders  = params[:show_founder] ? @preference.shy_founders - [@founder.id] : (@preference.shy_founders + [@founder.id]).uniq
      preference_ok     = @preference.update_attribute(:shy_founders, new_shy_founders)
      
      if invite_ok && preference_ok
        flash[:success] = "Successfully edited a host".t
        redirect_to :action => 'founders', :id => @user
      else
        flash[:warning] = "Error editing a host".t
      end

    end
  end
  
  def founders_display_options
    @tab = :hosts
    @preference = @user.preference
    if request.post?
      if @preference.update_attributes(params[:preference])
        flash[:success] = 'Settings were successfully updated.'.t
      else
        flash[:warning] = 'Error updating settings.'.t
      end
    end
  end
  
  # Remove founder from kroogi page via founders_display_options
  def make_founder_shy
    founder = User.find(params[:founder_id])
    
    unless @user.preference.shy_founders.include?(founder)
      @user.preference.update_attribute(:shy_founders, @user.preference.shy_founders + [founder.id])
    end
    
    render(:update){|p| p["item_#{founder.id}"].hide}
  end
  
  def founder_order
    founder_relationships = Relationship.all_relationships(@user, [Relationshiptype.founders])
    
    params[:founder_list_id].each_with_index do |fid, position|
      if founder_rel = founder_relationships.detect{|x| x.related_user_id == fid.to_i}
        founder_rel.update_attribute(:display_order, position+1)
      end
    end 
    render(:nothing => true)
  end
  
  def gallery
    #response to funny urls like 'http://igorek.kroogi.com/user/gallery/kroogi.com' (wonder where they come from)
    redirect_to user_url_for(@user, 'gallery') and return unless params[:format].blank?

    @tab = :showcase
    @gallery = @user.gallery_items
  end
  
  def announcements
    @announcements = Board.active.find(:all, :conditions => { :user_id => @user.id, :foruser_id => nil}, :order => 'created_at desc')
  end
  
  def comments
    @comments = @user.profile.all_comments(false, {:order => "created_at"})
  end
  
  def thread
    comment = Comment.find_by_id(params[:thread_id])
    if comment.nil? || !comment.can_see? || (comment.deleted? && !comment.non_deleted_children?)
      flash[:warning] = "Cannot view that comment".t
      redirect_to userpage_path(@user)
    end
  end
    
  def tags
    @tags = @user.contents.tag_counts(:limit => 100)
    
    full_match = (params[:or] ? false : true)
    params[:tag] = '' unless params[:tag]
    tag = params[:tag]
    @search_pages = Content.active.paginate_tagged_with(tag,
          :per_page => setpagesize, :page => params[:page], :conditions => {:user_id => @user.id},
          :total_entries => Content.active.count_tagged_with(tag, :conditions => ['user_id = ?', @user.id])
    )
    @content_kind_displayname = "%s's Tags" / h(@user.display_name)
  end
  
  def tag_cluster
    raise Kroogi::NotFound unless @user
  end
  
  def explore
    load_vars_for_explore_page(!!params[:uncache] && logged_in? && current_actor.admin?)
    render(:layout => 'explore')
  end
  
  def restore
    redirect_to userpage_path(params[:id]) and return unless current_actor.moderator? && @user && @user.blocked?
    return unless request.post?
    
    @restore = Moderation::Restore.new(:message => params[:restore][:message], :user_id => current_actor.id, :reportable_type => @user.class.name.to_s, :reportable_id => @user.id)
    if @restore.save
      flash.clear
      flash[:success] = "#{@user.login} has been restored".t
      redirect_to userpage_path(@user)
    else
      flash[:warning] = "Error restoring user".t
    end
  end
  
  def block
    redirect_to userpage_path(params[:id]) and return unless permitted?(current_actor, :moderate) && @user && @user.active?
    return unless request.post?

    @block = Moderation::Block.new(:reason => params[:block][:reason], :message => params[:block][:message], :user_id => current_actor.id, :reportable_type => @user.class.name.to_s, :reportable_id => @user.id)
    if @block.save
      flash[:success] = "#{@user.login} has been blocked".t
      redirect_to userpage_path(@user)
    else
      flash[:warning] = "Error blocking user".t
    end
  end

  def projects_have_favorite
    begin
      if params[:type] && params[:type] == 'User'
        favorite = User.active.find(params[:id])
        return_to_path = user_path_options(favorite)
      else
        favorite = Content.active.find(params[:id])
        return_to_path = content_url(favorite)
      end
      raise Kroogi::Error('Nothing to make favorite'.t) unless favorite
      projects = (params[:favs] || []).map{|id| User.find_by_id(id)}.compact
      current_user.projects_have_favorite(favorite, projects)
      unless projects.empty?
        flash[:success] = "Your favorites were updated".t
      else 
        flash[:success] = "Successfully removed {{title}} from favorites" / favorite_title(favorite)
      end
    rescue Kroogi::Error => e
      flash[:error] = e.message
    end
    redirect_to return_to_path
  end

  def favorite_add
    favorite_add_or_remove([current_user])
  end

  def favorite_remove
    favorite_add_or_remove([])
  end

  def test_error
    msg = 'привет, мир!'
    AdminNotifier.async_deliver_admin_alert(msg)
    raise msg
  end

  def toggle_collection_inclusion
    ci = CollectionInclusion.find(params[:id])
    raise Kroogi::NotPermitted unless current_user.is_self_or_owner?(ci.parent)
    ci.toggle_stop!
    render :text => toggle_collection_inclusion_caption(ci)
  end
  
  def wood
    @dir=CollectionProject.all
    log.debug "Dir Tree #{@dir.size}\n"
  end

  def enable_questions
    u = User.find_by_id(params[:id])
    raise Kroogi::NotPermitted unless current_user.is_self_or_owner?(u)
    unless u.questions_enabled?
      u.toggle_rare_setting!(:questions_enabled)
      flash[:success] = "Your forum feature is enabled.".t
    end
    redirect_to :controller => "/preference", :action => :show, :id => u.id
  end

  protected

  def favorite_add_or_remove(to)
    favorite = params[:type] && params[:type] == 'User' ? User.active.find(params[:id]) : Content.active.find(params[:id])
    return if favorite.nil?

    current_user.projects_have_favorite(favorite, to)
    render :layout => false
  end

  def load_vars_for_explore_page(invalidate = false)
    if invalidate
      if permitted?(current_user, :admin_only)
        [APP_CONFIG.hostname, APP_CONFIG.ru_host].each do |domain|
          ['en', 'ru'].each do | lang |
            [0..featured_content_variants_num].each do |num|
              expire_fragment(featured_content_key(num, lang, domain))
            end

            expire_fragment(download_section_key(lang, domain))
            expire_fragment(news_section_key(lang, domain))
            expire_fragment(popular_section_key(lang, domain))
            expire_fragment(weekly_top_section_key(lang, domain))
          end
        end
        flash.now[:success] = 'The explore page cache have been cleared'.t
      else
        flash.now[:warning] = "You don't have permissions to do that".t
      end
    end

    unless read_fragment(download_section_key)
      @download_albums = FeaturedItem.download_albums(TAB_ITEMS_NUM,
            :only_languages => current_user.welcome_content_languages)
    end
    
    init_new_section
    init_popular_section
    init_weekly_top


    fn = featured_content_variants_num
    @featured_content_number = rand(fn)
    unless read_fragment(featured_content_key(@featured_content_number))
      @featured_content = FeaturedItem.items(fn, :only_languages => current_user.welcome_content_languages)
    end
    @announcements_user = User.find_by_login(Kroogi::KROOGI_ACCOUNT)
    @announcements = Board.announcements_of(@announcements_user, :limit => 10) if @announcements_user
  end

  def init_new_section
    unless read_fragment(news_section_key)
      @new_content = Content.recent(:per_page => TAB_ITEMS_NUM, :only_albums => true, :only_languages => current_user.welcome_content_languages)
    end
  end

  def init_popular_section
    unless read_fragment(popular_section_key)
      @popular_projects = User.popular(20, :only_languages => current_user.welcome_content_languages)
    end
  end

  def init_weekly_top
    unless read_fragment(weekly_top_section_key)
      @weekly_top = Content.weekly_top_contributions(:limit => 7, :lang => I18n.locale)
      @weekly_top = @weekly_top.map {|content_id| Content.active.public.find_by_id(content_id)}.select{|content| content.cover_art_url }.compact
    end
  end

  private
    
  def project_owner_required
    unless current_actor.is_self_or_owner?(@user)
      raise Kroogi::NotPermitted
    end
  end
  
  def user_required
    raise Kroogi::NotFound unless @user
  end

  # in after filter otherwise stats won't get collected do to caching.
  def collect_stats
    ContentStat.mark_async(:viewed!, {:content => @user, :user_id => logged_in? ? current_user.id : nil}) unless (@user == current_actor || Browser.is_megatron?(request))
  end
  
  
  def authorize_user
    return if session["pvt_fd_ok_#{params[:id].to_i}".to_sym]
    authenticate_or_request_with_http_basic("Enter Authorization for Private Messages Feed") do |username, password|
      user = User.active.find_by_login(username)
      session["pvt_fd_ok_#{params[:id].to_i}".to_sym] = (user && user.is_self_or_owner?(@user) && user.authenticated?(password))
    end
  end

  def featured_content_variants_num
    TAB_ITEMS_NUM
  end

  def featured_content_key(variant_num, lang = I18n.locale, domain = user_domain)
    cache_key_with_locale()
    "#{domain}/helloworld/#{Kroogi.translation_mtime.stamp}/featured_#{lang}/#{variant_num}"
  end

  def news_section_key(lang = I18n.locale, domain = user_domain)
    "#{domain}/helloworld/#{Kroogi.translation_mtime.stamp}/news_content_#{lang}"
  end

  def popular_section_key(lang = I18n.locale, domain = user_domain)
     "#{domain}/helloworld/#{Kroogi.translation_mtime.stamp}/popular_#{lang}"
  end

  def download_section_key(lang = I18n.locale, domain = user_domain)
    "#{domain}/helloworld/#{Kroogi.translation_mtime.stamp}/download_and_support_#{lang}"
  end

  def toggle_collection_inclusion_caption(inclusion)
    inclusion.stopped? ? 'Show'.t : 'Hide'.t
  end
  helper_method :toggle_collection_inclusion_caption

   def run_basic_auth
     if [:index, :explore].include?(action_name.to_sym)
       return true if request.xhr?
     end
     super
   end

end
