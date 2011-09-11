class HomeController < ApplicationController
  layout :conditional_layout

  skip_before_filter :verify_authenticity_token, :only => [:login, :signup, :change_language,
                                                           :reset_password]

  before_filter :login_required, :only => [:logout]
  before_filter :login_prohibited, :only => [:signup, :activate, :forgot_password, :login]

  before_filter :load_invite, :only => :signup

  verify :method => :post, :only => [:change_language], :redirect_to => { :controller => '/'}

  skip_before_filter :write_site_activity_log, :only => "monitor"

  def change_language
    # set_locale handles the actual language changing for us

    # strip off any locale parameter, so we don't just change it right back
    new_url = params[:target].blank? ? explore_url : params[:target]
    new_url.gsub!(/[\?&]locale=..&/, '&')
    new_url.gsub!(/[\?&]locale=../, '')
    redirect_to safe_redirect(new_url)
  end
  
  # sanity check for monit: checks db and memcached
  def monitor
    begin
      user = User.find_by_login('chief')
      user.id
      # User.cached(:find_by_login, :with => 'chief').id
      Rails.cache.fetch(user.cache_key){ user }
      render :text => "OK", :status => 200, :layout => false
    rescue
      render :text => "NOT OK", :status => 500, :layout => false
    end
  end

  def error
    raise 'Hello Engineers! This is error delivery test'
  end
  
  # benchmarking crap - temporary
  def bench
    if params[:cmd].starts_with?('loggedout')
      raise "Logout First" unless current_user.guest?
      case params[:cmd]
        when 'loggedout_userpage' 
          load_user
      end
    else 
      login_required
      raise "Login First" if current_user.guest?
      case params[:cmd]
        when 'loggedin_userpage'
          load_user
        when 'loggedin_mypage'
          params[:id] = current_user.id
          load_user
      end
    end
    layout = false
    layout = "layouts/#{params[:layout]}" if params[:layout]
    render :text => "OK", :status => 200, :layout => layout
  end
  # end benchmarking crap
  
  def test_email
    raise Kroogi::NotPermitted unless RAILS_ENV["development"]
    user = User.kroogi
    email = UserNotifier.create_reset(user, "password")
    render( :inline => email.encoded, :content_type => "text/plain" )
  end
    
  def login
    flash[:warning] = "Login required to access that resource".t if params[:flash]
    store_passed_location( params )
    if logged_in?
      redirect_back_or_default(userpage_path(current_actor))
    elsif request.post?
      login_from_params(params[:failure_action] || 'login', "We could not log you in. Are you sure you specified correct Kroogi Name and Password?".t)
    end
  end
  
  
  def index
    redirect_to :action => 'login'
  end
  
  def logout
    logout_impl
    flash[:warning] = "You have been logged out.".t
    redirect_to(explore_path)
  end

  def check_field_availability
    field = params[:field]
    value = params[:value]
    object = params[:model]
    allowed = [['user', 'login']]
    render :text => 'error' and return unless allowed.include?([object, field]) 
    model = Object.const_get(object.capitalize)
    render :text => (model.send("find_by_#{field}".to_sym, value.to_s) ? 'false' : 'true')
  rescue NameError => e
    logger.info "Error trying to check for field availability : #{e}"
    render :text => 'error'
  end
  
  def signup
    unless request.post?
      email = @invite.user_email if @invite
      @user = BasicUser.new(:email => email, :is_artist => false, :artist_kind => 'project')
      @user.language = I18n.locale
      @user.build_preference
    else
      create_user
    end
  end

  def activate
    logout_impl if logged_in?
    flash.clear
    return if params[:id].blank? and params[:activation_code].blank?
    
    activator = params[:activation_code] || params[:id]
    #@user = User.find_by_activation_code(activator, :conditions => 'activated_at is null')
    @user = User.find_by_activation_code(activator)
    @invite = @user ? @user.invites.first : nil # User is just registering, so IF they have ANY invites, it's the one that invited them to the site

    # Set email verified is true, if user activates through email
    @user.email_verified = @user.email if @user
    
    if @user and @user.activate
      after_activation
      session[CREATED_USER_KEY] = nil
      self.current_user = @user
      flash[:success] = "Your account is activated, and you have been logged in.".t
      unless @user.on_behalf_id == 0
        redirect_to(:controller => 'wizard', :action => 'basic_info_project')
      else
        if params[:created_on] == 'download'
          redirect_to home_url(@user.actor) #default would be content_url - not needed in this case
        else
          redirect_back_or_default(home_url(@user.actor))
        end
      end
    else
      params[:activation_code] = activator
      flash[:warning] = "Unable to activate the account.  Please check again or enter manually... or have you already completed activation?".t
    end
  end
  
  def reset_password
    logout_impl

    user = params[:user] ? User.active.find(:first, :conditions => {:type => ['BasicUser', 'AdvancedUser'], :email => params[:user][:email]}) : nil
    user = nil unless user
    unless user && user.email == params[:user][:email]
      flash[:error] = "Email doesn't match our records. Are you sure you entered it correctly?".t
      redirect_to :action => 'forgot_password' and return
    end

    begin
      User.transaction do
        new_passwd = user.create_password_reset
        UserNotifier::deliver_reset(user, new_passwd)
      end
    rescue Net::SMTPError, SystemCallError => e
      flash[:error] = "Sorry, we've had a temporary email sending problem. Please try again".t
      just_notify(e)
      redirect_to :action => 'forgot_password' and return
    end

    flash[:success] = "Your password has been reset and emailed to the address you provided".t
    redirect_to login_url
  end

  def set_session
    if (sid = params[:sid]) && (sid != User::SID_STUB)
      log.debug "sid is %s" % sid
      user = User.find_by_sid(sid)
      self.current_user = user #this sets up authenticated session
      if user
        user.update_attribute(:sid, User::SID_STUB) #for security - we only need this to happen once for given sid
        if user.remember_token
          set_rememberme_token(:save => false) #this propagates remember_me token if needed
        end
      end 
    end
    redirect_to(params[:target] || explore_path)
  end

  private

  # try to login user from params passed to controller
  # assumes params are called user[login] and :password
  def login_from_params(failure_action, failure_message)
    user_params = params[:user] || params[:user_to_login]
    login = user_params[:login] if user_params

    if (user = User.find_by_login(login)) && user.project?
      flash.now[:error] = '{{project_name}} is a Project. You need to log in as one of its hosts to manage it.' / login
      render :action => (failure_action.blank? ? 'login' : failure_action)
      return
    end
    user = User.authenticate(login, params[:password])
    if user
      if user_params[:start_following] == 'true'
        project = User.find_by_id(user_params[:project_to_follow])
        Relationship.make_user_follow_project(:follower => user, :followed => project) if project && (user != project) && !user.is_a_follower_of?(project)
      end
      
      # let user vote direclty on login. ref:4463
      unless user_params[:content_to_like].blank?
        content = Content.find(user_params[:content_to_like])
        unless !content || user.voted_up?(content) || kroogi_voting_disabled_for_test(content)
          user.vote_up(content)
        end
      end

      self.current_user = user
      unless user.activated_at
        user.activated_at = Time.now
        user.save_without_validation!
      end
      if params[:remember_me] == "1"
        set_rememberme_token
      end
      Activity.send_message(current_user, current_user, :logged_in)
      #update_friends_from_livejournal rescue nil

      flash[:signin_on_zero] = params[:signin_on_zero] if params[:signin_on_zero]

      options = {}
      options[:target] = redirect_back_or_default(home_url(current_actor), :find_target_only => true)
      finalize_successfull_logon(options)
      
    else
      @user = BasicUser.new(:login => user_params[:login]) if user_params
      if login.blank?
        failure_message = "We could not log you in. Received Kroogi Name is empty.".t
      end
      flash.now[:error] = failure_message
      render :action => (failure_action.blank? ? 'login' : failure_action)
    end
  end

  def logout_impl
    if logged_in?
      current_user.on_behalf_id = 0 if current_user.on_behalf_id != 0
      current_user.forget_me #it saves changes
    end
    delete_rememberme_token
    reset_session
  end
  
  # Called directly to instantiate a live journal information update in the background
  def update_friends_from_livejournal
    # self.current_actor.account.import_friends if self.current_actor.account
    # todo
    if self.current_actor.livejournal_account
      worker = MiddleMan.worker(:friend_sync_worker)
      worker.enq_sync_lj_friends(:arg => current_actor.id, :job_key => "user_#{current_actor.id}")
    end
  end
  
  # When a user is activated, create initial relationships and everything here
  def after_activation
    kuser = User.kroogi
    
    # All users are automatically in Kroogi user's interested circle, UNLESS they received an invitation to that circle
    # This logic is kinda weird, but better than getting an email saying "invitation will appear once you log in" and having it not appear at all
    unless kuser.nil? || (@invite && @invite.inviter == kuser && @invite.circle_id == Relationshiptype::TYPES[:interested])
      Relationship.make_user_follow_project(:follower => @user, :followed => kuser)
    end

    if @invite
      if @invite.site_invite?
        @invite.accept! # Accept site invitations right away
      else
        # Otherwise, send an activation message
        Activity.send_message(@invite, @invite.inviter, :invite_sent)
      end
      # Either way, put inviter in the new user's interested circle
      Relationship.make_user_follow_project(:follower => @invite.inviter, :followed => @user) if @invite.join_inviter_to_invited?  
    end

    true
  end

  def set_created_user(user)
    session[CREATED_USER_KEY] = user
  end

  def create_user
    user_params = params[:user] || params[:user_to_create]
    user_params[:display_name] ||= user_params[:login] if user_params

    begin
      user_params[:birthdate] = Date.strptime(user_params[:birthdate], I18n.t('date.formats.birthday')).to_s(:db) unless user_params[:birthdate].blank?
    rescue => e
      logger.debug("Problem with date format: #{e}")
    end

    unless user_params[:is_artist] == 'true'
      @user = BasicUser.new(user_params)
    else
      @user = user_params[:artist_kind] == 'project' ? BasicUser.new(user_params) : AdvancedUser.new(user_params)
      unless user_params[:artist_kind] == 'single'
        @project = Project.new(params[:project])
        thanks_action = 'thanks_project'
      end
    end

    thanks_action ||= 'thanks_user'

    #set_locale
    User.transaction do
      # Create basic user structure
      @user.profile = Profile.new
      @user.build_preference((params[:preference] || {}))
      @user.profile.account_type_id = Profile::PERSON
      @user.sid = User::SID_STUB

      if params[:fb_connect_user]
         @user.connect_fb_account(params[:fb_connect_id], current_fb_session_key)
         @user.skip_password_check = true
         @user.activate
      end

      if params[:tos].nil?
          @user.errors.add_to_base("You must read and accept Terms of Service to create an account.".t)
          raise ActiveRecord::RecordInvalid.new(@user)
      end
      
      if @project
        if @project.login.blank?
          @user.errors.add_to_base("Please enter a project name.".t)
          raise ActiveRecord::RecordInvalid.new(@user)
        end
        #add this to @user for it to be not saved (otherwise activation message will be sent - mailing doesn't understand DB transactions)
        if @project.login == @user.login
          @user.errors.add_to_base("Your Project Kroogi Name needs to differ from Personal Login.".t)
          raise ActiveRecord::RecordInvalid.new(@user)
        end
      end
      
      # No need to verify email if user has already clicked through from an invitation email
      if @invite
        @user.activate_rightaway if @user.email == @invite.user_email
        @user.save!
        after_activation
      else
        @user.save!
        # FB connected Users are activated right away too
        after_activation if params[:fb_connect_user]
      end

      if @project
        @project.init_on_creation(@user, params)
      end

      # If there's an invite, connect it to this user
      if @invite
        @invite.attributes = ({:user_id => @user.id, :display_name => @user.display_name, :activation_code => nil})
        @invite.save!
        Tracking::SiteInvitation.create(:tracking_user => @invite.inviter, :tracked_item => @user, :reference_item => @invite)
        @invite.accept! if @invite.initiated_by_invited?
      end

      start_following = (user_params[:start_following] == 'true')  
      project_to_follow = User.active.find_by_id(user_params[:project_to_follow]) if start_following && user_params[:project_to_follow]
      Relationship.make_user_follow_project(:follower => @user, :followed => project_to_follow) if project_to_follow

      # let FB connected user vote direclty on login. ref:4463
      if params[:fb_connect_user] && !params[:content_to_like].blank?
        content = Content.find(params[:content_to_like])
        unless !content || @user.voted_up?(content) || kroogi_voting_disabled_for_test(content)
          @user.vote_up(content)
        end
      end

    end

    if @user.recently_activated? || @user.facebook_connected?
      self.current_user = User.authenticate(@user.login, @user.password)
      unless @user.facebook_connected? && request.xhr?
        finalize_successfull_logon(:msg => "You've successfully joined the Kroogi Network!".t,
                                   :target => redirect_back_or_default(home_url(@user), :find_target_only => true))
      end
      if params[:ajax_mode]
        do_after_ajax_creation
      end
    else # Email address still requires activation
      set_created_user(@user)
      unless params[:ajax_mode]
          redirect_to(:controller => '/home', :action => thanks_action, :email => @user.email)
      else
        do_after_ajax_creation
      end

    end
    if @user.is_a?(BasicUser)
    else
      store_passed_location(params) #let project return to wizard
    end
  rescue ActiveRecord::RecordInvalid => e
    unless params[:ajax_mode]
      flash.now[:warning] = "Error creating your new account".t
    else
      render(:update) do |page|
        message = @user.errors.full_messages.join("<br/>")
        page["signup_form_errors_#{params[:dialog_id_suffix]}"].innerHTML = message
      end
    end
  end

  def conditional_layout
    %w(forgot_password login activate).include?(action_name) ? 'login' : 'home'
  end

  def load_invite
    @invite = Invite.find_by_activation_code(params[:id]) if params[:id]
    log.debug "invite found" if @invite
  end

  private
  def do_after_ajax_creation
    dialog_id_suffix = params[:fb_connect_user] ? params[:dialog_id_suffix].gsub('fb_', '') : params[:dialog_id_suffix]
    after_user_creation =  params[:fb_connect_user] ? "after_fb_user_created_#{dialog_id_suffix}();" : "after_user_created_#{dialog_id_suffix}();"
    flash[:signup_on_zero] = dialog_id_suffix
    render :js => "$('signup_form_errors_#{dialog_id_suffix}').innerHTML = ''; #{after_user_creation}"
  end

end
