class KroogiController < ApplicationController

  # TODO: OPEN SYSTEM requires slight action here
  before_filter :login_required
  # before_filter :login_required, :except => [:show]

  before_filter :load_user, :except => [:remove, :remove_me]

  with_options(:if => proc{|c| c.send(:use_cache?)},
               :cache_path => proc{|c| c.cache_key_with_locale(c.params[:page] || 1, c.params[:sort], c.setpagesize,
                                                               c.params[:type], c.params[:action])}) do |c|

    c.caches_action :show, :expires_in => 15.minutes
    c.caches_action :show_pending, :expires_in => 30.minutes
  end

  def join_circles
    @user = User.find_by_id(params[:id])
    @user = nil unless @user && @user.active?
  end

  def privatewall
    show

    # Adding privatewall security - don't show unless I own the project, or I am in circle X or closer
    unless current_actor.is_self_or_owner?(@user) # I own the project
      valid_circle_types = Relationshiptype.circle_and_closer(@kroog.relationshiptype_id)
      all_matching_followers = Relationship.find_followers(@kroog.user, valid_circle_types)
      unless all_matching_followers.include?(current_actor) # I am in given circle or closer
        flash[:warning] = "You are not permitted to view that content".t
        redirect_to user_kroogs_path(@user)
      end
    end
  end

  def show_pending
    show(:pending => true)
    render :action => 'show'
  end

  def show(options = {})
    if @user.nil?
      raise Kroogi::NotFound
    end

    @tab = :followers
    @kroog = nil
    if !params[:type].blank? && (@user.has_circle?(params[:type]) || (@user.project? && params[:type] == '0'))
      @kroog = @user.circle(params[:type])
    end

    @menu = Invite.menu_for(@user)

    #followers types
    type = params[:type].blank? ? Relationshiptype.follower_types : [params[:type]]

    @network_invite_count = @user.invites_i_sent.network.pending.count
    @page_sizes = [6, 12, 36, 60]
    per_page = getpagesize(@page_sizes[1], :session_key => PageSize::Keys::FOLLOWERS)
    if options[:pending] && permitted?(@user, :profile_edit)
      # Viewing pending relationships (i.e. invites to this circle)
      order = 'invites.created_at DESC'
      @followers = @user.invites_i_sent.only_circles(type).pending.
              paginate :order => order,
                       :per_page => per_page,
                       :page => params[:page]
      @follower_count = @user.followers_and_founders.in_circles(type).count
    else # we are in regular relationships viewing mode
      order = 'users.login ASC'
      @followers = @user.followers_and_founders.in_circles(type).paginate(:order => order, :per_page => per_page, :page => params[:page])
      @follower_count = @followers.total_entries
    end
    @invited_count = @user.invites_i_sent.only_circles(type).pending.count
  end

  def remove_me
    unwanted = current_actor
    owner = User.find_by_login(user_subdomain) || User.find_by_id(params[:id])
    kroog = owner.find_circle_with(unwanted, :founders => true)
    raise Kroogi::NotPermitted if unwanted.blank? || kroog.blank?

    do_user_removal(owner, unwanted, kroog)
  end

  def remove
    owner = User.find_by_login(user_subdomain) || current_actor
    unwanted = User.find_by_id(params[:id])
    raise Kroogi::NotPermitted if unwanted.blank?

    kroog = owner.find_circle_with(unwanted, :founders => true)
    raise Kroogi::NotPermitted if kroog.blank? || kroog && kroog.interested?

    do_user_removal(owner, unwanted, kroog)
  end

  protected

  # Remove the user, revoke the invites
  def do_user_removal(owner, exfollower, kroog)
    raise "Insufficient information specified in params".t unless kroog
    raise Kroogi::NotPermitted unless permitted?(owner, :profile_edit) && exfollower != current_actor || exfollower == current_actor

    Invite.transaction do
      # If kicking user out of founders, don't let them keep acting as founder, and remove email tracking
      if kroog.founders?
        exfollower.update_attribute(:on_behalf_id, 0) if exfollower.on_behalf_id == owner.id
        owner.people_tracking_me.email_delivery.select{|t| t.tracking_user == exfollower}.each{|t| t.destroy}
      end

      # If there happens to be a related invite, revoke it now
      if invite = owner.invites.invites_to(kroog).detect{|x| x.user == exfollower}
        invite.revoke!
      end

      # OK, let's break the actual relationship
      flash[:success] = Relationship.downgrade_kroogi_relationship(:follower => exfollower, :followed => owner, :kroog => kroog, :current_actor => current_actor)
    end

    if kroog.founders?
      redirect_to :controller => '/user', :action => 'founders', :id => owner
    else
      redirect_to user_kroogs_path(owner.id, :type => kroog.circle_id)
    end
  end

end
