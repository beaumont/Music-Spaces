class ApiController < ApplicationController
  # Handles app-specific backend stuff that we can't really put anywhere else
  
  require 'digest/sha1'
  
  skip_before_filter :choose_system_message

  def reload_translation_cache
    # Require random string to ensure valid request. Digested to prevent long-term session replay... not so necessary here, but general feature for all API controller actions
    render(:nothing => true) and return unless params[:id] == Digest::SHA1.hexdigest("XZAVL3hzexCRTUwSRZ--Date--#{Time.now.utc.to_date.to_s}")
    I18n.backend.instance_eval {load_globalize_translations(:clean_existing => true)}    
    render(:text => 'OK')
  end


  def user_has_fb_account
    dont = true unless logged_in?
    dont = true if !dont && !current_user.show_find_fb_friends_sm?
    dont = true if !dont && !SystemMessages::ShowTrigger.for_user(current_user).for_system_message_type(SystemMessages::ConnectFbAccount).blank?
    SystemMessages::ShowTrigger.maybe_create_for(current_user, SystemMessages::ConnectFbAccount) unless dont
    render :text => 'ok'
  end
end
