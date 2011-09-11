class InviteController < ApplicationController

  MAX_USERS_SEARCH_PAGE_SIZE = 50
  MAX_KROOGI_USER_INVITES_DAILY = 100

  filter_parameter_logging "magic_in"
  before_filter :login_required, :except => [:start_following, :get_invited_after_donation]
  verify :method => :post, :only => [:update, :accept, :deny, :start_following, :get_invited_after_donation],
         :redirect_to => {:action => :show}
  before_filter :invite_required, :only => [:show, :accept, :deny, :update]
  before_filter :grab_user, :only => [:join, :closer_add, :send_invites]

  skip_before_filter :verify_authenticity_token, :only => [:select_kroogi_users_to_follow]

  verify :method => :post, :only => [:follow_users], :redirect_to => { :controller => '/'}

  def new
    @user = User.find_by_id(params[:id])
    @user = current_actor unless @user && current_user.is_self_or_owner?(@user)
    @invite = Invite.new
    @invite.circle_id = Invite::TYPES[:site_invite][:id]
    @invite.inviter_id = current_actor.id
    @invite.invitation = params[:invite][:invitation] if params[:invite] && params[:invite][:invitation]
  end

  def show
    raise Kroogi::NotPermitted unless @invite && current_user.is_self_or_owner?(@invite.inviter)
    unless @invite.user
      flash[:warning] = "Sorry, since we've already sent your invite there's nothing we can do to edit it at this point".t
      redirect_to '/activity/list'
    end
  end

  # Join (free) without any existing invitation
  def join
    unless @user && @kroog && @kroog.open? && current_actor.can_follow?
      flash[:warning] = "Error: The specified circle does not exist or cannot be joined".t
      respond_to do |format|
        format.html do
          redirect_to(:controller => 'kroogi', :action => 'join_circles', :id => params[:id])
        end
        format.js {render :update do |page|; page << 'document.location.reload(false);'; end}
      end
      return
    end

    # Add the relationship directly -- no invite intermediary
    Relationship.create_kroogi_relationship(:followed => @user.id, :follower => current_actor.id, :relationshiptype_id => @kroog.relationshiptype_id, :expires_at => Time.end, :skip_activity_message => true)

    flash[:success] = "You have joined the %s circle of %s" / [@user.circle_name(params[:circle].to_i), @user.login]
    PublicQuestionHelper::set_question_artist_id(@user, self, :force_show => true)
    respond_to do |wants|
      wants.html do
        redirect_to user_url_for(@user)
      end
      wants.js {}
    end
  end

  # Misleading name -- used to request getting closer
  def closer_add
    unless @user && @kroog
      flash[:warning] = "Error: The specified circle does not exist".t
      redirect_to(:controller => 'kroogi', :action => 'join_circles', :id => params[:id]) and return
    end

    unless current_actor.is_a_follower_of?(@user)
      flash[:warning] = "No request sent: you can not send requests to the not followed users".t
      redirect_to(:controller => 'kroogi', :action => 'join_circles', :id => params[:id]) and return
    end

    unless @kroog.can_request_invite?
      flash[:warning] = "No request sent: you can not send request to this circle".t
      redirect_to(:controller => 'kroogi', :action => 'join_circles', :id => params[:id]) and return
    end

    if current_actor.is_self_or_owner?(@user)
      flash[:warning] = "No request sent: you are already as close as you can get".t
      redirect_to(:controller => 'kroogi', :action => 'join_circles', :id => params[:id]) and return
    end

    unless current_actor.invites_i_requested.rejected.requests_to(@user).select { |x| x.circle_id == params[:circle].to_i }.size < 3
      flash[:warning] = "No request sent: stop bugging this user!".t
      redirect_to(:controller => 'kroogi', :action => 'join_circles', :id => params[:id]) and return
    end

    InviteRequest.request_invite(current_actor, @user, params[:circle].to_i)
    PublicQuestionHelper::set_question_artist_id(@user, self)

    flash[:success] = "Your request was successfully sent".t
    redirect_to :controller => 'kroogi', :action => 'join_circles', :id => @user
  end

  def deny_request
    request = InviteRequest.find(params[:id])
    unless request && current_actor.is_self_or_owner?(request.wants_to_join)
      warning = "You don't have permission to access that action".t
    else
      begin
        if request.accepted?
          warning = "Couldn't reject this request: it's already accepted".t
        else
          request.reject!
          msg = 'You have chosen to ignore this request for invitation'.t
        end
      rescue AASM::InvalidTransition => e
        warning = "There was an error trying to reject this request".t
        log.error "couldn't deny request %s: %s" % [request.inspect, e.inspect]
      end
    end
    respond_to do |wants|
      wants.html do
        flash[:success] = msg if msg
        flash[:warning] = warning if warning
        redirect_to '/activity/list'
      end
      wants.js do
        render(:update) do |page|
          page.select(".invite_#{request.id}_status").each { |i| i.replace msg || warning }
          page.select(".invite_#{request.id}_status").each { |i| i.visual_effect :highlight }
        end
      end
    end
  end


  # Called from a form on the find page. Actually sends the invites out.
  def send_invites
    # Security stuff
    raise Kroogi::NotPermitted unless permitted?(@user, :profile_edit) # @user is inviter
    unless check_invites_quota(@user)
      redirect_to(:controller => 'invite', :action => 'find') and return
    end
    
    request = InviteRequest.find(params[:invite_id]) unless params[:invite_id].blank?

    # Ensure sufficient params
    unless params[:to_invite]
      flash[:warning] = 'No users selected to invite -- please try again'.t
      redirect_to(:controller => 'invite', :action => 'find') and return
    end
    unless params[:circle_id] && Invite.valid_circle_id?(params[:circle_id].to_i, :include_site_invite => true)
      flash[:warning] = 'Invalid circle id -- please try again'.t
      redirect_to(:controller => 'invite', :action => 'find') and return
    end

    invites_sent = Invite.send_invites(params, @user)

    # Set success or failure messages
    if invites_sent.empty?
      flash[:warning] = 'Unable to send any of the invites'.t
      redirect_to(:controller => 'invite', :action => 'find', :invitee_id => invites_sent.size == 1 && !invites_sent.first.user_id.blank? ? invites_sent.first.user_id : nil) and return
    else
      flash[:success] = (invites_sent.size == 1) ? ("Successfully invited %s" / [invites_sent.first.display_name]) : ("Successfully sent %d invitations" / [invites_sent.size])
    end

    question_of_some_target_user = invites_sent.find { |i| i.user && !i.user.public_questions.interactive_for(@user).empty? }
    PublicQuestionHelper::set_question_artist_id(question_of_some_target_user.user, self, :force_show => true) if question_of_some_target_user

    # OK, now redirect appropriately
    respond_to do |wants|
      wants.html do
        is_site_invite = params[:circle_id].to_i == Invite::TYPES[:site_invite][:id]
        redirect_to is_site_invite ? ({:controller => '/user', :action => 'founders', :id => @user}) : ({:controller => '/kroogi', :action => 'show_pending', :id => @user, :type => params[:circle_id], :highlight_invite => invites_sent.map(& :id).join('|')})
      end
      wants.js do
        render(:update) do |page|
          page.select(".invite_#{request.id}_status").each { |i| i.replace 'User added'.t }
          page.select(".invite_#{request.id}_status").each { |i| i.visual_effect :highlight }
        end
      end
    end
    # Shit... something went wrong.  It shouldn't, so send admin alert out, too
  rescue ActiveRecord::RecordInvalid => e
    flash[:warning] = 'Unable to send some or all of your invites'.t
    just_notify(e)
    redirect_to :controller => 'invite', :action => 'find'
  end


  def find
    @invitee = nil
    @invitee = User.find_by_id(params[:invitee_id]) unless params[:invitee_id].blank? # Invitee's context, plus blow up unless exists
    @invitee = nil unless @invitee && @invitee.active?

    @user = params[:id] ? User.find_by_id(params[:id]) || current_actor : current_actor
    @user = nil unless @user && @user.active?

    unless params[:invite] && !params[:invite][:circle_id].blank?
      
      if params[:restrict] == Invite::TYPES[:founder_circle][:id].to_s
        menu = Invite.menu_founder
      else
        menu = Invite.menu_for(@user, true)
      end

      @invitee.is_a_follower_of(@user, Relationshiptype.by_invite_only).each do |rel|
        menu.reject! { |item| rel.relationshiptype_id.to_i <= Invite::TYPES[item][:id] }
      end unless @invitee.nil?

      params[:invite] ||= {}
      params[:invite][:circle_id] ||= menu.map {|k| Invite::TYPES[k][:id]}.sort.last
    end

    @invite = Invite.new(params[:invite])
    @invite.free = params[:invite].delete(:free) if params[:invite]
    @invite.inviter = @user
    raise Kroogi::NotPermitted unless permitted?(@user, :profile_edit) # @user is inviter

    # If already as close as can be, bail
    closest_circle = @user.project? ? Relationshiptype::TYPES[:founders] : Relationshiptype::TYPES[:family]
    if @invitee && @invitee.is_a_follower_of?(@user, closest_circle)
      # Clear "get closer" request
      InviteRequest.clear_pending(@invitee, @user)
      flash[:warning] = "%s is already in your innermost circle" / [h(@invitee.login)]
      redirect_to userpage_path(@invitee) and return
    end

    do_find params
  end

