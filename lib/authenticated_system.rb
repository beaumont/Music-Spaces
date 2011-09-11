module AuthenticatedSystem
  protected
  
  REMEMBER_ME_TOKEN = "auth_token_#{RAILS_ENV}"

  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  # Available as helper in a view
  def logged_in?(options = {})
    !current_user(options).is_a?(Guest)
  end

  # Check if the user is authorized to execute an action.
  #
  # Override this method in your controllers if you want to restrict access
  # to only a few actions or if you want to check if the user
  # has the correct rights. If this method returns false access to action would not be allowed.
  def authorized?
    if logged_in? || posing_as_logged_out?
      super_user || current_user.admin?
    end
  end
  
  def posing_as_logged_out?
    (current_user.nil? || current_user.is_a?(Guest)) && super_user
  end
  
  # Helper, to check if the user is allowed to view a subsection of a page, in a given context
  #  
  # May override this method in your helpers if you want to customize the behavior
  # Differs from authorized? as its stricctly used for governing visibility of sections in views and has no side effect on access controls
  def permitted?(target_user_or_project, context = :any_context, options = {})
    if target_user_or_project.nil? || !logged_in?
      return false
    end

    case context
    when :contact then return logged_in?
    when :moderate then return logged_in? && current_actor.moderator? || current_user.moderator?
    when :any_context
      current_user.id == target_user_or_project.id
    when :content_add, :profile_edit, :content_edit
      return true if current_user.is_self_or_owner?(target_user_or_project)
      return true if context == :content_add && options[:album] && options[:album].is_a?(MusicContest)
      return true if context == :content_edit && options[:content] && options[:content].music_contest_item? &&
              current_user.is_self_or_owner?(options[:content].created_by)
    when :favorite_or_vote
      return true if current_actor.id != target_user_or_project.id
      if options[:content] && options[:content].music_contest_item?
        return !current_user.is_self_or_owner?(options[:content].created_by)
      end
    when :can_invite
      return false if current_user.id == target_user_or_project.id || current_actor.id == target_user_or_project.id
      return false if target_user_or_project.is_a_follower_of?(current_actor, Relationshiptype.by_invite_only)
      return false if target_user_or_project.collection?
      return true
    when :can_invite_closer
      return Relationship.can_invite_closer?(current_actor, target_user_or_project)
    when :can_follow
      return false if current_user.id == target_user_or_project.id || current_actor.id == target_user_or_project.id
      return false if target_user_or_project.project? && current_user.is_self_or_owner?(target_user_or_project)
      return !current_actor.is_a_follower_of?(target_user_or_project)
    when :can_get_closer
      return false if current_user.id == target_user_or_project.id || current_actor.id == target_user_or_project.id
      return false if target_user_or_project.project? && current_user.is_self_or_owner?(target_user_or_project)
      return false if Relationship.has_follower?(target_user_or_project, current_user, Relationshiptype.circle_and_closer(target_user_or_project.closest_open_circle))
      true
    when :admin_only
      target_user_or_project.admin?
    when :write_pvtmessage
      current_actor && current_actor.can_write_pvtmessage_to?(target_user_or_project)
    end
  end

  # Accesses the current user from the session. This is the currently authenticated user
  # Use with care as most actions require current_actor
  def current_user(options = {})
    @current_users ||= {}
    u = @current_users[options.inspect]
    u ||= (session[:user] && User.find_by_id(session[:user], :include => [:on_behalf]))
    u ||= created_user if options[:include_inactivated]
    u ||= Guest.new
    if u.is_a?(Project)
      log.warn "current user was Project (%s). This is invalid." % u.login
      u = Guest.new
    end
    @current_users[options.inspect] ||= u
    u
  end

  # for auto login, and assuming another user's soul.
  def super_user
    return nil unless session[:admin_user]
    @current_admin ||= User.find_by_id(session[:admin_user])
  end
  
  def super_user=(user)
    admin_user = user.admin? ? user : nil
    session[:admin_user] = admin_user.id
    @current_admin = admin_user
  rescue  NoMethodError # this will happen when admin_user.id gets called since it will be nil if user isn't admin
    session[:admin_user] = @current_admin = nil
  end
  
  # Accesses the current actor from the session. 
  # Actor may be a currently authenticated user or possibly another user (project) that this user is acting on behalf of.
  # Available as helper in a view
  def current_actor
    current_user.actor
  end

  # Store the given user in the session.
  def current_user=(new_user)
    session[:user] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
    @current_users = nil
  end



  # Filter method to enforce a login requirement.
  #
  # To require logins for all actions, use this in your controllers:
  #
  #   before_filter :login_required
  #
  # To require logins for specific actions, use this in your controllers:
  #
  #   before_filter :login_required, :only => [ :edit, :update ]
  #
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :login_required
  #
  # login_required requires LOGGED IN USER
  def login_required
    logged_in? ? true : access_denied
  end

  def login_prohibited
    logged_in? ? redirect_to(explore_path) : true
  end

  def admin_required
    access_denied unless authorized?
  end

  # Weird logic for semi-closed system -- hide users who haven't done anything yet
  # Why? There's no valid explanation for it that I can come up with, but them's the orders
  def login_or_not_a_bum_required
    return if user_domain =~ /(?:(?:http:\/\/|\bw{3}\.|^))kroogi\.[A-Za-z]{2,4}(?:\/|)$/
    logged_in_or_given_user_is_not_a_bum? ? true : access_denied
  end
  
  def logged_in_or_given_user_is_not_a_bum?
    logged_in? || given_user_is_not_a_bum?
  end
  
  def given_user_is_not_a_bum?
    @user #&& !@user.activities.only( Activity.type_group(:public_feed) ).only_from(@user).top(1).empty?
  end


  # Redirect as appropriate when an access request fails.
  #
  # The default action is to redirect to the login screen.
  #
  # Override this method in your controllers if you want to have special
  # behavior in case the user is not authorized
  # to access the requested action.  For example, a popup window might
  # simply close itself.
  def access_denied
    respond_to do |accepts|
      accepts.html do
        store_location
        redirect_to login_url
        # redirect_to signup_path
      end
      accepts.xml do
        headers["Status"]           = "Unauthorized"
        headers["WWW-Authenticate"] = %(Basic realm="Web Password")
        render :text => "Could't authenticate you", :status => '401 Unauthorized'
      end
      accepts.js do
        render(:update) {|p| p.redirect_to(login_url) }
        # render(:update) {|p| p.redirect_to(signup_path) }
      end        
    end
    false
  end  

  def kroogi_url?(url)
    [APP_CONFIG.hostname, APP_CONFIG.ru_host].compact.uniq.any? {|h| /http:\/\/(.*\.)?#{h.gsub('.', '\.')}/.match(url)}
  end

  def url_to_store(return_to)
    to_store   = return_to
    to_store ||= request.referer if (request.referer && kroogi_url?(request.referer))
    to_store = nil if to_store == ""
    # Don't store certain urls
    to_store   = nil if to_store && to_store[/\/(?:login|signup|explore|thanks|activate|logout|forgot_password|reset_password|selenium)/]
    to_store
  end

  def store_passed_location(params)
    session[:return_to] = nil unless params[:return_to].blank?
    to_store   = url_to_store(params[:return_to])

    if to_store
      to_store = safe_redirect(to_store)
      session[:return_to] = to_store
    end
  end

  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.url
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.
  def redirect_back_or_default(default, options = {})
    target = url_to_store(session[:return_to])
    (target = logged_in? ? home_url(current_user) : nil) if target == '{home}'
    #target = nil if target == APP_CONFIG.hostname || target == APP_CONFIG.hostname + '/'
    target = default unless target
    target = safe_redirect(target)
    session[:return_to] = nil
    return target if options[:find_target_only]
    redirect_to(target)
  end
  
  # Allow redirect url if it's to a kroogi domain -- else, redir to explore page
  # TODO: rename it to safe_url - it doesn't redirecr so the name is misleading now
  def safe_redirect(url)
    url ||= '/explore'
    url = url_for(url) if url.is_a?(Hash)
    return url if RAILS_ENV == 'development' || RAILS_ENV == 'test'
    # Remember that kroogi.eu (and many more) is/are just as valid as kroogi.com. AND, we have krugi.net ...
    return url if url && (url.starts_with?('/') || kroogi_url?(url))
    return url
    #raise Kroogi::NotPermitted, url
  end
  


  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_user, :current_actor, :logged_in?, :permitted?, :given_user_is_not_a_bum?, :logged_in_or_given_user_is_not_a_bum?, :super_user, :authorized?
  end

  # When called with before_filter :login_from_cookie will check for an :auth_token
  # cookie and log the user back in if apropriate
  def login_from_cookie
    return if logged_in?
    return unless cookies[REMEMBER_ME_TOKEN]
    user = User.find_by_remember_token(cookies[REMEMBER_ME_TOKEN])
    if user && user.remember_token?
      self.current_user = user
      if !satellite_request?
        set_rememberme_token
        finalize_successfull_logon(:target => request.url)
      end
    end
  end

  def delete_rememberme_token
    cookies.delete REMEMBER_ME_TOKEN, :domain => cookie_domain 
  end
  
  def set_rememberme_token(options = {})
    options.reverse_merge!(:save => true) 
    current_user.remember_me if options[:save]
    cookies[REMEMBER_ME_TOKEN] = {
            :value => current_user.remember_token,
            :expires => current_user.remember_token_expires_at,
            :domain => cookie_domain }
  end

  private
  @@http_auth_headers = %w(X-HTTP_AUTHORIZATION HTTP_AUTHORIZATION Authorization)
  # gets BASIC auth info
  def get_auth_data
    auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
    auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
    return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil] 
  end
end
