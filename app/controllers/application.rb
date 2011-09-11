require "digest/md5"

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  # don't show these params in the logs
  filter_parameter_logging "password", "password_confirmation", "account[password_confirmation]", "account[password]"
  skip_before_filter :verify_authenticity_token, :only => [:render_404]
  
  helper_method :local_domain?, :uri_escape #, :uri_unescape

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4752ac1db85dcb0c94f14c7e72b5a9fe'
  
  include ERB::Util   # html_escape
  include AuthenticatedSystem
  include FacebookConnect::Rails::Controller
  include UserLocation
  include ExceptionNotifiable
  local_addresses.clear

  # Pick a unique cookie name to distinguish our session data from others'
  # DO NOT specify :session_domain here cause it will be set dynamically
  session :session_key => '_krugi_session_id_' + ENV['RAILS_ENV'].to_s

  layout "/layouts/application"

  # first things first
  if RAILS_ENV =~ /rc/
    before_filter :run_basic_auth
    def run_basic_auth
      return true if request.post?
      unless action_name[/monitor|login_from_params/]  || logged_in?
        authenticate_or_request_with_http_basic("The Realm of Kroogi #{RAILS_ENV}") do |username, password|
          User.authenticate(username, password)
        end
      end
    end
  end

  include SiteActivityLoggerForControllers
  
  #before_filter :local_cache_for_request
  before_filter :set_locale
  before_filter :login_from_cookie
  #before_filter :check_if_should_be_logged_out #not needed now that we have single domain
  before_filter :set_model_user
  before_filter :ensure_valid_user
  before_filter :new_relic_custom_params
  before_filter :generate_ie6_flash_message
  before_filter :reject_invalid_formats
  before_filter :choose_system_message
  before_filter :choose_admin_flash
  before_filter :write_site_activity_log

  def new_relic_custom_params
    NewRelic::Agent.add_custom_parameters(:user_subdomain => user_subdomain)    
    NewRelic::Agent.add_custom_parameters(:current_user => current_user ? current_user.login : nil)    
  end

  # after filters
  after_filter {Thread.current['user'] = nil }

  after_filter :clear_log

  CREATED_USER_KEY = :created_user
  
  # For Erubis compatible debug templates, when autoescaping
  # if Erubis::Helpers::RailsHelper.init_properties[:escape]
  #   define_method 'rescues_path' do |template_name|
  #     "#{view_paths.first}/rescues/#{template_name}.erb"
  #   end
  # end

  def self.my_rescue_urls
    @@rescue_urls ||= {}
    @@rescue_urls[self] ||= {}
  end

  #This is to add declaratively error handling actions in controllers, like this:
  #
  #  class SubmitController < ApplicationController
  #    ...
  #    rescue_urls :add_pvtmsg => :pvtmsg
  #
  # That tells to render :pvtmsg in case 'non-system' error (like AR
  # validation) happens in add_pvtmsg action; otherwise default handler will
  # be used (new_relic in our case). If we want system errors also be handled,
  # specify it in 'full' way:
  #
  #  rescue_urls :add_pvtmsg => {:url => {:action => :pvtmsg}, :handle_syserrors => true}
  #
  # If nothing is specified for action default handler is used.
  # You can have multiple declarations of rescue_urls in controller, e.g. one for action.
  # Options list:
  #   :url - what redirect_to can take
  #   :redirect - whether to redirect (default is true for :get, false for :post)
  #   :handle_syserrors - whether to handle 'system errors' (default is false)
  #   :flash - whether to show predefined flash error message (default is true for 'system' errors)
  #
  
