class WizardController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :add_content
  
  before_filter :login_required
  before_filter :load_owner

  verify :method => :post, :only => [:join_project, :join_all_children], :redirect_to => { :controller => '/'}

  filter_parameter_logging "google_password", "yahoo_password", "hotmail_password"

  # User wizard - post activation
  def add_avatar
    @user.profile ||= Profile.new
  end

  def add_picture
    @user.profile ||= Profile.new
  end

  def basic_info_project
    @profile = @user.profile
    if request.post?
      
      if save_user(@profile.user)
        @profile.attributes = params[:profile]
        if @profile.save!
          redirect_to :action => params[:next_step], :id => @user.id
        end
      end

    end
  end
  
  def basic_info
    @profile = current_user.profile
    if request.post?

      if save_user(@profile.user)
        @profile.attributes = params[:profile]
        if @profile.save!
          next_action = current_actor.project? ? 'agreement' : 'add_content'
          redirect_to :action => next_action, :id => @user.id
        end
      end
      
    end

    project_profile = @user.profile

    country = @profile.question_object(:country, true)
    if country.new_record?
      country.answer = project_profile.question_object(:country, true).answer_without_tags
      country.save
    end

    city = @profile.question_object(:city, true)
    if city.new_record?
      city.answer = project_profile.question_object(:city, true).answer_without_tags
      city.save
    end
  end

  # Paypal postback
  def add_content
    flash.now[:warning] = "Thank you!  Add content and start receiving contributions!".t if params[:payment_status] == "Completed"
  end

  def agreement
    @account_setting = @user.account_setting
    @account_setting.active_user = @user
  end

  def attach_money
  end

  def for_basic_user
    flash[:show_wizard] = true
    redirect_to friend_feed_url(current_actor)
  end

  def join_project
    @subdir_id = params[:project_id]
    render :text => '' and return unless @subdir_id
    if params[:follow]
      WhatYouLike.make_user_like_project(:follower => current_actor, :followed => @subdir_id)
    else
      WhatYouLike.break_user_like_project(:follower => current_actor, :followed => @subdir_id)
    end
  end

  def join_all_children
    @dir_id = params[:dir_id]
    render :text => '' and return unless @dir_id
    children = CollectionInclusion.children_of(@dir_id).direct.map(&:child_user_id)
    children.each do |subdir_id|
      if params[:follow]
        WhatYouLike.make_user_like_project(:follower => current_actor, :followed => subdir_id)
      else
        WhatYouLike.break_user_like_project(:follower => current_actor, :followed => subdir_id)
      end
    end
  end

  def set_about_user
    user = current_user
    user.display_name = params[:user][:display_name]
    user.save!
    profile = current_user.profile
    profile.tagline = params[:profile][:tagline]
    unless params[:image_file].blank?
      begin
        avatar = Image.create(:cat_id => 3, :uploaded_data => params[:image_file], :user_id => user.id)
      rescue ActiveRecord::RecordInvalid
        #invalid avatar == no avatar here
        avatar = nil
      end
      if avatar
        user.profile.avatars.each {|a| a.destroy unless a == avatar}
        profile.avatar = avatar        
      end
    end
    profile.save!

    if show_fb_connect?
      flash[:show_add_fb_friends_widget] = true
    else 
      flash[:show_add_friends_widget] = true
    end
    redirect_to friend_feed_url(current_actor)
  end

  def get_users_to_follow
    raise Kroogi::NotPermitted unless logged_in?
    user = current_actor

    google = (params['google_username'] || '').chars.downcase.gsub(/[<>|:]+| +$|^ +/, '')
    yahoo = (params['yahoo_id'] || '').chars.downcase.gsub(/[<>|:]+| +$|^ +/, '')
    hotmail = (params['hotmail_username'] || '').chars.downcase.gsub(/[<>|:]+| +$|^ +/, '')

    [google, yahoo, hotmail].each {|e| e.gsub!(e, "") if ContactsImport::EMAIL_SAMPLES.map(&:last).include?(e)}

    google_password = params['google_password'] || ''
    yahoo_password = params['yahoo_password'] || ''
    hotmail_password = params['hotmail_password'] || ''

    if [google, yahoo, hotmail].all?(&:blank?)
      flash[:show_what_you_like_widget] = true
      redirect_to safe_redirect(params[:return_to]) and return
    end

    kroogi_users_mails = []
    begin
      kroogi_users_mails += get_contacts_for_email(user, google, google_password)
      kroogi_users_mails += get_contacts_for_email(user, yahoo, yahoo_password)
      kroogi_users_mails += get_contacts_for_email(user, hotmail, hotmail_password)

      followed_users = user.followed_projects(:limit => nil).select {|f| kroogi_users_mails.find {|name, email_id, email| equal_emails?(email, f.email)}}
      already_followed = Set.new(followed_users.map(&:email).map(&:downcase))

      kroogi_users = User.active.all :conditions => {:email => kroogi_users_mails.map(&:last).uniq, :type => ["BasicUser", "AdvancedUser"]}

      flash_data = {:suggest_following => sort_users_by_emails(kroogi_users), :already_followed => already_followed, :kroogi_users_mails => kroogi_users_mails}
    rescue ContactsImportError => e
      bas_errmsg = e.message
    rescue Exception => e
      errored = true
      raise e
    ensure
      if bas_errmsg
        flash_data = {:bas_errmsg => bas_errmsg,
          :form_data => {:google_username => google, :hotmail_username => hotmail, :yahoo_id => yahoo}}
        user.set_flash(:add_friends_widget_search_results, flash_data)

        flash[:show_add_friends_widget] = true
        redirect_to safe_redirect(params[:return_to]) and return
      else
        user.set_flash(:add_friends_widget_search_results, flash_data)
        flash[:show_select_kroogi_users_to_follow_widget] = true
        redirect_to safe_redirect(params[:return_to]) and return
      end unless errored
    end
  end

  def tell_about_yourself
    render :update do |page|
      page.replace_html "tell_about_yourself_overlay", :partial => "/wizard/tell_about_yourself_widget", :locals => {:back => false, :user => current_actor}
    end
  rescue => e
    render_error e, "tell_about_yourself_overlay"
  end

  def add_friends
    render :update do |page|
      page.replace_html "add_friends_overlay", :partial => "/wizard/add_friends_wizard",
        :locals => current_actor.get_and_delete_flash(:add_friends_widget_search_results)
    end
  rescue => e
    render_error e, "add_friends_overlay"
  end

  def add_fb_friends
    respond_to do |wants|
      wants.js { 
        render :update do |page|
          page.replace_html "add_fb_friends_overlay", :partial => "/wizard/add_fb_friends_wizard"
        end
      }
      wants.html {
        flash[:show_add_fb_friends_widget] = true
        redirect_to friend_feed_url(current_user)
      }
    end
  rescue => e
    render_error e, "add_fb_friends_overlay"
  end

  def get_fb_friends
    unless current_user.facebook_connected?
      current_user.connect_fb_account(current_fb_connected_user.id, current_fb_session_key)
    end
    render(:partial => "/wizard/founded_fb_friends", :locals => {:friends => current_user.find_kroogi_users_matched_fb_friends})
  end

  def follow_fb_friends
    current_user.follow_users_found_with_fb(params[:follow])

    respond_to do |wants|
      wants.html {
        flash[:show_add_friends_widget] = true
        redirect_to friend_feed_url(current_user)
      }
    end
  end

  def select_kroogi_users_to_follow
    render :update do |page|
      page.replace_html "select_kroogi_users_to_follow_overlay", :partial => "/wizard/select_kroogi_users_to_follow",
        :locals => current_actor.get_and_delete_flash(:add_friends_widget_search_results) ||
                   {:suggest_following => [], :already_followed => [], :kroogi_users_mails => []}
    end
  rescue => e
    render_error e, "select_kroogi_users_to_follow_overlay"
  end

  def what_you_like
    render :update do |page|
      page.replace_html "what_you_like_overlay", :partial => "/wizard/what_you_like_widget", :locals => {:user => current_actor}
    end
  rescue => e
    render_error e, "what_you_like_overlay"
  end

  def follow_users
    follow = params[:follow] || []

    users = User.active.users_first.all :conditions => {:id => follow}
    users.map {|user| Relationship.make_user_follow_project(:follower => current_actor, :followed => user)}

    render :update do |page|
      page.replace_html "what_you_like_overlay", :partial => "/wizard/what_you_like_widget", :locals => {:user => current_actor}
      page << dialog_js("what_you_like_overlay", {:width => '500px', :position => "['center', 10]"})
      page.call "jQuery('#what_you_like_overlay').dialog", "open"
      page.call "jQuery('#select_kroogi_users_to_follow_overlay').dialog", "close"
      page.call "jQuery('#add_friends_overlay').dialog", "close"
    end
  rescue => e
    render_error e, "select_kroogi_users_to_follow_overlay"
  end

  private

  def load_owner
    params[:id] = current_actor.id if params[:id].nil?
    @user = (params[:id].to_i == current_actor.id ? current_actor : User.find_by_id(params[:id]))
    raise Kroogi::NotPermitted unless @user && @user.active?
    raise Kroogi::NotPermitted unless permitted?(@user, :content_edit)
  end

  def save_user(user)
    if params[:user]
      params[:user][:display_name] = user.login if (params[:user][:display_name].blank? and params[:user][:_display_name].blank?)
      user.update_attributes(params[:user])
    end
  end

  def get_contacts_for_email(user, email, password)
    return [] if email.blank? || ContactsImport::EMAIL_SAMPLES.map(&:last).include?(email)

    unless email.email?
      raise ContactsImportError.new('Please make sure you entered your email address {{email}} correctly.' / ["(#{email})"])
    end

    unless (email.empty? && password.empty?)
      imported_mails, mail_creds = import_contacts(email, password)
      log.debug "imported_mails: #{imported_mails.inspect}, mail_creds: #{mail_creds.inspect}"
      imported_mails ||= []
      kroogi_users_mails, external_mails = categorize_user_contacts(imported_mails, user, mail_creds[1])
    end
    kroogi_users_mails ||= []

    kroogi_users_mails.reject! {|n, e| equal_emails?(e, user.email) || equal_emails?(e, email)}

    kroogi_users_mails.map {|name, email| [name, mail_creds[1].titleize, email]}
  end

  def render_error(error, id)
    AdminNotifier.async_deliver_admin_alert error
    render :update do |page|
      page.replace_html id, something_broke
    end
  end

  include ContactsImport

end