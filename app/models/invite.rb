# == Schema Information
# Schema version: 20081006211752
#
# Table name: invites
#
#  id                    :integer(11)     not null, primary key
#  inviter_id            :integer(11)
#  user_id               :integer(11)
#  user_email            :string(255)
#  created_at            :datetime        not null
#  created_by_id         :integer(11)     default(0), not null
#  invitation            :text
#  activation_code       :string(40)
#  accepted_at           :datetime
#  display_name          :string(255)
#  role_name             :string(255)
#  circle_id             :integer(11)
#  updated_at            :datetime
#  reinvited_at          :datetime
#  rejected_at           :datetime
#  price                 :decimal(10, 2)
#  privacylevel          :integer(4)      default(0), not null
#  free                  :boolean(1)
#  from_lj               :boolean(1)
#  state                 :string(255)     default("pending")
#  album_contribution_id :integer(11)
#
class Invite < ActiveRecord::Base
  include AASM
  # Note: invites may be destroyed without callbacks if inviting user is deleted.

  attr_accessor :skip_messages, :killme, :locale
  acts_as_permitted
  xss_terminate :except => [:invitation]
      
  TYPES = {
      :founder_circle =>    {:id => 0}, 
      :family_circle =>     {:id => 1}, 
      :inner_circle =>      {:id => 2}, 
      :friends_circle =>    {:id => 3}, 
      :partners_circle =>   {:id => 4}, 
      :observers_circle =>  {:id => 5}, 
      :site_invite =>       {:id => 6}
  }


  # Shouldn't ever need to access revoked invites, but we don't want to remove them from the db because e.g. activities depend on them
  with_scope(:find => {:conditions => ['state <> ?', 'revoked']}) do
    named_scope :today,         lambda { { :conditions => ['created_at > ?', 1.day.ago] } }
    named_scope :pending,       :conditions => ['state=? or state=?', 'pending', 'reinvited']
    named_scope :accepted,      :conditions => ['state=?', 'accepted']
    named_scope :rejected,      :conditions => ['state=?', 'rejected']
    named_scope :reinvited,     :conditions => ['state=?', 'reinvited']  
    named_scope :followers,     :conditions => ['circle_id in (?)', Relationshiptype.follower_types]
    named_scope :founders,      :conditions => ['circle_id = ?', Relationshiptype.founders]
    named_scope :network,       :conditions => ['circle_id=?', Invite::TYPES[:site_invite][:id]]
    named_scope :only_circles,  lambda {|cid| {:conditions => ['circle_id in (?)', cid]}}
    named_scope :sent_to,       lambda {|u| {:conditions => ['user_id=?', u.is_a?(User) ? u.id : u]}}
    named_scope :ordered,       :order => 'created_at desc'
  end
  named_scope :current, :conditions => ['state <> ?', 'revoked']
  
  aasm_column :state
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :accepted,  :enter => :do_accept
  aasm_state :rejected,  :enter => :do_reject
  aasm_state :reinvited, :enter => :do_reinvite
  aasm_state :revoked

  # In any way no longer current (e.g. deleted by inviter). Appropriate message must be sent in controller, not here
  aasm_state :revoked,   :enter => :remove_related_activities

  aasm_event :reject do
    transitions :from => [:pending, :reinvited], :to => :rejected
  end

  aasm_event :accept do
    transitions :from => [:pending, :reinvited], :to => :accepted
  end

  aasm_event :reinvite do
    transitions :from => [:pending, :rejected], :to => :reinvited
  end
  
  aasm_event :revoke do
    transitions :from => [:pending, :reinvited, :accepted, :rejected], :to => :revoked
  end

  def do_accept
    @accepted = true
    Invite.transaction do
      update_attributes(:accepted_at => Time.current)

      unless site_invite?
        # Sets expiration date on relationship if invite is paid
        expires_at = self.is_paid? ? 1.month.from_now : Time.end
        Relationship.create_kroogi_relationship(:invite => self, :expires_at => expires_at,
                                    :privacylevel => self.privacylevel, :skip_activity_message => self.skip_messages)
        InviteRequest.clear_pending(self.user, self.inviter)
      end
      if self.needs_link_to_download
        content = Content.find_by_id(self.needs_link_to_download)
        Activity.send_message(content, self.user, :content_download_link_given) if content
      end
      Activity.send_message(self, self.user, :invite_accepted, {:to_user => self.inviter})
    end
  end

  def do_reject
    @rejected = true
    update_attributes(:rejected_at => Time.now.utc)


    Activity.delete_all ['id in (?)', Activity.except([:invite_reinvited, :invite_sent]).for_content(self).map(&:id)]
    Activity.send_message(self, self.user, :invite_denied)
    InviteRequest.clear_pending(self.user, self.inviter)
  end
  
  def do_reinvite
    @reinvited = true
    update_attributes(:reinvited_at => Time.now.utc)
    Activity.delete_all ['id in (?)', activities.map(&:id)]
    Activity.send_message(self, self.inviter, :invite_reinvited)
    InviteRequest.clear_pending(self.user, self.inviter)
  end

  def update_privacy(is_private = nil)
    unless is_private.blank? || self.privacylevel > 0 # don't allow override of already private invite
      update_attributes(:privacylevel => is_private)
    end
  end



        
    MENU_PROJECT = [:founder_circle, :family_circle, :inner_circle, :friends_circle, :partners_circle, :observers_circle]
    MENU_USER = [:family_circle, :inner_circle, :friends_circle, :partners_circle, :observers_circle]
    MENU_LTD = [:family_circle, :inner_circle, :friends_circle, :partners_circle]
    
    def self.menu_for(user, include_founder = false)
      menu = user.circles(:just_ids => true, :without_interested => true).collect {|id| name_from_id(id)}.compact
      (user.project? && include_founder) ? Invite.menu_founder + menu : menu
    end
    
    def self.menu_founder
      [:founder_circle]
    end
    
    def self.name_from_id(id)
      id = id.is_a?(Array) ? id.first : id
      Invite::TYPES.select {|x,y| y[:id] == id }.first.try(:first)
    end
    
    def self.valid_circle_id?(cid, opts = {})
      all_valid_ids = TYPES.collect{|k,v| v[:id]}
      all_valid_ids -= TYPES[:site_invite][:id] unless opts[:include_site_invite]
      all_valid_ids.include?(cid.to_i)
    end
    
    belongs_to :user
    alias_method :to_user, :user
    
    belongs_to :inviter, :class_name => 'User', :foreign_key => "inviter_id"
    alias_method :from_user, :inviter
    
    def circle
      if inviter.project? && self.circle_id == 0
        return UserKroog.get_by_user_and_circle(self.inviter, 0)
      end
      inviter.circles.detect{|x| x.relationshiptype_id == self.circle_id}
    end

    def site_invite?
      circle_id == TYPES[:site_invite]
    end

    before_create :make_activation_code, :handle_amounts, :associate_with_request
    after_create :remove_if_not_needed
    before_destroy :break_relationship, :remove_related_activities
    has_many :activities, :class_name => 'Activity', :foreign_key => :content_id, :conditions => 'content_type="Invite"'


    has_one :donation_setting, :as => :accountable, :dependent => :destroy
    include DonationSettingMethods
    
    validates_presence_of     :circle_id
    validates_presence_of     :user_email, :if => :email_required
    validates_format_of       :user_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :if => :email_required, :message=>"appears to be invalid"
    validates_length_of       :user_email, :within => 3..100, :if => :email_required

    attr_accessor :email_required
    
    def handle_amounts
      return true if self.circle_id == Invite::TYPES[:site_invite][:id] || self.circle.nil?

      if self.free.nil?
        %w(amount_usd amount_wme amount_wmr).each{|am| send("#{am}=", circle.try(am)) }
      else
        clear_amounts
      end
      true
    end
    
    # instance attribute methods

    # check if invite is marked as free, or has no money amount associated with it
    def is_paid?
      false
    end
        
    # DIE upon public launch
    # ------------------->
    def in_rainbows_album
      @in_rainbows_album ||= FolderWithDownloadables.active.find_by_id(self.album_contribution_id)
    end

    def in_rainbows_purchase?
      !album_contribution_id.nil?
    end    
    # <------------------
    
    def self.new_for_mail(options, user, locale = nil)
      locale ||= I18n.locale
      returning Invite.new(options) do |i|
        i.inviter_id = user.id
        i.locale = locale
        i.email_required = true
        i.free ||= user.kroogi_settings.select{|setting| setting.relationshiptype_id.to_i == i.circle_id.to_i}.empty?
      end
    end

    def self.guest_to_user_circle(params, locale)
      returning Invite.new(params) do |i|
        i.locale = locale
        i.email_required = true
        i.free = true
        i.circle_id = TYPES[:observers_circle][:id]
      end
    end

    # -------
    # Actions
    # -------
    
    # find the releationship in the db
    def relationship
      Relationship.find(:first, :conditions => {:user_id => self.inviter_id, :related_user_id => self.user_id, :related_entity_id => self.id, :relationshiptype_id => self.circle_id})
    end
    
    # renew an expired/expiring relationship
    def renew_relationship
      time_left = relationship.expire_date - Time.now if relationship.expire_date > Time.now
      new_expire_date = Time.now + (time_left || 0)
      relationship.expire_date = new_expire_date
      relationship.save!
    end
    
    # Clear out older inconsistencies (like multiple invitations)
    def self.ensure_consistent
      sorted = Invite.find(:all, :order => 'user_id ASC, inviter_id ASC, created_at ASC')
      
      delete_ids = [] # Not sure if this is necessary, but it works and not worth testing without
      sorted.each_with_index do |curr, index|
        break if index+1 == sorted.size
        next if delete_ids.include?(curr.id)
        nxt = sorted[index+1]
        if curr.user_id == nxt.user_id && curr.inviter_id == nxt.inviter_id
          delete_ids << curr.id
        end
      end
      Invite.destroy(delete_ids)     
    end
    
    # Clear out all other invitations THAT ARE EQUAL TO OR FURTHER AWAY in distance
    def clear_other_invitations
      self.user.invites.invites_to(self.circle ? self.circle : self.from_user).scoped(:conditions => ['id <>?', self.id]).each {|x| x.revoke! unless x.revoked?}
    end
        
    # -------
    # helpers that tell you things
    # -------

    # Return the activities who have this invite as their content
    def activities(type = nil)
      conditions = {:content_id => self.id, :content_type => self.class.to_s}
      conditions.merge!({:activity_type_id => Activity::ACTIVITIES[type][:id]}) if type
      
      Activity.find(:all, :conditions => conditions)
    end

    # Tells if this invite can be deleted, like last project founder can't be.
    # UPDATE: only matters if removing last founder -- you can remove last INVITE all you want.
    def can_delete?
      return true
    end
    
    def recently_reinvited?
      @reinvited
    end
    
    # If we have an invitation to query directly, we have to give it less (can override context if desired).
    def circle_name
      return 'Kroogi' if self.circle_id == Invite::TYPES[:site_invite][:id]
      inviter.circle_name(self.circle_id)
    end
    
    # Given params from InviteController#send_invites (namely, a to_invite string), send the invites to provided emails and users
    # Return an array of all invites sent
    def self.send_invites(params, from_user)
      
      # Categorize the params (who to invite) as either emails or users
      (emails, user_ids) = send_invites__categorize_what_to_send(params[:to_invite], params[:circle_id].to_i, from_user)

      # Send invites to emails... but if that email is already used, skip it and add it to the list of user_ids
      (new_user_ids, email_invites_sent) = send_invites__do_email_invites(emails, from_user, params[:locale],
                                                                          params[:circle_id].to_i,
                                                                          params[:invitation_text])

      # Send invites to users -- MUST come after email invites, b/c some emails end up being users
      user_invites_sent = send_invites__do_user_invites(user_ids + new_user_ids, params, from_user)

      return (email_invites_sent + user_invites_sent)
    end

    def locale
      #@locale can't be more right than this
      result = user.email_locale if user
      result ||= @locale
      result ||= I18n.locale
      result
    end

    def put_link_to_download(content_id)
      self.update_attribute(:needs_link_to_download, content_id)
    end

    protected
    
    # Categorize the received things to invite into users, emails, or unknown
    def self.send_invites__categorize_what_to_send(to_invite, circle_id, user)
      emails = []; user_ids = []; leftovers = []

      # See who has already been invited to this circle, or closer
      invited_emails = user.invites_i_sent.pending.only_circles(Relationshiptype.circle_and_closer(circle_id)).select{|x| x.user_id.blank?}.collect{|x| x.user_email}

      to_invite.each do |p|
        # If it's a user...
        uid_attempt = p.scan(/uid:(\d+)/).first
        unless uid_attempt.nil? 
          user_ids << uid_attempt.first.to_i
          next
        end

        # Else if it's an email...
        if p.match( User::EMAIL_REGEX )
          next if invited_emails.include?(p)
          emails << p
          next
        end

        # Else... who knows?
        leftovers << p
      end

      # If anything we don't understand, tell the admins so they can improve the form in the future
      unless leftovers.blank?
        AdminNotifier.async_deliver_alert("send_invites in invite_controller was asked to invite some people, and there are some that it can't place as emails or as users: #{leftovers.to_sentence}")
      end

      return emails, user_ids
    end
    
    
    # Send invites to emails... but if that email is already used, skip it and add it to the list of user_ids. 
    # Also returns number of invites sent, so we can show user error if none were sent
    def self.send_invites__do_email_invites(emails, from_user, locale, circle_id, invitation_text)
      free = true
      user_ids = []; invites_sent = [];

      # Process emails
      emails.uniq.each do |email|
        # If the email matches an existing user, send them a normal invite through the site
        if this_user = User.active.find_by_email(email)
          user_ids << this_user.id
          next
        end

        # Send email invite
        Locale.with_locale(locale) do
          invite = Invite.new_for_mail({:free => free, :user_email => email,
                                        :circle_id => circle_id,
                                        :invitation => invitation_text},
                                       from_user)
          invite.save!
          invites_sent << invite
        end
      end

      return user_ids, invites_sent
    end

    # Send invites to users, and return those sent to the calling method
    def self.send_invites__do_user_invites(user_ids, params, user)
      return [] if user_ids.blank?
      invites_sent = []

      if params[:circle_id].to_i == Invite::TYPES[:founder_circle][:id]
        users = User.active.all(:conditions => {:id => user_ids.uniq})
      else
        users = user.followers.active.all(:conditions => {:id => user_ids.uniq})
      end

      users.each do |target_user|
        # Check for invitability
        if params[:circle_id].to_i == Invite::TYPES[:founder_circle][:id]
          if target_user.project?
            flash[:warning] = 'Projects cannot be members of other projects'.t
            next
          end

          unless user.project?
            flash[:warning] = 'You can be a member of a project, but not of another user'.t
            next
          end
        end


        prev_invites = target_user.invites.invites_to(user).pending
        unless prev_invites.blank?
          # If previous invites to closer circles, disallow this invite
          if prev = prev_invites.select{|i| i.circle_id <= params[:circle_id].to_i}.sort_by(&:circle_id).first
            next
          else # If previous invites to further circles, mark them resolved (without messages) and move forward with the current
            prev_invites.select{|i| i.circle_id > params[:circle_id].to_i}.each {|x| x.revoke!}
          end
        end

        # Send user invite
        invite = Invite.new({
          :user_id => target_user.id, 
          :display_name => target_user.display_name, 
          :inviter_id => user.id, 
          :privacylevel => params[:privacylevel] || 0,
          :invitation => params[:invitation_text],
          :free => params[:free],
          :circle_id => params[:circle_id].to_i
        })
        unless invite.killme
          invite.save!
          Activity.send_message(invite, user, :invite_sent)

          invites_sent << invite
        end
      end

      return invites_sent
    end
    
    
    
    def validate
      if self.circle_id == Invite::TYPES[:founder_circle][:id] 
        if self.user && self.user.project?
          errors.add_to_base "Projects can't be members of other projects".t
        end
        unless self.inviter.project?
          errors.add_to_base "Projects can have members, but not users".t
        end
      end
    end

    def make_activation_code
      return if activation_code #already set
      return if accepted_at #no sense
      return if user_id #no need
      self.activation_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by{rand}.join )
    end
        
    def break_relationship
      Relationship.downgrade_kroogi_relationship(:invite => self)
    end

    # Remove all messages except the cancelled, revoked, deleted, or otherwise relationship-is-now-broken
    def remove_related_activities
      activity_ids = activities.map(&:id)
      Activity.delete_all ['id in (?) and activity_type_id not in (?)', activity_ids, Activity.id_group(:invite_handled)]
    end
    
    # Remove all messages
    def remove_all_related_activities
      activity_ids = activities.map(&:id)
      Activity.delete_all ['id in (?) and activity_type_id in (?)', activity_ids, Activity.id_group(:invites)]
    end
    
    # Before creating, accept any matching invite requests to keep state consistent 
    # (can't send invite from request, so must accept request from invite)
    def associate_with_request
      requests = InviteRequest.pending.all(:conditions => ['user_id = ? AND wants_to_join_id = ? AND (circle_id IS NULL OR circle_id >= ?)', user_id, inviter_id, circle_id])
      return true if requests.empty?

      requests.each do |request|
        begin
          request.accept! unless request.accepted?
        rescue AASM::InvalidTransition => e
          log.error "couldn't accept request %s: %s" % [request.inspect, e.inspect]
        end
      end

      # Can't send message directly regarding invite -- invite's about to disappear
      Activity.send_message(self.circle, self.inviter, :getcloser_granted, {:to_user => self.user})

      # If invite was requested and circle is free, accept it immediately (without creating an invite)
        
      Relationship.create_kroogi_relationship(:invite => self, :expires_at => Time.end, :privacylevel => self.privacylevel, :skip_activity_message => true)
      InviteRequest.clear_pending(self.user, self.inviter)

      # Don't create this invite -- accepted them directly instead
      # would like to return false and not create invite at all, but that raises exception. setting killme to true, instead, this object will be reaped after create
      @killme = true
    end

    # See end of associate_with_request for when/why this would ever be used
    def remove_if_not_needed
      # Not destroy -- no callbacks!
     Invite.delete_all({:id => self.id}) if @killme
    end

end
