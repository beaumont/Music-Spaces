# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class Facebook::ApplicationController < ApplicationController
  helper(application_helpers(:facebook))

  before_filter :set_current_fb_user, :manage_next_url, :set_default_format
  skip_before_filter :run_basic_auth

  attr_reader :current_fb_user
  helper_method :current_fb_user, :viewer_is_a_page?, :viewer_is_page_admin?, :viewer_is_profile_owner?,
                :viewer_inteface_language

  protect_from_forgery
  layout 'facebook/canvas.fbml.erb'

  ensure_authenticated_to_facebook
  filter_parameter_logging :fb_sig_friends #To prevent a violation of FB TOS while reducing log bloat.

  protected

  def set_current_fb_user
    set_facebook_session
    # if the session isn't secured, we don't have a good user id
    if facebook_session and facebook_session.secured? and !request_is_facebook_tab?
      @current_fb_user = Facebook::User.find_or_create(facebook_session.user.to_i,facebook_session, {:is_kd_user => 1}) do |existing|
        existing.update_attribute(:state, 'active')
        existing.details
      end
    end
  rescue Facebooker::Session::MissingOrInvalidParameter
  end

  def viewer_is_a_page?
    !params[:fb_sig_is_admin].blank?
  end

  def viewer_is_page_admin?
    params[:fb_sig_is_admin] == "1" if viewer_is_a_page?
  end

  def viewer_is_profile_owner?
    if viewer_is_a_page?
      false
    else
      params[:fb_sig_user] == params[:fb_sig_profile]
    end
  end

  def viewer_inteface_language
    #"fb_sig_locale"=>"en_US", "fb_sig_locale"=>"en_GB", "fb_sig_locale"=>"ru_RU"
    params[:fb_sig_locale] ? params[:fb_sig_locale][0..1].upcase : 'EN'
  end

  def feed_template_id
    FACEBOOK_CONFIG[:download_feed_id]
  end

  def manage_next_url
    redirect_to params[:next_url] if params[:next_url]
    return
  end

  # Add our own next url parameter to Facebook authorize process.
  def after_facebook_login_url
    "?next_url=http://apps.facebook.com#{Facebooker.facebook_path_prefix}#{request.request_uri.sub(/\/facebook/,"")}"
  end

  def referral_url(user, opts = {})
    type  = opts.delete(:referral_type)
    app_id = params[:fb_sig_app_id]

    case type
    when 'profile', 'invite'  then "http://www.facebook.com/profile.php?ref=profile&id=#{user.facebook_id}"
    when 'tab'     then "http://www.facebook.com/profile.php?v=app_#{app_id}&ref=profile&id=#{user.facebook_id}"
    end
  end

  helper_method :user_path_options
  def user_path_options(login, options = {})
    login = login.login if login.is_a?(User)

    host = user_host(login.downcase)
    {:host => host, :only_path => false, :controller => '/', :canvas => false}
  end

  def render_404
    respond_to do |type|
      type.all  { render :file => "#{RAILS_ROOT}/public/facebook/404.html"}
    end
  end

  def render_403
    respond_to do |type|
      type.all  { render :file => "#{RAILS_ROOT}/public/facebook/403.html"}
    end
  end

  def render_500
    respond_to do |type|
      type.all  { render :file => "#{RAILS_ROOT}/public/facebook/500.html"}
    end
  end
  
  def set_default_format
    params[:format] ||= 'fbml'
  end

end