# invite people from user`s own addrbook at mail servers. this is 3-step wizard
# used together with _invite_friends_ovr_prepare.html - need to be included in :js section
  def add_friends_wizard
    @user = params[:id] ? User.active.find(params[:id]) || current_actor : current_actor
    raise Kroogi::NotPermitted unless permitted?(@user, :profile_edit)
    render :partial => 'add_friends_wizard', :locals => {:start_following_step => params[:start_following_step] == 'true'}
  end

  def select_kroogi_users_to_follow
    raise Kroogi::NotPermitted unless logged_in?
    user = current_actor
    already_invited = Invite.connection.select_rows("select distinct user_email from invites where inviter_id = #{user.id} and user_email is not null and user_id is null and invites.state = 'pending'").flatten
    already_invited += Invite.connection.select_rows("select users.email from invites inner join users on users.id = invites.user_id and invites.inviter_id = #{user.id}  and invites.state = 'pending'").flatten

    mail_in = (params['mail_in'] || '').chars.downcase
# rought checking for malware and also throwing away spaces at end and at start of email addr
    mail_in.gsub!(/[<>|:]+| +$|^ +/, '')
    magic_in = params['magic_in']
    magic_in ||= ''

    kroogi_users_mails, external_mails, followers = [], [], []
    begin
      #wrong email? hi`s takin the piss?
      unless mail_in =~ User::EMAIL_REGEX
        raise ContactsImportError.new('Make sure you entered your email address correctly.'.t)
      end
      # first checking his address book using a given email and a password
      unless (mail_in.empty? && magic_in.empty?)
        imported_mails, mail_creds = import_contacts(mail_in, magic_in)
        log.debug "imported_mails: #{imported_mails.inspect}, mail_creds: #{mail_creds.inspect}"
        imported_mails ||= []
        kroogi_users_mails, external_mails = categorize_user_contacts(imported_mails, user, mail_creds[1])
        if kroogi_users_mails.empty? && external_mails.empty?
          raise ContactsImportError.new('Your address book at {{account}} is empty. Please try another email.' / mail_in)
        end
      end
      Relationship.find_followers_paginated(user) do |follower|
        followers << follower.email if kroogi_users_mails.find { |name, email| equal_emails?(email, follower.email) }
      end

      already_invited = already_invited.select { |invited_email| (kroogi_users_mails + external_mails).find { |name, email| equal_emails?(email, invited_email) } }
      already_invited = (already_invited + followers).map {|email| email.downcase}
      already_invited = Set.new(already_invited)

      followed = user.followed_projects(:limit => nil)
      suggest_following = kroogi_users_mails
      suggest_following.reject! {|name, email| equal_emails?(email, user.email)} #don't follow self
      already_followed = Set.new(followed.select {|f| kroogi_users_mails.find {|name, email| equal_emails?(email, f.email)}}.map {|f| f.email.downcase})

      flash_data = {
              :suggest_following => sort_contacts(suggest_following),
              :already_followed => already_followed,
              :external_emails => sort_contacts(external_mails),
              :already_invited_or_followers => already_invited,
              :start_following_step => (params[:start_following_step] == 'true'),
              }
    rescue ContactsImportError => e
      bas_errmsg = e.message
    rescue Exception => e
      errored = true
      raise e
    ensure
      unless errored
        if bas_errmsg
          flash_data = {
                  :errors => bas_errmsg,
                  :form_data => {:mail_in => params[:mail_in]}, #we don't actually want to restore password - email is enough
                  :start_following_step => (params[:start_following_step] == 'true'),
          }
        end
        user.set_flash(:invite_widget_search_results, flash_data)
        redirect_to safe_redirect(params[:return_to]) and return
      end
    end
  end

  def follow_users
    follow = params[:follow] || []
    follow_emails = []

    users = User.active.users_first.all :conditions => {:id => follow}
    follow_emails = users.map(&:email)
    users.map {|user| Relationship.make_user_follow_project(:follower => current_actor, :followed => user)}

    saved_data = current_actor.get_and_delete_flash(:external_email_contacts_found) ||
      {:suggest_following => [], :already_followed => [], :external_emails => [], :already_invited_or_followers => [], :start_following_step => true}
    saved_data.merge!(:preselect => Set.new(follow_emails) + saved_data[:already_followed])
    render :partial => 'select_emails_to_invite', :locals => saved_data
  end

  def send_invitations
    @user = params[:id] ? User.find_by_id(params[:id]) || current_actor : current_actor
    @invite = Invite.new(params[:invite])
    @invite.free = params[:invite].delete(:free) if params[:invite] # what`s that? another black magic....
    @invite.inviter = @user
    # @followers = @user.followers_and_founders.map { |p| p.email }

    kroogi_users_mails = params[:kroogi_mails]
    kroogi_users_mails ||= []

    external_mails = params[:external_mails]
    external_mails ||= []

    umsg =  params['user_message']
    umsg ||= ''

    # Rought checking for malware
    kroogi_users_mails.each { |item| item.gsub!(/[<>|:]/, '') }
    external_mails.each { |item| item.gsub!(/[<>|:]/, '') }
    umsg.gsub!(/[<>|:]/, '')
    # sending kroogi inner invites
    user_ids = kroogi_users_mails.map { |i| User.active.find_by_email(i).id }
    begin
      @invites_sent_kroogi= Invite.send_invites__do_user_invites(user_ids, {
              :circle_id => Relationshiptype::TYPES[:interested], :invitation_text => umsg}, @user)
    rescue ActiveRecord::RecordInvalid => e
      @bas_errmsg = 'Some of your email addresses were entered incorrectly and invitations were not sent.'.t
    end
    # sending kroogi emails to the entire world
    begin
        @user_ids_f, @invites_sent_f = Invite.send_invites__do_email_invites(external_mails, @user, I18n.locale,
                                                                             Relationshiptype::TYPES[:interested], umsg)
    rescue ActiveRecord::RecordInvalid => e
      @bas_errmsg = 'Some of your email addresses were entered incorrectly and invitations were not sent.'.t
    end
    render :partial => 'invitation_wizard_thank_you', :locals => {:start_following_step => (params[:start_following_step] == 'true')}
  end

  # From invite to system link -- sends directly to email
  def invite_by_mail
    @user = User.find_by_id(params[:id])
    raise Kroogi::NotPermitted unless @user && @user.active? && permitted?(@user, :profile_edit) # @user is inviter

    begin
      invited = []
      Invite.transaction do
        params[:user_emails].split(',').each do |eml|
          eml = eml.strip
          next unless eml.match(User::EMAIL_REGEX)
          next if Invite.find_by_user_email_and_inviter_id(eml, @user.id)

          Locale.with_locale(params[:locale]) do
            @invite = Invite.new_for_mail(params[:invite].merge(:join_inviter_to_invited => true), @user, params[:locale])
            @invite.user_email = eml
            @invite.save!
            invited << @invite
          end
        end
      end
      if invited.empty?
        flash[:warning] = "Unable to send any invites: couldn't parse emails or emails have already been invited".t
        redirect_to :action => 'new', :id => @user, :user_emails => params[:user_emails], :locale => params[:locale], :invite => {:invitation => params[:invite][:invitation]}
      else
        flash[:success] = invited.size == 1 ? ("Sent invite to %s"/[invited.first.user_email]) : ("Sent invites to: %s"/[h(invited.map(& :user_email).to_sentence)])
        redirect_to :controller => 'kroogi', :action => 'show_pending', :id => @user, :type => Invite::TYPES[:site_invite][:id], :highlight_invite => invited.map(& :id).join('|')
      end
    rescue ActiveRecord::RecordInvalid
      do_find params
      render :action => 'find'
    end
  end

  def accept
    begin
      Invite.transaction do
        # Hack to make sure updated privacy is reflected in the model
        @invite.update_privacy(params[:privacylevel]) if params[:privacylevel] && @invite.privacylevel != params[:privacylevel]

        @invite.accept! unless @invite.accepted?
        @invite.activities(:invite_sent).each { |x| x.mark_done } # There should only be one, but just in case...
        flash[:success] = "You have accepted %s's invitation" / [(h @invite.inviter.login)]
        @status = 'This invite has been accepted'.t
      end
    rescue => e
      @status = 'There was an error trying to accept this invitation'.t
      AdminNotifier.async_deliver_alert("Accept invitation: #{e.inspect}")
    end
    respond_to do |wants|
      wants.html { params[:reciprocate] ? redirect_to(:controller => '/invite', :action => 'find', :id => current_actor, :invitee_id => @invite.inviter) : redirect_back_or_default(:controller => 'user', :id => @invite.inviter_id) }
      wants.js {
        render(:update) { |page|
          page.select(".invite_#{@invite.id}_status").each { |i| i.replace @status }
          page.select(".invite_#{@invite.id}_status").each { |i| i.visual_effect :highlight }
        }
      }
    end
  end

  def deny
    flash_msg = nil
    begin
      Invite.transaction do
        # TODO: re-enable this once destroying invites doesn't affect relationships anymore
        # @invite.clear_other_invitations
        @invite.reject!
        @invite.activities(:invite_sent).each { |x| x.mark_done } # There should only be one, but just in case...
        flash_msg = "You have declined %s's invitation"
        @status = 'This invite has been rejected'.t
      end
    rescue AASM::InvalidTransition => e
      if @invite.rejected?
        flash_msg = "%s's invitation was already rejected"
        @status = "This invite was already rejected".t
      else
        flash_msg = "Couldn't decline %s's invitation"
        @status = "This invite couldn't be rejected".t
      end
    rescue => e
      @status = 'There was an error trying to reject this invitation'.t
      AdminNotifier.async_deliver_alert("Deny invitation: #{e.inspect}")
    end
    respond_to do |wants|
      wants.html do
        (flash[:warning] = flash_msg / (h @invite.inviter.login)) if flash_msg
        redirect_back_or_default(:controller => '/activity', :action => 'list')
      end
      wants.js do
        render(:update) { |page|
          page.select(".invite_#{@invite.id}_status").each { |i| i.replace @status }
          page.select(".invite_#{@invite.id}_status").each { |i| i.visual_effect :highlight }
        }
      end
    end
  end

  # activate invite by activation code
  # - note - this method does not accept invite, it just associates email invite with a newly registered user,
  # user still needs to accept the invite to join relationship
  #
  def activate
    flash.clear
    return if params[:id].blank? and params[:activation_code].blank?
    activator = params[:activation_code] || params[:id]
    @invite = Invite.find_by_activation_code(activator)
    if @invite
      if @invite.user_id
        flash[:warning] = "The invitation has been already registered".t
      elsif user = User.find_by_email(@invite.user_email)
        flash[:warning] = "The user #{user.login} is already registered with this email address".t
      else
        # special case for :founder_circle as they can only be accepted by projects
        # so switch the user identity #@invite.circle_id == Invite::TYPES[:founder_circle][:id] &&
        # or should we always switch identity to user when accepting email invite ?? tough one ..
        Invite.transaction do
          if current_user.on_behalf_id != 0
            current_user.on_behalf_id = 0
            current_user.save!
          end
          @invite.user_id = current_actor.id
          @invite.display_name = current_actor.display_name
          @invite.save!

          Activity.send_message(@invite, @invite.inviter, :invite_sent)
        end
        flash[:success] = "The invitation has been registered for %s" / current_actor.login
      end
      redirect_to(:controller => '/activity', :action => 'list')
    else
      params[:activation_code] = activator
      flash[:warning] = "Unable to register the invitation. Please make sure that the activation code is correct.".t
    end
  end


  def update
    raise Kroogi::NotPermitted unless permitted?(@user, :profile_edit) # @user is inviter
    Invite.transaction do
      if params[:save_button]
        @invite.update_attributes!(params[:invite])
        if @invite.circle_id == Invite::TYPES[:founder_circle][:id]
          Relationship.update_relationship_privacylevel(@invite.user, @invite.inviter, Relationshiptype.founders, @invite.privacylevel)
        end
        flash[:success] = 'Invite was successfully updated.'.t
      elsif params[:reinvite_button]
        flash[:success] = "Reinvited %s" / h(@invite.user ? @invite.user.display_name : @invite.user_email)
        @invite.update_attribute(:invitation, params[:invite][:invitation]) if params[:invite][:invitation]
        @invite.reinvite!
      elsif params[:delete_button]
        flash[:warning] = "Cancelled invitation to %s" / h(@invite.user ? @invite.user.display_name : @invite.user_email)
        Activity.send_message(@invite, @invite.inviter, :invite_cancelled)
        delete_impl
      end
    end
    redirect_done(params)
  end

  def start_following
    p = params[:start_following]
    if p[:flag] == "1"
      current_user_wanna_join(p[:project_id], (p[:follower_email] || '').strip, params[:download] == 'true' ? params[:content_id] : nil)
    end
    errors = []
    before_donation_form_submit(params, p[:contributed_amount], errors)
    if errors.blank?
      flash[:zero_dl_by_loggedin] = params[:dialog_id_suffix] if params[:download] == 'true' && p[:contributed_amount] == "0"
      render :text => ''
    else
      render :js => %Q{jQuery('#donation_dialog_error_messages_#{params[:dialog_id_suffix]}').html("#{errors.join("\n")}");}
    end
  end

  def get_invited_after_donation
    p = params[:invite]
    if session[:dl_link_needed] == params[:content_id].to_i
      send_link = true
      session[:dl_link_needed] = nil
    end
    invite = current_user_wanna_join(p[:project_id], p[:follower_email], params[:download] == 'true' ? params[:content_id] : nil,
                                     :send_link => send_link)
    render(:update) do |page|
      if invite && !invite.errors.empty?
        message = invite.errors.full_messages.join("<br/>")
        page["get_invited_form_errors"].innerHTML = message
      else
        page["get_invited_form"].innerHTML = ''
      end
    end
  end

  protected

  def invite_required
    @invite = Invite.current.find(params[:id])
    @user = @invite.inviter
    raise Kroogi::NotPermitted unless logged_in? && current_actor.is_self_or_owner?(@invite.inviter, @invite.user)
  end

  def grab_user
    @user = User.find_by_id(params[:id])
    @user = nil unless @user && @user.active?

    raise Kroogi::NotPermitted if @user.nil?

    @kroog = params[:circle] ? @user.circles.detect { |x| x.relationshiptype_id == params[:circle].to_i } : nil
    @account_setting = @user.account_setting
  end

  private

  def delete_impl
    raise Kroogi::NotPermitted unless permitted?(@user, :profile_edit) || @invite.user_id == current_actor.id # @user is inviter or deleteing myself
    raise Kroogi::NotPermitted unless @invite.can_delete?
    Invite.transaction do
      if @invite.circle_id == Invite::TYPES[:founder_circle][:id] && @invite.user && @invite.user.on_behalf_id == @invite.inviter_id
        @invite.user.on_behalf_id = 0
        @invite.user.save!
      end
      @invite.revoke!
      Relationship.downgrade_kroogi_relationship(:invite => @invite)
    end
  end

  def redirect_done(params)
    if params[:restrict] && params[:restrict] == Invite::TYPES[:founder_circle][:id].to_s
      redirect_to(:controller => '/user', :action => 'founders', :id => @user)
    else
      redirect_to(:controller => '/kroogi', :action => 'show_pending', :id => @user, :type => @invite ? @invite.circle_id : nil, :highlight_invite => @invite ? @invite.id : nil)
    end
  end

  def check_invites_quota(user)
    if user.invites_i_sent.count(:conditions => ['created_at >= ? and user_email is null',  Date.today]) > MAX_KROOGI_USER_INVITES_DAILY
      flash[:warning] = 'Sorry, only {{count}} invites to existing Kroogi users allowed daily' / MAX_KROOGI_USER_INVITES_DAILY
      return false
    end
    true
  end
  
  # OPTIMIZE: refactor this method
  def do_find(params)
    @invitee ||= User.find_by_id(params[:invitee_id]) unless params[:invitee_id].blank?

    #@invitee = nil if @invitee && Relationship.relationships(current_actor, @invitee, Relationshiptype.all_valid).blank?

    @matched_users = Array.new
    @invite.circle_id = params[:circle_id] unless params[:circle_id].blank?
    @available_types ||= []

    return unless check_invites_quota(@user)

    if params[:restrict] == Invite::TYPES[:founder_circle][:id].to_s
      # special case for inviting founders, its only allowed when restrict parameter is passed
      menu = Invite.menu_founder
      @invite.circle_id = Invite::TYPES[:founder_circle][:id]
    else
      menu = Invite.menu_for(@user, true)
    end

    # Get all matching users (if one passed in, just grab that one)
    matches = if !params[:invitee_id].blank?
      @emails = []; @terms = []
      m = @invitee ? [@invitee] : []
      if m.size == 1
        params[:users] = m.first.login
        m.first.is_a_follower_of(@user, Relationshiptype.by_invite_only).each do |rel|
          menu.reject! { |item| rel.relationshiptype_id.to_i <= Invite::TYPES[item][:id] }
        end
      end
