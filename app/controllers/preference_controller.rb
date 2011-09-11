class PreferenceController < ApplicationController
  before_filter :login_required
  before_filter :load_owner
  before_filter :load_ivars
  before_filter :load_projects, :only => [:show, :project_display, :account,
        :account_update, :emails, :project_emails, :facebook_settings, :kroogi, :project_kroogi, :blocked_users]

  verify :method => :post, :only => [:account_update]

  def show
    @projects_info = current_user.projects(:sorted => true).unshift(current_user)
  end
  
  def project_display
    if @user.projects.empty?
      flash[:warning] = 'Try creating or joining a project first'.t
      redirect_to :action => 'show', :id => @user
    end
    if request.post?
      # Save the privacylevel for the relationship -- 0 == not private, show. 1 == private, hide on your kroogi page. 
      # Hope that wasn't being used elsewhere...
      @user.projects.each do |p|
        rel = Relationship.locate_me(@user, p, Relationshiptype.founders)
        next unless rel
        if params[:show] && params[:show].include?(p.id.to_s)
          rel.update_attribute(:privacylevel, 0) unless rel.privacylevel.zero?
        else
          rel.update_attribute(:privacylevel, 1) if rel.privacylevel.zero?
        end
      end
      flash[:success] = 'Your changes have been saved'.t
      if params[:is_from_setting_center]
        redirect_to :controller => 'preference', :action => 'show', :id => @user.id and return
      else
        redirect_to userpage_path(@user)
      end
    end
  end
  
  def account_update
    if params[:user]
        @profile.user.validate_password(current_user, params[:password])
        unless @profile.user.update_attributes(params[:user])
            flash[:warning] = @profile.user.errors.full_messages.join("<br />")
            @profile.user.clear_passwords
            return render(:action => 'account')
        end
        @profile.user.clear_passwords
    end
    
    if @preference.update_attributes(params[:preference])
      flash[:success] = 'Settings were successfully updated.'.t
      redirect_to :action => 'show'
    else
      render :action => 'account'
    end
  end
  
  def emails
    if @user.is_a?(Project)
      redirect_to(:action => 'project_emails', :id => @user) and return
    end
  end
  
  def project_emails
    unless @user.is_a?(Project)
      redirect_to(:action => 'emails', :id => @user) and return
    end
  end

  def emails_update
    if @preference.update_attributes(params[:preference]) && (params[:receive_for].blank? || @preference.receive_emails_for!(params[:receive_for]))
      flash[:success] = 'Settings were successfully updated.'.t
    else
      flash[:warning] = 'Error saving changes.'.t
    end
    if params[:is_from_setting_center]
      redirect_to :controller => 'preference', :action => 'show', :id => @preference.user and return
    else
      redirect_to(:action => 'emails', :id => @preference.user)
    end
  end

  def kroogi
    if @user.is_a?(Project)
      redirect_to(:action => 'project_kroogi', :id => @user) and return
    end
  end

  def project_kroogi
    unless @user.is_a?(Project)
      redirect_to(:action => 'kroogi', :id => @user) and return
    end
  end

  def kroogi_update
    if @preference.update_attributes(params[:preference]) && (params[:receive_for].blank? || @preference.receive_kroogi_notifications_for!(params[:receive_for]))
      flash[:success] = 'Settings were successfully updated.'.t
    else
      flash[:warning] = 'Error saving changes.'.t
    end
    if params[:is_from_setting_center]
      redirect_to :controller => 'preference', :action => 'show', :id => @preference.user and return
    else
      redirect_to(:action => 'kroogi', :id => @preference.user)
    end
  end

  def facebook_settings
    @user = current_user
    @title = @user.login + ' :: ' + 'Edit Your Facebook Settings'.t
    @content_kind_displayname = 'Edit Your Facebook Settings'.t
    @preference = @user.preference
    @preference.fb_like_consolidation ||= "ask_me"
    @preference.is_reconnect_with_fb_friends ||= true
  end

  def update_fb_settings
    current_user.preference.update_attributes(params[:preference])
    redirect_to '/preference/facebook_settings'
  end

  def blocked_users
    @title = @user.login + ' :: ' + 'Blocked Users'.t
    @content_kind_displayname = 'Blocked Users'.t
    @blocked_pvt_users = current_actor.blocked_users.by_pvt.all :include => :blocked_user, :order => "users.login"
  end

  def block_users
    logins = params[:users_to_block].to_s.split(',').map(&:strip).select {|login| !login.blank? }
    unless logins.blank?
      type = BlockedUser::BLOCKED_TYPES.values.include?(params[:blocked_type]) ? params[:blocked_type] : BlockedUser::BLOCKED_TYPES[:pvt_message]
      users = User.active.all(:conditions => ["login IN (?) AND id <> ?", logins, current_actor.id], :limit => 50)
      users.map {|u| BlockedUser.create(:blocked_by_id => current_actor.id, :blocked_user_id => u.id, :blocked_type => type)}
      notfound = logins - users.map(&:login) - [current_actor.login]
      flash[:warning] = ("Sorry, following users cannot be found: {{logins}}. Please make sure you've entered their names correctly." / [notfound.join(", ")]) unless notfound.blank?
      if logins.include?(current_actor.login)
        flash[:warning] = flash[:warning].blank? ? "Sorry, you can not block himself.".t : flash[:warning] + "<br />" + "Sorry, you can not block himself.".t
      end
    end
    redirect_to :action => :blocked_users, :id => @user.id
  end

  def unblock_users
    ids = params[:users_to_unblock]
    unless ids.blank?
      type = BlockedUser::BLOCKED_TYPES.values.include?(params[:blocked_type]) ? params[:blocked_type] : BlockedUser::BLOCKED_TYPES[:pvt_message]
      BlockedUser.delete_all(:blocked_by_id => current_actor.id, :blocked_user_id => ids, :blocked_type => type)
    end
    redirect_to :action => :blocked_users, :id => @user.id
  end

  protected
  
  def load_owner
    params[:id] = current_actor.id if params[:id].nil?
    @user = (params[:id].to_i == current_actor.id ? current_actor : User.find_by_id(params[:id]))
    raise Kroogi::NotPermitted unless @user && @user.active?
    raise Kroogi::NotPermitted unless permitted?(@user, :content_edit)
  end
  
  def load_ivars
    @preference = @user.preference
    @profile = @user.profile
  end
end
