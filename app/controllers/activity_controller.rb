class ActivityController < ApplicationController

    before_filter :login_required
    before_filter :load_owner, :except => :read_and_frwd
    before_filter :check_permission, :except => [:read_and_frwd, :dialogue] 

    def list
      @alternate_tab_title = 'Messages for %s' / @user.login
      @hide_circles = true

      @tps_messages = Activity.with_user(@user.id).tps_messages.newest_first
      @messages = @user.messages_except_private.top(10) - @tps_messages
      @private_messages = @user.private_messages.top(5)
      @invitations = (@user.invites_requested_of_me.pending + @user.invites.pending).sort_by(&:updated_at).reverse[0..4]
      @total_invites = @user.invites_requested_of_me.count + @user.invites.count

      @projects_info = current_user.projects(:sorted => true).unshift(current_user).map do |project|
        counts = {}
        counts[:messages] = project.messages_except_private.unread.count
        counts[:private_messages] = project.private_messages.unread.count
        counts[:invites_and_requests] = project.invites_requested_of_me.pending.count + project.invites.pending.count
        counts[:tps_messages] = Activity.with_user(project.id).tps_messages.unread.count
        [project, counts]
      end

      @current_user_counts = @projects_info.find{|info| info.first.eql?(@user)}.last
    end

    def new
      @hide_circles = true
      @alternate_tab_title = 'Recent Items From People and Projects {{user}} Follows' / @user.login
      @content_kind_displayname = 'Entries From Your Network'.t

        categories = []

      @preference = @user.preference
      @include_dirs = @preference.show_feed_dirs?
      FeedEntry::CONTENT_CATEGORIES.keys.each {|cat| categories << cat if @preference.send("show_feed_#{cat}?")}
      options = {:include_dirs => @include_dirs, :categories => categories}

      @activity = @user.friend_feed(options.merge(:page => params[:page], :per_page => setpagesize))

      if flash[:show_wizard] || @user.respond_to?(:need_to_show_wizard?) && @user.need_to_show_wizard?
        @user.wizard_not_needed! if @user.basic_user?
        @show_basic_user_wizard = true
      end
    end


    def messages
      @content_kind_displayname = 'Notifications'.t
      @activity = @user.messages_except_private.paginate :page => params[:page], :per_page => setpagesize
    end

    def private
      @content_kind_displayname = 'Private Messages'.t
      @activity = @user.private_messages.paginate :page => params[:page], :per_page => setpagesize
      @view_dialogue = true
      render :action => 'messages'
    end

    # Show this user's invite/invite request history
    def invitations
      # Set defaults / handle user tampering
      params[:direction] = 'received' unless %w(sent received).include?(params[:direction].to_s)
      params[:type] = 'invite' unless %w(invite request).include?(params[:type].to_s)
      
      # Select which data to display
      @is_invite = params[:type] == 'invite'
      if params[:direction] == 'received'
        @is_sent = false
        if params[:type] == 'invite'
          @title = @user.login + ' :: ' + 'Invitations'.t
          @content_kind_displayname = 'Invitations'.t
          @invitations = @user.invites.paginate :per_page => setpagesize, :page => params[:page]
        else
          @title = @user.login + ' :: ' + 'Invitation Requests'.t
          @content_kind_displayname = 'Invitation Requests'.t
          @invitations = @user.invites_requested_of_me.not_rejected.paginate :per_page => setpagesize, :page => params[:page]
        end
      else
        @is_sent = true
        if params[:type] == 'invite'
          @title = @user.login + ' :: ' + 'Invitations Sent'.t
          @content_kind_displayname = 'Invitations Sent'.t
          @invitations = @user.invites_i_sent.paginate :per_page => setpagesize, :page => params[:page]
        else
          @title = @user.login + ' :: ' + 'Invitation Requests Sent'.t
          @content_kind_displayname = 'Invitation Requests Sent'.t
          @invitations = @user.invites_i_requested.paginate :per_page => setpagesize, :page => params[:page]
        end
      end
    end
    
    # Mark the given message(s) read or unread
    def mark
      @marked_ids = []
      @new_state = params[:as] == 'new' ? :new : :read
      Activity.find(:all, :conditions => {:id => params[:activityids]}).each do | activity |
        next unless current_actor.is_self_or_owner?(activity.user)
        next if (@new_state == :new && activity.unread?) || (@new_state == :read && !activity.unread?)
        @marked_ids << activity.id
        @new_state == :new ? activity.mark_new : activity.mark_read
      end
      respond_to do |wants|
        wants.html { return_to(params) and return }
        wants.js { }
      end
    end

    def remove
      @block = params.delete(:block)
      @delete_all = params.delete(:delete_all)
      from_user_id = params.delete(:from_user_id)
      @removed_ids = []
      @ids = params.delete(:activityids) || []
      
      Activity.transaction do
        Activity.all(:conditions => {:id => @ids}).each do | activity |
          next unless current_actor.is_self_or_owner?(activity.user)
          @removed_ids << activity.id
          activity.destroy
        end
        
        if @delete_all && from_user_id != current_actor.id
          activities = Activity.all(:conditions => {:from_user_id => from_user_id, :user_id => current_actor.id, :activity_type_id => Activity::ACTIVITIES[:sent_pvtmsg][:id]})
          @removed_ids += activities.map(&:id)
          activities.map(&:destroy)
        end

        if @block && from_user_id != current_actor.id
          BlockedUser.create(:blocked_by_id => current_actor.id, :blocked_user_id => from_user_id, :blocked_type => BlockedUser::BLOCKED_TYPES[:pvt_message])
        end

        @from_user = User.find_by_id(from_user_id) if from_user_id != current_actor.id
      end
      respond_to do |wants|
        wants.html { return_to(params) }
        wants.js { } # render remove.rjs
      end
    end

    def switch
      if session[:msg_unread_only]
        session[:msg_unread_only] = false
      else 
        session[:msg_unread_only] = true
      end
      return_to(params)
    end
    
    def read_and_frwd
      activity = Activity.find(params[:id])
      # only allow users to read activities they received themselves
      raise Kroogi::NotPermitted unless current_user.is_self_or_owner?(activity.user)
      activity.mark_read if logged_in? && (activity.user_id == current_actor.id && activity.from_user_id != current_actor.id)

      if params[:content_type]
        content = params[:content_type].constantize.find(params[:content_id])
        redirect_to(content_url(content)) and return
      end
      case params[:type]
      when 'paypal' 
        redirect_to(:controller => 'account_settings', :action => 'donation_basket', :id => action.content.id)
      when 'content'
        redirect_to activity.content.is_a?(User) ? user_url_for(activity.content) : content_url(activity.content)
      when 'comment'
        if activity.content.commentable.is_a? Profile
          if activity.content.parent_id
            # Reply to wall greeting, and on down the line
            redirect_to(:controller => 'user', :action => 'thread', :id => activity.content.commentable.user_id, 
              :thread_id => activity.content.top.id, :anchor => "comment_item_#{activity.content.id}")
          else
            # Comment on a profile (a "greeting")
            redirect_to(:controller => 'user', :action => 'thread', 
              :id => activity.content.commentable.user.id, :thread_id => activity.content.top.id, 
              :anchor => "comment_item_#{activity.content.id}")
          end
        elsif activity.content.commentable.is_a? UserKroog
          redirect_to(:controller => 'user', :action => 'thread', :id => activity.content.commentable.user_id,
            :thread_id => activity.content.top.id, :anchor => "comment_item_#{activity.content.id}")
        else
          redirect_to comment_url(activity.content)
        end
      when 'user'
        redirect_to(user_url_for(activity.content))
      when 'from_user'
        redirect_to(user_url_for(activity.from_user))
      when 'user_kroog'
        redirect_to(:controller => 'kroogi', :action => 'show', :id => activity.content.user, :type => activity.content.circle_id, :highlight_user => activity.from_user_id)
      when 'invite_request'
        if invite = activity.content
          redirect_to("/invite/find/#{invite.wants_to_join_id}?invitee_id=#{invite.user_id}&circle_id=#{invite.circle_id}")
        else
          flash[:warning] = "Sorry, that doesn't seem to be a valid link".t
          redirect_to("/activity/list")
        end
      when 'purchase'
        # possible todo - check number of downloads if desired and error out by checking read activity counts
        # spec has it as a may ..
        bundle = params[:bundle_id] ? activity.content.bundles.find(params[:bundle_id]) : activity.content.bundles.first
        redirect_to(bundle.s3_url)
      end
    end

    def dialogue
      @with_user = User.find_by_id(params[:with])
      raise Kroogi::NotFound unless @with_user

      passed = current_user.admin? && params[:force_view]
      passed ||= permitted?(@user, :content_edit)
      passed ||= permitted?(@with_user, :content_edit)
      raise Kroogi::NotPermitted unless passed


      if current_user.is_self_or_owner?(@user)
        @you, @other_person = @user, @with_user
      else
        @you, @other_person = @with_user, @user
      end
      @messages = Pvtmessage.between(@user, @with_user).paginate(
              :page => params[:page], :per_page => setpagesize, :order => 'created_at desc')
      @show_form = !params[:show_form].blank?
    end

    def update_feed_filters
      preference = Preference.find(params[:id])
      preference.update_attributes!(params[:preference])
      redirect_to :action => 'new'
    end

    private
    def authorize_moderators
      return if session[:moderating]
      authenticate_or_request_with_http_basic("View All Content For Moderation") do |username, password|
        session[:moderating] = (username == "moderator" && password == "kroogi")
      end
    end
    
    def return_to(params)
      if params[:back_to].blank?
        redirect_to explore_path
      else
        redirect_to(:controller => 'activity', :action => params[:back_to])
      end
    end
        
    # Given e.g. :today, return start and end times
    def time_ago_from_words(range)
      startts = endts = Time.now
      
      case range
      when :today then startts = 24.hours.ago
      when :yesterday
        endts = 2.days.ago
        startts = 1.day.ago
      when :week then startts = 1.week.ago
      when :month then startts = 6.months.ago
      end
      
      return startts, endts
    end
        
    def load_owner
      @user = User.find_by_login(user_subdomain) if user_subdomain
      @user ||= User.find_by_id(params[:id]) if params[:id]
      redirect_to user_url_for(current_actor, :action => action_name, :controller => 'activity') and return unless @user
    end

    def check_permission
      raise Kroogi::NotPermitted unless permitted?(@user, :content_edit) || current_user.admin? && params[:force_view]
    end
end
