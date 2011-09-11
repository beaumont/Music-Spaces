=begin
This controller handles all LiveJournal Blog integration for both projects
and for users.  Depending on the type of current_actor, different views are
provided, yet we still use the same underlying system to handle these accounts.
=end
class BlogController < ApplicationController
  before_filter :login_required #, :except => :index
  before_filter :load_user
  before_filter :user_required
  before_filter :set_tab
  before_filter :login_or_not_a_bum_required, :only => [:index]
  before_filter :load_projects, :only => [:settings]
    
  def index
    if current_actor == @user
      # If there is no account, and they are the user, we will redirect to settings
      # to get things started by asking them for their LJ credentials.
      redirect_to :action => :settings, :id => @user and return unless @user.livejournal_account
    end

    # Grab the entries to show
    if @account = @user.livejournal_account
      @entries = Blog.paginate :conditions => {:user_id => @user}, 
                               :include => [:blogentry],
                               :order => "`live_journal_entries`.`posted_at` desc", 
                               :per_page => setpagesize, 
                               :page => params[:page]
    end
  end
  
  # Display the configuration page for LJ credentials
  def settings
    raise Kroogi::NotFound if @user.nil? || !permitted?(@user, :content_add)
    
    @user_kroog = @user.kroogi_settings
    @account = @user.livejournal_account || @user.build_livejournal_account(:connect_friends => true)
    
    @account.friend_circle ||= 5 #default to interested and closer

    set_type_from_params
  end
  
  # Allow owners to manually refresh their blog entries
  def refresh
    if @user.livejournal_account
      @user.livejournal_account.update_cache
      @user.livejournal_account.update_attribute(:last_manual_sync, Time.now)
      flash[:success] = "Your journal entries and comments have been updated".t
    else
      flash[:warning] = "You ({{user_name}}) don't have LJ account" / @user.login
    end
    redirect_to :controller => 'blog', :action => 'index', :id => @user
  rescue NoMethodError, StandardError => e
    if e.message == 'Client error: No username sent.'
      flash[:error] = "Unable to update your livejournal entries, please check your login/password and try again".t
    else
      flash[:error] = "Unable to update your livejournal entries at this time: %s" / e.message
    end
    just_notify(e)
    redirect_to :controller => 'blog', :action => 'index', :id => @user
  end
  
  
  # Update the current actor's LJ credentials for this blog
  def update
    raise Kroogi::NotFound if @user.nil? || !permitted?(@user, :content_add)
    was_community = current_actor.livejournal_account.is_community? if current_actor.livejournal_account
    if params[:account]
      if params[:account][:username].blank?
        Blog.destroy_all(:user_id => current_actor)
        current_actor.livejournal_account.destroy if current_actor.livejournal_account
        flash[:success] = "Your Livejournal account has been removed".t
        if params[:is_from_setting_center]
          redir_hash = {:controller => 'preference', :action => 'show', :id => @user.id}
        else
          redir_hash = {:action => :settings, :id => @user.id}
        end
        redir_hash.merge!({:type => 'community'}) if was_community
        redirect_to(redir_hash) and return
      else
        if current_actor.livejournal_account.blank?
          @account = current_actor.build_livejournal_account(params[:account])
          @res = @account.save
        elsif current_actor.livejournal_account.username != params[:account][:username] ||
              current_actor.livejournal_account.usejournal != params[:account][:usejournal]
          was_community = current_actor.livejournal_account.is_community?
          Blog.destroy_all(:user_id => current_actor)
          current_actor.livejournal_account.destroy
          current_actor.livejournal_account = nil
          @account = current_actor.build_livejournal_account(params[:account])
          @res = @account.save
        else
          @account = current_actor.livejournal_account
          @res = @account.update_attributes(params[:account])
        end
        
        set_type_from_params
        @account.clear_passwords
        
        # update security on existing entries
        @account.blogs.each do |blog|
          case blog.blogentry.security
          when :friend, :friends
            blog.update_security!(@account.friend_circle)
          end
        end
        
        # remove existing entries that have changed
        # FIXME: this should be model specific, duplicated for the moment
        @account.blogs.each do |blog|
          deleteete = false
          if blog.blogentry          
            entry = blog.blogentry
            case entry.security
            when :public
              delete = false
            when :friend, :friends
              delete = !@account.allow_friends?
            else # me & custom
              delete = !@account.import_mine?
            end
          else
            delete = true
          end
          
          if delete
            # well it was tagged for removal
            blog.blogentry.destroy
            blog.destroy
          end
        end
        
        # and we got result...
        if @res
          @account.update_cache(true)
          flash[:success] = 'LiveJournal account update complete'.t
        else
          flash.now[:warning] = 'LiveJournal account update failed'.t
          render :action => 'settings' and return
        end
        
      end
    end
    
    if was_community
      redir_hash = {:action => :settings, :id => @user.id, :type => 'community'}
      redirect_to(redir_hash) and return 
    end
    if params[:is_from_setting_center]
      redirect_to :controller => 'preference', :action => 'show', :id => @user.id and return
    else
      redirect_to :action => :index, :id => @user
    end
  # rescue ActiveRecord::RecordInvalid
  #   flash[:error] = "We were unable to connect to LiveJournal with the provided account information.".t
  #   redirect_to :action => 'settings', :id => current_actor.id
  rescue Timeout::Error
    flash.now[:warning] = 'Unable to update your LiveJournal account at this time, please try again later.'.t
  end

  protected
  
    def user_required
      raise Kroogi::NotFound unless @user
    end  
    
    def set_tab
      @tab = :blog
    end
    
    def set_type_from_params
      if params[:type] == 'personal'
        @type = 'personal'
      elsif params[:type] == 'community'
        @type = 'community'
      elsif !params[:type] && @account.is_community?
        @type = 'community'
      else
        @type = 'personal'
      end
    end
    
end
