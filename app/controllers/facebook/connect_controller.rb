class Facebook::ConnectController < Facebook::ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :ensure_authenticated_to_facebook
  skip_before_filter :maybe_load_fb_user_data, :only => [:reset_user_info]

  def fetch_user_info
    unless params[:partial] 
      render :nothing => true and return
    end
    if params[:facebook_user]
      @user = BasicUser.new(:is_artist => false, :artist_kind => 'project')
      @user.language = I18n.locale
      @user.build_preference
    end
    partial = params[:partial]
    render :partial => partial,
           :locals => {:dialog_id_suffix => params[:dialog_id_suffix],
                       :fb_connect_user => current_fb_connected_user,
                       :project_to_follow => params[:project_to_follow],
                       :content_to_like => params[:content_to_like],
                       :start_following => params[:start_following],
                       :restore_submit_button_state => true}
  end

  def reset_user_info
    render :partial => '/shared/facebook/connect/fb_connect_init_form',
           :locals => {:dialog_id_suffix => params[:dialog_id_suffix],
                       :fb_connect_user => nil,
                       :restore_submit_button_state => true,
                       :reset_form => true}
  end

  def activate
    if current_user.preference
      current_user.connect_fb_account(current_fb_connected_user.id, current_fb_session_key)
      @preference = current_user.preference
      @preference.fb_like_consolidation ||= "ask_me"
      render(:partial => "/facebook/connect/connect_block.html.erb", :locals => {:user => current_user})
    else
      redirect_to '/'
    end
  end

  def deactivate
    current_user.fb_details.delete if current_user.fb_details
    redirect_to "/preference/facebook_settings"
  end
end