#      logger.debug "! Menu: #{menu.inspect}"
      m
    elsif !params[:users].blank?
      @terms = params[:users].split(',').map { |x| x.strip }
      @emails = @terms.select { |t| t.match(User::EMAIL_REGEX) }
      values_to_insert = []
      if @terms.size == 1 # Only one search term, do LIKE search
        like = "%#{h(@terms.first)}%"
        values_to_insert = [like, like, like]
        query = "(login LIKE ? OR display_name LIKE ? OR email LIKE ?)"
        # FIXME: code have no side effect
        if @invite.circle_id == Invite::TYPES[:founder_circle][:id]
          query + " AND (type = 'BasicUser' OR type = 'AdvancedUser')"
        end
      else # Multiple terms, each must match exactly
        query = @terms.inject([]) do |array, t|
          values_to_insert << [t, t, t]
          array << '(login = ? OR display_name = ? OR email = ?)'
        end.join(' OR ')
      end
      query = "(%s) AND type NOT IN ('%s', '%s')" % [query, CollectionProject.name, Facebook::User.name]
      User.active.all(:conditions => [query] + values_to_insert.flatten, :limit => MAX_USERS_SEARCH_PAGE_SIZE*5)
    end

    if matches
      # If you're inviting to founders/members circle, you can't invite any projects
      if @invite.circle_id == Invite::TYPES[:founder_circle][:id]
        @are_projects = matches.select { |x| x.project? }
        matches -= @are_projects
      end

      # If only one user, and that user is already in or invited to circles, invite to next-closest used circle, if one exists
      # If not, set it to current circle (closest) so we don't look like complete idiots
      if matches.count == 1 && (params[:invite].nil? || params[:invite][:circle_id].blank?)
        in_circle = @user.find_circle_with(matches.first)
        invited_circle = matches.first.invited_to?(@user)
        in_circle = in_circle.circle_id if in_circle
        invited_circle = invited_circle.circle_id if invited_circle

        if current_circle = [invited_circle, in_circle].compact.max
          if closer_circle = @user.circles(:just_ids => true).sort.detect { |x| x < current_circle }
            @invite.circle_id = closer_circle
          else
            @invite.circle_id = current_circle
          end
        end
      end

      # Can't invite ppl with pending invitations to this circle or closer
      pending_invites = @user.invites_i_sent.pending

      #note that some active inviters can have thousands here - so don't turn this into array
      invited_users = pending_invites.only_circles(Relationshiptype.circle_and_closer(@invite.circle_id))

      # Can't invite self or ppl in this circle or closer
      exclude_ids = if @invite.circle_id == Invite::TYPES[:site_invite][:id] then
        [current_actor.id]
      else
        [current_actor.id] + current_actor.all_related.in_circle_or_closer(@invite.circle_id).
          all(:conditions => {:id => matches.map(&:id)}, :select => 'users.id').map(&:id)
      end

      in_cirles = current_actor.followers.all(:conditions => {:id => matches.map(&:id)})

      if @invite.circle_id == Invite::TYPES[:founder_circle][:id]
        @need_following = []
      else
        @need_following = matches - in_cirles
      end
      
      # OK, now figure out all the special cases and categorize all matches
      @too_close = matches.select { |x| exclude_ids.include?(x.id) }
      @matched_users = matches - @too_close - @need_following + @emails
      @already_invited = @matched_users.select { |x| x.is_a?(User) ? invited_users.find_by_user_id(x.id) : invited_users.find_by_user_email(x)}
      @matched_users -= @already_invited
      if @matched_users.size > MAX_USERS_SEARCH_PAGE_SIZE
        @matched_users = @matched_users[0..MAX_USERS_SEARCH_PAGE_SIZE-1]
        flash[:warning] = 'Displaying first %d found users' / MAX_USERS_SEARCH_PAGE_SIZE
      end
      @not_found = (@terms - @emails).reject { |t| matches.any? { |m| [m.login, m.display_name, m.email].any? { |string| string.downcase.include?(t) } } }

      @invite.circle_id = Invite::TYPES[menu.last][:id] if menu.size > 0 && @invite.circle_id.nil? # default selection
      @invite.user_email = params[:users] if params[:users] && params[:users].match(/@{1}/)
    end

    # Build the list of circles @user can invite @invitee into (e.g. NOT circles @invitee is already in or invited to, or further)
    available_types = menu.collect { |key| [@user.circle_name(Invite::TYPES[key][:id]), Invite::TYPES[key][:id]] }
    available_types.each do |menu_item|
      menu_type_name = menu_item[0] + " "
      @available_types << [menu_type_name, menu_item[1]]
    end
  end

  include ContactsImport

end