#  rescue_from Kroogi::NotPermitted, { :with => :kroogi_not_permitted }
  
  def self.rescue_urls(options)
    my_rescue_urls.merge! options
  end

  def action_rescue_info
    self.class.my_rescue_urls[action_name.to_sym]
  end

  def rescue_response(options = {})
    options.reverse_merge! :flash => options[:syserror]
    rescue_info = action_rescue_info
    rescue_info = rescue_info.call(self) if rescue_info.is_a?(Proc)
    return unless rescue_info
    if !rescue_info.is_a?(Hash)
      if rescue_info.is_a?(Array)
        rescue_info = {:url => {:action => rescue_info[0]}, :before_rendering => rescue_info[1]}
      else
        rescue_info = {:url => {:action => rescue_info}}
      end
    end
    return if !rescue_info[:handle_syserrors] && options[:syserror]
    rescue_info.reverse_merge! :redirect => (request.request_method == :get)
    rescue_info.reverse_merge! :flash => options[:flash]
    rescue_info[:url].merge!(:controller => '/user') if self.class == ApplicationController
    msg = 'Sorry, this operation failed, please try again'.t
    if rescue_info[:redirect]
      flash[:error] = msg if rescue_info[:flash]
      redirect_to rescue_info[:url] || '/explore'
    else
      rescue_info[:before_rendering].call(self) if rescue_info[:before_rendering]
      flash.now[:error] = msg if rescue_info[:flash]
      render rescue_info[:url]
    end
    true
  end

  # Artem wrote all this, I just tweaks so it passes on to our exception_notification methods - kali. Not sure what exactly it's all for.
  def rescue_action(error)
    if error.is_a?(ActiveRecord::RecordInvalid)
      return if rescue_response(:syserror => false)
    end
    if error.is_a?(Kroogi::NotPermitted)
      if !logged_in?
        access_denied
        return
      end
    end
    logger.error("Error caught: #{error.inspect}")
    if ::ActionController::Base.consider_all_requests_local
      just_notify(error, :skip_40x => true)
      return super       
    end
    exception_notification__rescue_action_in_public(error)
    # return super if !rescue_response(:syserror => true)
  end

  def generate_ie6_flash_message
    if request.env['HTTP_USER_AGENT'] =~ /MSIE 6/
      flash[:error] = "Kroogi no longer supports Microsoft's Internet Explorer 6.".t + " " + "Please".t + " <a href='http://www.microsoft.com/windows/internet-explorer/default.aspx'>" + "upgrade".t + "</a> " + "or switch to".t + " <a href='http://www.getfirefox.com'> " + "Firefox".t + "</a>,  <a href='http://www.google.com/chrome'>" + "Chrome".t + "</a> " + "or another browser.".t + "</a>"
    end 
  end

  def set_locale
    log.debug "set_locale started"
    russian_domain = request.domain ? request.domain.split('.').last == 'ru' : nil
    default_locale = russian_domain ? 'ru' : 'en'

    # Ignore browser's http accept language if you're visiting the .ru version
    locale = params[:locale]
    locale = 'en' if params[:player_mode] == 'facebook_embedded'
    unless current_user.guest?
      locale ||= current_user.preference.current_locale
    end
    locale ||= session[:locale]

    request_language = request.env['HTTP_ACCEPT_LANGUAGE']
    request_language = request_language.nil? ? nil : request_language[/[^,;]+/]

    request_language = request_language[0..1] if request_language
    if Locale::AVAILABLE_LOCALES.include?(request_language)
      locale ||= request_language
    end

    #Set locale to 'ru' for russian bots (e.g. rambler) if their IP is ex-ussr
    #Yandex is unaffected here 'cause it sets ACCEPT_LANGUAGE to ru
    if !locale && IpToLocation.ip_from_ussr?(request.remote_ip)
      locale = 'ru'
    end

    locale ||= default_locale 
    locale = locale[0..1]
    session[:locale] = locale
    Locale.set locale
    if !current_user.guest? && current_user.preference.current_locale != locale
      current_user.preference.update_attribute(:current_locale, locale)
    end

    # fix the hostname to represent the reality 
    # todo - move it so its only done once somehow
    # APP_CONFIG[:hostname] = user_domain
  end
  
  def local_request?
    false
  end

  def request_comes_from_facebook?
    !params['fb_sig'].blank?
  end

  # Helper creates a user link url
  def user_url_for(user, *args)
    return if user.nil?
    unless args.empty?
      if args[0].is_a?(Hash)
        options = args[0]
      else
        action = args[0]
      end
    end
    options ||= {}
    action ||= (options[:action] || '')
    url_for(user_path_options(user, {:action => action}.merge(options)))
  end
  helper_method :user_url_for
  
  def set_model_user
    Thread.current['user'] = current_user
  end

  def load_user
    user_handle = params[:id] || user_subdomain

    if user_handle.blank? || user_handle == 'guest'
      if logged_in?
        redirect_to(home_url(current_actor))
      else
        redirect_to(explore_path) # keep it to /explore url to prevent bots from getting stuck in a loop
      end
      return false
    end

    #better than .to_i test which is too loose - turns 5gdfg into 5
    if (Integer(user_handle) rescue nil)
      @user = User.find_by_id(user_handle)
    else
      @user = User.find_by_login(user_handle)
    end

    na_handler = lambda do
      @user = nil
      flash[:warning] = "The requested user does not exist or is not available".t
      redirect_to explore_path
    end
    if @user.nil? || @user.kd_user?
      na_handler.call
    elsif @user.private? && !@user.allow_access_to_private_user?(current_user)
      # Unauthorized attempt to view private project
      vars = {
        :title => 'Under Construction'.t,
        :msg => 'Please try again later'.t
      }
      render(:file => "#{RAILS_ROOT}/app/views/errors/generic.rhtml", :locals => vars) and return
    elsif !(@user.is_view_permitted? || permitted?(current_actor, :moderate))
      na_handler.call
    end

    if @user && @user.blocked? # Only moderator should get here passed is_view_permitted above
      flash.now[:warning] = "This user is currently blocked from the system, and is only viewable by moderators.".t
    end
  end
  
  # Filter for requiring that the user has livejournal info on file.
  def require_lj
    if !logged_in? || current_user.lj_user.blank? || current_user.lj_password.blank?
      flash[:notice] = "You must provide your live journal information to continue"
      redirect_to :controller => 'live_journal_settings', :action => 'edit' and return false
    end
  end

  helper_method :getpagesize
  def getpagesize(default = 25, options = {})
    options.reverse_merge!(:max => 100, :session_key => :page_size)
    session_key = options[:session_key]
    page_size = params[:page_size]
    page_size ||= session[session_key]
    page_size = page_size.to_i
    page_size = nil if page_size == 0
    page_size ||= default
    page_size = options[:max] if options[:max] && page_size > options[:max] # Set a max to save the db
    page_size
  end
  
  helper_method :setpagesize
  def setpagesize(default = 25, options = {})
    options.reverse_merge!(:session_key => :page_size)
    session_key = options[:session_key]
    page_size = getpagesize(default, options)
    options[:local] ? (params[session_key] = page_size) : (session[session_key] = page_size)
  end
  
  def uri_escape(value)
    x = URI::PATTERN::UNRESERVED.clone
    x['.'] = '' if x['.'] #escape '.' too - Rails (or Mongrel maybe) doesn't like it
    r = Regexp.new("[^#{x}]")
    URI.escape(value, r)
  end

  def uri_unescape(value)
    URI.decode(value)
  end

  def cache_key_with_locale(*params)
    result = ([
      Kroogi.translation_mtime.stamp,
      I18n.language_code,
      self.class.name[0..-11].downcase,
      action_name,
      instance_variable_get(:@user).try(:login),
    ] + params).map{|p| escape_cache_key(p)}.join("/")
    result = maybe_shorten_cache_key(result)
    result
  end

  def cache_key_with_locale_by_request_params
    p = params.reject {|key, value| ['controller', 'action', 'format'].include?(key)}
    cache_key_with_locale(*hash_to_cache_key_array(p))
  end

  def profile_page_url(user)
    url_for(:host => user_host(user), :controller => '/')
  end
  helper_method :profile_page_url

  protected
  
  include ControllerSharedHelper
  
  # Redirect to invoice agreement if logged in (filter)
  def require_invoice_agreement
    unless current_user.is_a?(Guest)
      if current_actor.account_setting.invoice_agreement_required?
        session[:pre_agreement_url] = request.url
        redirect_to '/account_settings/invoice_agreement' and return false
      else
        session[:pre_agreement_url] = nil
        return true 
      end
    end
  end

    
  exception_data :additional_data

  def additional_data
    { :current_actor => current_actor.login,
      :current_user => current_user.login,
    }
  end
  
  def ensure_valid_user
    return true if current_user.is_a?(Guest) || current_user.nil? || current_actor.nil? || (current_user.active? && current_actor.active?)
    self.current_user = session[:user] = nil
    flash[:warning] = "User account is no longer valid"
    redirect_to login_url
    return false
  end
  
  # used for action cache
  def use_cache?
    !logged_in? && flash.empty?
  end
  
  alias :use_cache :use_cache?
  
  # renders an action as a string and caches it.
  def render_cached(action_params, expiration, render_options)
    return unless perform_caching
    if use_cache?
      combined_key = cache_key_with_locale(*action_params)

      output = Rails.cache.fetch(combined_key, :expires_in => (expiration || 6.hours)) do
        render_to_string(render_options)
      end
      render :text => output
    else
      render render_options
    end
  end

  def default_url_options(options = {})
    {:host => user_domain}.merge(options)
  end
  
  # Perhaps could be put in model, but for now it's here so kroogi controller and project controller can share same logic
  def do_save_kroogi_settings
    # Update the settings for each of this user's circles
    static_default = render_to_string(:partial => '/kroogi/noaccess')
    (params[:user_kroog] || []).each do |kid, attribs|
      if k = @user.kroogi_settings.find_by_id(kid)

        # Set circle join options
        if joinopt = attribs.delete(:join_limit)
          if joinopt == 'anyone'
            k.open = true
            k.can_request_invite = true
          elsif joinopt == 'none'
            k.open = false
            k.can_request_invite = false
          else
            k.open = false
            k.can_request_invite = true
          end
        end

        # Set teaser (remove if equals default)
        teaser = params[:teasers].delete(kid)
        # if k.teaser_db_store && teaser && teaser.blank? then k.teaser_db_store.destroy
        # elsif teaser.gsub(/\s/,'') != static_default.gsub(/\s/,'') # Different line end encodings coming from form
        #   k.teaser = teaser
        # end
        
        if teaser
          if teaser.is_a?(String)
            k.teaser = teaser
          else
            k.attributes = teaser.first
          end
        end
         
         
         
        if k.relationshiptype_id == Relationshiptype.interested
          # Interested circle can only edit circle name and teaser
          k._name = (attribs[:name] || attribs[:_name]) if (attribs[:name] || attribs[:_name])
          k.name_ru = attribs[:name_ru] if attribs[:name_ru]
          k.save
        else
          # Have to save currencies and other attribs separately. No idea why...
          avail_currencies = [] #['amount_usd'] + (@user.account_setting.available_accounts - ["paypal_email", "webmoney_wmz"])
          money_attribs = {}; other_attribs = {}

          # Separate out money attributes and others
          attribs.each do |key,val|
            if avail_currencies.include?(key.to_s)
              money_attribs[key.to_sym] = val
            else
              other_attribs[key.to_sym] = val
            end
          end

          # Save everything else for this circle
          k.attributes = other_attribs
          k.save
           
          # OK, NOW save the currencies (must be last, apparently)
          if other_attribs[:is_paid] && other_attribs[:is_paid] != "false"
            money_attribs.each do |currency, value|
              next if value.blank?
              k.send("#{currency}=", value)
            end
            k.donation_setting.save  # Yes, we have to save it directly. blah.
          else
            k.clear_amounts
          end
        end
      end
    end

    # Figure out show/hide circles for this user
    if params[:use]
      circles_to_hide = params[:use].collect{|x,y| y == 'false' ? x.to_i : nil}
      circles_to_hide = circles_to_hide - [Relationshiptype.interested ] # Don't allow removing interested circle
      @user.preference.update_attribute(:active_circle_ids, @user.all_circle_ids - circles_to_hide)
    end

    # Money stuff
    @user.account_setting.update_attributes(params[:account_setting]) if params[:account_setting]
    @user.save!
  end

  include StringUtilsMixin
  def set_paging_header(result, options = {})
    entity_name = options[:entity_name]
    pluralized_entity_name = pluralize_without_count(2, entity_name)
    options.reverse_merge! :many_pages_case => 
      pluralized_entity_name.capitalize + " %1$d - %2$d of %3$d",
      :no_results_case => 'No ' + pluralized_entity_name
    total_entries = result.total_entries
    page_from = result.offset + 1
    page_to = result.offset + result.size
    if (total_entries > 0)
      if result.size < total_entries
        @paging_header = options[:many_pages_case].t % [page_from, page_to, total_entries]
      else
        entity_name = pluralize_without_count(result.size, entity_name)
        @paging_header = "%d #{entity_name.t} found"
        @paging_header = @paging_header / [result.size]
      end
    else
      @paging_header = options[:no_results_case].t
    end    
  end

  helper_method :can_view_donations_for?
  def can_view_donations_for?(user_or_project)
    result = (user_or_project == current_user || current_user.admin?)

    if user_or_project.is_a?(Project)
      result ||= user_or_project.project_founders_include?(current_user)
    end
    result
  end

  helper_method :can_view_content_stats?
  def can_view_content_stats?(content)
    current_user.admin? || current_user.is_self_or_owner?(content.user)
  end


  helper_method :user_path_options

  alias :userpage_path :user_path_options
  helper_method :userpage_path

  #need to take it here from routes.rb because of dynamic :host
  def explore_url
    url_for(explore_path)
  end
  def explore_path
    {:host => user_domain, :controller => '/explore', :locale => I18n.locale}
  end
  helper_method :explore_url, :explore_path

  # in_place_editor helper
  def render_unformatted_field(object, field)
    params[:lang] = 'en' unless params[:lang] && %w(en ru).include?(params[:lang])
    render :text => params[:lang] == 'en' ? object.send(field) : object.send("#{field}_#{params[:lang]}")
  end

  helper_method :content_downloaded_cookie
  def content_downloaded_cookie(content)
    "dl_%s" % content.id
  end

  #adopted from ActionController::Helpers#all_application_helpers 
  #examples: application_helpers(:root); application_helpers(:facebook); application_helpers(:admin)
  def self.application_helpers(path)
    path = '' if path == :root
    path = path.to_s if path.is_a?(Symbol)
    extract = /^#{Regexp.quote(HELPERS_DIR)}\/?(.*)_helper.rb$/
    Dir["#{HELPERS_DIR}/#{path}/*_helper.rb"].map { |file| file.sub extract, '\1' }
  end

  helper(application_helpers(:root)) # include all top-level helpers, all the time
  helper InPlaceMacrosHelper

  def clear_log
    log.flush
  end

  def cookie_domain
    result = user_domain(:port => false)
    result
  end

  def satellite_request?
    return true if self.is_a?(UserController) && params["action"] == "following"
    false
  end

  def other_domain
    (user_domain == APP_CONFIG.hostname) ? APP_CONFIG.ru_host : APP_CONFIG.hostname
  end

  def set_session_path(target)
    (target = 'http://' + user_domain(:port => true) + target) if target.starts_with?('/') 
    {:host => other_domain, :controller => '/home', :action => 'set_session', :sid => current_user.sid, :target => target}
  end

  def finalize_successfull_logon(options = {})
    options.reverse_merge!(:msg => "Logged in successfully".t)
    flash[:success] = options[:msg]
    return options[:target] if options[:find_target_only]
    redirect_to options[:target]
  end

  def check_if_should_be_logged_out
    unless current_user.guest?
      #sid == nil means user have logged out at another domain  
      unless self.current_user.sid
        log.debug "logging man out"
        self.current_user = Guest.new
        reset_session
        delete_rememberme_token
      end
    end
  end

  helper_method :search_results_url
  def search_results_url(query, type)
    search_with_type_path(:host => user_domain, :type => type, :q => query)
  end

  def reject_invalid_formats
    redirect_to explore_path if !params[:format].blank? && !%w(html js json xml csv).include?(params[:format])
  end

  helper_method :download_signature
  def download_signature(bundle_id, expires)
    User.encrypt("#{bundle_id}/#{expires}", "I'm Muzzy. I like clocks.")
  end

  helper_method :favorite_title
  def favorite_title(subject)
    subject.is_a?(User) ? subject.login : subject.title
  end

  def check_undeletability(content = @content)
    if content && (msg = content.undeletable?)
      flash[:error] = msg
      redirect_to content_url(content)
      return false
    end
    true
  end

  helper_method :created_user
  def created_user
    session[CREATED_USER_KEY]
  end

  helper_method :friend_feed_url
  def friend_feed_url(user, options = {})
    user_url_for(user, options.merge(:action => 'new', :controller => 'activity'))
  end

  helper_method :home_url
  def home_url(user)
    if user.is_a?(Project)
      user_url_for(user)
    else
      friend_feed_url(current_actor)
    end
  end

  helper_method :weekly_top_section_key
  def weekly_top_section_key(lang = I18n.locale, domain = user_domain)
    "#{domain}/helloworld/#{Kroogi.translation_mtime.stamp}/weekly_top_#{lang}"
  end

  def load_projects
    @projects_info = current_user.projects(:sorted => true).unshift(current_user)
  end

  def prepare_to_send_download_link_with_invite(invite, download_content_id, options)
    return if download_content_id.blank?
    content = Content.find_by_id(download_content_id)
    return if !content.downloadable?
    if options.has_key?(:send_link)
      invite.put_link_to_download(download_content_id) if options[:send_link]
    else
      #flashes are too fragile in multi-windowed browsers - let's use session
      session[:dl_link_on_donation] = [invite.id, download_content_id]
    end 
  end
  
  def current_user_wanna_join(project_id_to_follow, follower_email, download_content_id, options = {})
    joiner_user = logged_in? ? current_actor : nil
    joiner_user ||= User.undeleted.find_by_email(follower_email) if follower_email
    project_to_follow = User.find_by_id(project_id_to_follow)
    if joiner_user && project_to_follow && ((joiner_user == project_to_follow) || joiner_user.is_a_follower_of?(project_to_follow))
      return
    end
    return unless project_to_follow
    if follower_email && (invite = Invite.find_by_inviter_id_and_user_email(project_to_follow.id, follower_email))
      prepare_to_send_download_link_with_invite(invite, download_content_id, options) if !joiner_user
      return
    end

    invite = Invite.new(:inviter_id => project_to_follow.id, :circle_id => Relationshiptype::TYPES[:interested], :initiated_by_invited => true)
    if joiner_user
      invite.user_id = joiner_user.id
    else
      invite.user_email = follower_email
      invite.email_required = true
    end
    if logged_in?
      Relationship.make_user_follow_project(:follower => invite.user, :followed => invite.inviter)
    else
      invite.save # we don't care if it fail
      unless invite.new?
        prepare_to_send_download_link_with_invite(invite, download_content_id, options) if !joiner_user
      end
    end
    return invite
  end

  helper_method :yandex_config
  def yandex_config(params = nil)
    params = self.params unless params
    DonationProcessors::Yandex.config(params)
  end

  helper_method :params_without_paging
  def params_without_paging(options = {})
    keys = [:page]
    keys << :page_size unless options[:keep_size]
    exclude = options[:exclude] || []
    exclude = [exclude] unless exclude.is_a?(Array)
    keys += exclude
    result = params_without(*keys)
    if options[:keep_size].is_a?(Numeric)
      result.merge!(:page_size => options[:keep_size])
    end
    result.symbolize_keys
  end

  helper_method :params_without
  def params_without(*keys)
    new_params = params.dup.with_indifferent_access
    keys = [keys] unless keys.is_a?(Array)
    keys.each {|key| new_params.delete(key)}
    new_params
  end

  helper_method :sign_with_session_secret
  def sign_with_session_secret(value)
    #session.dbman.generate_digest(value.to_s)
    result = Digest::MD5.hexdigest(value.to_s + ActionController::Base.session_options_for(nil,nil)[:secret])
    log.debug "sign_with_session_secret = #{result}"
    result
  end
  
  def dump_response
    return if RAILS_ENV=='production'
    log.debug "response body: #{response.body}"
  end

  helper_method :smscoin_params_filters
  def smscoin_params_filters
    @content ? {:min_gross_usd => @content.min_contribution_amount} : {}
  end

  helper_method :smscoin_element_selector
  def smscoin_element_selector
    "#contribution_accordion_#{params[:dialog_id_suffix]} .contribution_option_body.smscoin"
  end

  helper_method :payment_description
  def payment_description(recipient, content)
    d = if content
      "Contribute to {{project_name}}'s {{content_title}}" / [truncate(content.user.display_name, :length => 40),
                                                              truncate(content.title, :length => 40)]
    else
      "Contribute to {{project_name}}" / truncate(recipient.display_name, :length => 80)
    end
  end

  helper_method :show_fb_connect?
  def show_fb_connect?
    SiteActivityLoggerForControllers::Parser::UserAgent.browser_info(request.user_agent)[:type] != 'Opera' or RAILS_ENV == 'staging'
  end
  
  def before_donation_form_submit(params, amount_param_value, errors)
    if params[:content_type] == Tps::GoodieTicket.name
      ticket = Tps::GoodieTicket.find(params[:content_id])
      amount_param_value = amount_param_value.to_f
      if amount_param_value < ticket.goodie.price
        errors << ('The goodie price is {{amount}}$. Please pay that amount.' / ticket.goodie.price)
      elsif ticket.goodie.all_gone?
        errors << ("Sorry, this goodie isn't available anymore" / ticket.goodie.price)
      elsif ticket.succeeded?
        errors << "You already paid for this goodie. Please refresh the page if you want to buy more.".t        
      end
      ticket.activate! if errors.blank? && !ticket.active? 
    end
  end

  #sorter for array of [name, email] pairs
  def sort_contacts(contacts)
    contacts.uniq.sort do |x, y|
      a = [x, y].flatten.map {|s| s.downcase}
      if a[0].blank? && !a[2].blank?
        1
      elsif !a[0].blank? && a[2].blank?
        -1
      else
        [a[0], a[1]] <=> [a[2], a[3]]
      end
    end
  end
  helper_method :sort_contacts

  def sort_users_by_emails(users)
    users.uniq.sort do |x, y|
      a = [x.email, y.email].flatten.map(&:downcase)
      if a[0].blank? && !a[2].blank?
        1
      elsif !a[0].blank? && a[2].blank?
        -1
      else
        [a[0], a[1]] <=> [a[2], a[3]]
      end
    end
  end

  def choose_system_message
    return unless logged_in?
    return if request.xhr?
    @system_message_trigger = SystemMessages::ShowTrigger.choose_trigger(current_user, self)
    @system_message = @system_message_trigger.system_message if @system_message_trigger

    #postpone facebook sm if this opera
    if @system_message && @system_message.is_a?(SystemMessages::ConnectFbAccount) && !show_fb_connect?
      @system_message_trigger.create_postponed_response
      @system_message_trigger.postpone
      @system_message = nil
    end
  end

  def choose_admin_flash
    @admin_flashmsg = AdminFlash.random_message
  end

  def boolean_param_value(value)
    value ? 'true' : 'false'
  end
  helper_method :boolean_param_value

  def same_page_in_locale(locale)
    if self.is_a?(ContentController) && action_name == 'show'
      return I18n.with_locale(locale) {content_url(@entry)}
    end
    url_for(:subdomain => current_subdomain, :overwrite_params => {:locale => locale})
  end
  helper_method :same_page_in_locale

  def force_locale_in_url
    unless params[:locale]
      redirect_to(same_page_in_locale(I18n.locale), :status => :moved_permanently)
    end
  end

  def russian_speaking_user?
    I18n.locale == 'ru' or IpToLocation.ip_from_ussr?(request.remote_ip)
  end
  helper_method :russian_speaking_user?

  def login_url
    "http://#{APP_CONFIG.hostname}/login"
  end
  helper_method :login_url

end
