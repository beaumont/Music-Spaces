# == Schema Information
# Schema version: 20081224151519
#
# Table name: users
#
#  id                        :integer(11)     not null, primary key
#  login                     :string(30)      not null
#  display_name              :string(255)
#  email                     :string(255)     not null
#  crypted_password          :string(60)      not null
#  salt                      :string(60)
#  created_at                :datetime        not null
#  updated_at                :datetime        not null
#  created_by_id             :integer(11)     default(1), not null
#  updated_by_id             :integer(11)     default(1), not null
#  remember_token            :string(255)
#  remember_token_expires_at :datetime
#  activation_code           :string(40)
#  activated_at              :datetime
#  type                      :string(10)      default("User"), not null
#  on_behalf_id              :integer(11)     default(0), not null
#  state                     :string(255)     default("active")
#  state_changed_at          :datetime
#  display_name_ru           :string(255)
#  display_name_fr           :string(255)
#  is_private                :boolean(1)
#  email_verified            :string(255)


#
# TODO: Mixins for any non user specific code.
#
require 'digest/sha1'

class User < ActiveRecord::Base
  include AASM
  @@kroogi_devs_cache = []
  #skip_caching
  acts_as_favorite_user
  acts_as_favorite
  acts_as_voter
  acts_as_permitted

  translates :display_name, :base_as_default => true
  
  password_required_for :email

  SID_STUB = 'stub'
  ANONYMOUS_ID = 1
  DEFAULT_BIRTHDATE = '1674-01-01'
  WALL_TAB_INDEX = 0
  NOTES_TAB_INDEX = 1
  DEFAULT_WALL_NOTES_INDEX = WALL_TAB_INDEX
  CHECKED_LAST_POSTS_FOR_WALL_NOTES_TAB = 5
  MAX_FOLLOWED = 1000

  # --------------------------
  # Associations
  # --------------------------
  
  # roles that this user has
  has_and_belongs_to_many :roles, :conditions => "roles.status = 1", :order => "roles.name"

  has_many :user_address_book_items #emails taken from user`s addrbook

  def moderation_events
    Moderation::Event.for_users(self.id)
  end
  
  has_one     :profile
  belongs_to  :on_behalf, :class_name => "User", :foreign_key => 'on_behalf_id', :validate => false
  has_one     :preference       # config stuff
  has_one     :account_setting, :validate => false  # money stuff
  has_one     :livejournal_account, :class_name => 'Account'
  has_many    :karma_points, :foreign_key => 'referrer_id'
  has_many    :monetary_donations, :foreign_key => "sender_id", :order => "monetary_transactions.created_at DESC", :validate => false
  has_many    :kroogi_settings, :class_name => "UserKroog" do
    def kind(type_id)
      find(:first, :conditions => ['relationshiptype_id=?', type_id])
    end
    
    def find_or_build_by_relationship_id(relid)
      find_by_relationshiptype_id(relid) || build(:relationshiptype_id => relid, :user_id => proxy_owner.id)
    end
    
  end  

  #TODO: rename this to smth like :showcase_contents
  has_many :contents, :order => 'contents.created_at DESC', :conditions => "contents.type NOT IN ('Inbox', " +
    "'Bundle', 'ImageThumbnail', 'Pvtmessage', 'MusicContest')"

  has_many :all_contents, :class_name => 'Content', :order => 'contents.created_at DESC'

  # Only used for indexing User.music_albums relationship as now.
  has_many :music_albums

  # Need to stick these somewhere, and since we're not supposed to use contents association I can't use it as a proxy
  def image_count
    Image.active.count(:conditions => {:parent_id => nil, :user_id => self.id, :is_in_gallery => true})
  end
  
  def text_count
    Textentry.active.count(:conditions => {:user_id => self.id, :is_in_gallery => true})
  end
  def track_count
    Track.active.count(:conditions => {:user_id => self.id, :is_in_gallery => true})
  end

  # i.e. shared albums
  has_many :inboxes do
    def viewable
      self.select{|x| x.is_view_permitted?}
    end
  end

  has_many :relationships, :foreign_key => 'user_id', :conditions => 'expires_at > CURDATE()'
  has_many :relationships_with_users, :class_name => 'Relationship', :foreign_key => 'user_id', :include => :related_user
  
  has_many :followers_and_founders, :through => :relationships, :source => :related_user do
    def in_circles(c)
      c = [c] unless c.is_a?(Array)
      cids = c.collect {|x| x.is_a?(UserKroog) ? x.relationshiptype_id : x.to_i}
      self.scoped(:conditions => ['relationships.relationshiptype_id in (?)', cids])
    end
  end

  has_many :all_related, :through => :relationships, :source => :related_user do
    def in_circle_or_closer(circle_id, opts = {})
      self.scoped(:conditions => ['relationships.relationshiptype_id in (?)', Relationshiptype.circle_and_closer(circle_id)])
    end
  end

  has_many :followers, :through => :relationships, :source => :related_user,
    :conditions => ['relationships.relationshiptype_id in (?)', Relationshiptype.follower_types]
  has_many :founders,  :through => :relationships, :source => :related_user,
    :conditions => ['relationships.relationshiptype_id=?', Relationshiptype.founders]
  

  ### Tracking ###

  # Email trackers, etc. Later to be used for monitoring content streams.
  has_many :things_i_track, :class_name => 'Tracking', :foreign_key => :tracking_user_id
  has_many :people_tracking_me, :class_name => 'Tracking', :as => 'tracked_item' do
    def users
      self.map(&:tracking_user_id).uniq.map{|x| User.find_by_id(x)}.compact
    end
  end

  has_one :password_reset
  has_many :flashes, :class_name => 'UserFlash'

  delegate :identity_verified?, :to => :account_setting

  #just for view interaction
  attr_accessor :project_to_follow
  attr_accessor :start_following
  attr_accessor :is_artist
  attr_accessor :artist_kind
  attr_accessor :content_to_like
  attr_accessor :created_on_event

  has_many :blocked_users, :class_name => "BlockedUser", :foreign_key => :blocked_by_id

  def self.default_upload_quota_mb
    1024 #1 gigabyte
  end

  def initialize(attributes = {})
    super((attributes || {}).reverse_merge(:upload_quota_mb => self.class.default_upload_quota_mb))
  end
  
  def founders_and_self
    founders + [self]
  end
  
  def messages_today
    activities.only( Activity.type_group(:private_feed) ).today
  end

  def unread_messages
    activities.only( Activity.type_group(:private_feed) ).not_from( self ).unread
  end

  # Count of unread messages and pending invites -- shown in personal bar by Messages link
  def unread_message_count
    Rails.cache.fetch(unread_message_count_key, :expires_in => 5.minutes) do
      invites_requested_of_me.pending.count + invites.pending.count + unread_messages.count
    end
  end

  def clear_unread_message_count_cache
    Rails.cache.delete(unread_message_count_key)    
  end
  
  def featured_album
    self.find_or_create_featured_album
  end
  
  # this is to display the friend list nicely in json
  class JsonUser
    def initialize(*args)
      @id, @login, @display_name, @circle_name = args
      @login_safe = @login
    end
    attr_accessor :id, :login, :display_name, :circle_name
  end
  
  # json friends list
  def friend_list
    Rails.cache.fetch(friend_list_key) do
      Relationship.find_followed_by(self, Relationshiptype.all_valid, {:order => 'users.login'}).collect do |friend| 
        circ = friend.find_circle_with(self)
        JsonUser.new(friend.id, friend.login, friend.display_name, circ.name) if circ
      end.compact.to_json
    end
  end
  
  
  ### Invite ###

  has_many :invites, :class_name => 'Invite', :order => 'created_at desc' do
    def invites_to(thing)
      if thing.is_a?(User)
        self.scoped(:conditions => {:inviter_id => thing.id})
      elsif thing.is_a?(UserKroog)
        self.scoped(:conditions => {:inviter_id => thing.user.id, :circle_id => thing.relationshiptype_id})
      else raise "Can only be invited to a user or a specific circle"
      end
    end
  end
  
  # Am I invited to the given user and/or circle?
  def invited_to?(thing)
    invites.invites_to(thing).pending.first
  end
  
  has_many :invites_i_sent, :class_name => 'Invite', :order => 'created_at desc', :foreign_key => :inviter_id

  ### InviteRequest ###

  # Other people want to join my circles
  has_many :invites_requested_of_me, :class_name => 'InviteRequest', :foreign_key => 'wants_to_join_id'
  
  # I want to join other peoples' circles
  has_many :invites_i_requested, :class_name => 'InviteRequest', :foreign_key => 'user_id'
  
  ### Activity ###
  has_many :activities do
    def not_from_me
      self.scoped(:conditions => ['from_user_id is null or from_user_id <> ?', self.id])
    end
    def with_viewable_content
      self.select do |x|
        result = x.content_is_viewable?
        log.debug "activity #{x.id}: content_is_viewable? is #{result}"
        result
      end
    end
  end
  has_many :activities_i_caused, :class_name => 'Activity', :foreign_key => :from_user_id

  ### Impact ###
  has_many :impacts_on_downloads, :class_name => 'ImpactCounter',
    :conditions => ['counter_kind_id = ?', ImpactCounter::COUNTER_KINDS[:download]],
    :foreign_key => :user_id

  has_many :impacts_on_donations, :class_name => 'ImpactCounter',
    :conditions => ['counter_kind_id = ?', ImpactCounter::COUNTER_KINDS[:donate]],
    :foreign_key => :user_id

  has_one :rare_user_settings
  has_one :fb_details, :class_name => 'Facebook::UserDetails', :foreign_key => 'user_id', :dependent => :delete
  has_many :fb_friends, :class_name => 'FbFriend', :foreign_key => 'user_id'

  def public_questions
    PublicQuestion.with_user(self).published
  end
  
  # Sphinx Index
  define_index do
    # fields
    indexes [:display_name, :display_name_ru, :display_name_fr], :as => :display_name_all , :sortable => true
    indexes :login
    indexes [music_albums.artist, music_albums.artist_ru, music_albums.artist_fr], :as => :music_albums_artist_all
    indexes profile.tags.name, :as=>:tag_names
    
    # attributes
    has :created_at
    where "!private and users.state = 'active'"

  end

  # --------------------------
  # Callbacks
  # --------------------------

  before_create :make_activation_code
  before_save :encrypt_password, :set_display_name
  after_save :invalidate_cache

  def after_create
    self.create_account_setting if self.account_setting.nil?
    if self.preference.nil?
      self.create_preference
    else
      if preference.new?
        preference.user_id = self.id
        preference.save!
      end
    end
    init_circles
    # Inbox.create_default_for(self)
  end
  
  def email_verified?
    self['email_verified'] && self['email_verified'] == self.email
  end
  
  def invalidate_cache
    # expire find_by_id cache
    # expire_cache
    # very important, each custom finder that was ever cached must have a corresponding invalidation here
    # this one is for:  User.cached(:find_by_login, :with => loginname)
    # User.expire_cache("find_by_login:#{self.login.downcase}")
  end
  
  # -------------------------
  # Scopes
  # -------------------------
  named_scope :not_project, :conditions => ['type in (?)', %w(BasicUser AdvancedUser)]
  named_scope :by_fb_id, lambda {|fb_id| {:include => :fb_details, 
    :conditions => ["fb_user_details.fb_user_id IN (?) AND fb_user_details.is_fb_connected = 1", fb_id.to_a ]} }
  
  # Activated / not
  named_scope :activated, :conditions => 'activation_code is null'
  named_scope :not_activated, :conditions => 'activation_code is not null'

  # States
  named_scope :active, :conditions => ['state=?', 'active']
  named_scope :blocked, :conditions => ['state=?', 'blocked']
  named_scope :deleted, :conditions => ['state=?', 'deleted']
  named_scope :undeleted, :conditions => ['state !=?', 'deleted']
  named_scope :with_preferences, lambda { { :joins => "JOIN preferences on preferences.user_id = users.id"} }
  named_scope :searchable_by_email, :conditions => 'preferences.email_searchable'
  named_scope :users_first, :order => 'type asc'
  


  # --------------------------
  # Validations
  # --------------------------

  #taken from http://www.rubyonrailsexamples.com/ruby-strings/email-validation-using-ruby/
  EMAIL_REGEX = %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i
  LOGIN_REGEX = /\A[A-Za-z0-9][A-Za-z0-9-]*[A-Za-z0-9]\Z/i

  validates_presence_of     :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 7..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :email, :within => 3..100

  validation_message_13 = lambda do
    '^' + 
    "Please note that this Site is not aimed at users under thirteen (13) years of age.".t + ' ' +
    'Users thirteen (13) years or younger are required to have a parent or guardian review and complete any registration process, which may include age verification steps in addition to the standard process.'.t
  end

  validates_inclusion_of :birthdate,
                         :in => 500.year.ago.to_date..13.year.ago.to_date,
                         :message => validation_message_13,
                         :if => Proc.new {|user| !user.project?},
                         :allow_blank => true
  #example of custom translated message 
  #validates_uniqueness_of   :email, :message => lambda {'^' + 'somebody already sent us this email'.t}

  # Warning - don't use .t here and in validate methods, it screws
  # translations with 'double translation' issue, see
  # https://dev.kroogi.com/trac/krugi/ticket/2041#comment:2 for details
  validates_format_of       :email, :with => EMAIL_REGEX

  # if the user is updating their password make sure valid old_password was passed in
  validates_each :old_password, :on => :update, :if => :password_required? do |user, old_pass, value|
    if value.blank?
      user.errors.add old_pass, 'required to update password.'
    elsif !User.authenticate(user.login, value)
      user.errors.add old_pass, 'is incorrect.'
    end
  end

  
  def validate
    # Manually handle all login validation to prevent "login" from displaying
    #
    if self.login.blank?
      # 'Kroogi name must be provided'.t
      self.errors.add_to_base("Kroogi name must be provided".t)
    end

    if self.birthdate.blank?
      self.errors.add_to_base("Please enter your birthday".t) if !self.project?
    end

    min, max = 2, 30
    self.errors.add_to_base("Kroogi name must be between {{min}} and {{count}} characters" / [min, max] ) if self.login.to_s.size < min || self.login.to_s.size > max
    self.errors.add_to_base("Kroogi name has already been taken".t) if self.new_record? && self.login && User.find_by_login(self.login)
    self.errors.add_to_base("That Kroogi name is not allowed".t) if self.login =~ /^(#{RESERVED})$/i
    self.errors.add_to_base("Kroogi name is invalid - must contain at least one non-numeric character".t) if self.login =~ /^\d+$/
    unless self.login =~ LOGIN_REGEX
      self.errors.add_to_base("Kroogi name has invalid characters - it should only contain A-Z, a-z, 0-9 and - (NOTE: no spaces allowed!). It cannot start or end with -, and must contain at least one non-numeric character.".t)
    end

    # Don't bother with projects -- make those users be banned separately
    if self.new_record? && !self.project?
      if Moderation::Blocked::Email.email_is_blocked?(self.email)
        self.errors.add_to_base("Sorry, this email has been disallowed from creating new accounts".t)
      end
    end

    if !self.project? && !self.deleted?
      msg = "This email is already taken".t
      exist = lambda {User.undeleted.not_project.find_by_email(email)}
      if self.new_record?
        self.errors.add_to_base(msg) if exist.call
      else
        self.errors.add_to_base(msg) if self.email_changed? && exist.call
      end
    end

  end
    
  def index_cache_key
    
  end
  
  def display_type
    # 'Project'.t + 'User'.t #tranny hint
    self.project? ? 'Project' : 'User'
  end

  def title_long
    str = "#{self.login}"
    str += " (#{self.display_name})" unless self.display_name == self.login
    str
  end
  alias_method :title_short, :title_long

  # move these to config table
  RESERVED = "www|ww|ww2|krugi|admin|root|superuser|administrator|shop|store|assets|blog|dev|developer|developers|images|music|songs|mail|list|assets0|assets1|assets2|assets3|upload|uploads|login|signup|register|help|about|info|cc" unless const_defined? :RESERVED

  # Virtual attribute for the unencrypted password
  attr_accessor :password, :old_password, :skip_password_check
  
  
  
  def is_view_permitted?(user_or_actor = nil)
    return false unless self.active?
    
    user_or_actor ||= current_user
    return false if self.private? && !self.allow_access_to_private_user?(user_or_actor)
    true
  end

  # Moderation events for self and all content items...
  def all_moderation_events
    user_ids = projects.map(&:id) + [self.id]
    content_ids = contents.map(&:id)
      
    user_events = Moderation::Event.for_users.find(:all, :conditions => {:reportable_id => user_ids})
    content_events = Moderation::Event.for_content.find(:all, :conditions => {:reportable_id => content_ids})
    (user_events + content_events).sort_by(&:created_at).reverse
  end
    
  # Used to simplify gathering current user stats from the console
  def self.stats
    stat = []
    stat << "Active Users: #{User.activated.active.not_project.count}"
    stat <<  "Active Projects: #{Project.active.count}"
    puts stat.join("\n")
  end
    
  aasm_column :state
  aasm_initial_state :active
  aasm_state :active, :enter => :do_restore
  aasm_state :blocked, :enter => :do_block   # Blocked (banned) from loging into system (and nobody can view user page)
  aasm_state :deleted, :enter => :do_delete  # Deleted entirely - no recovery

  aasm_event :block do
    transitions :from => :active, :to => :blocked
  end

  aasm_event :restore do
    transitions :from => :blocked, :to => :active
  end

  aasm_event :delete do
    transitions :from => [:active, :blocked], :to => :deleted
  end

  def do_restore
    Moderation::Blocked::Email.clear_blocked_user( self )

    # For items that were mass blocked when user was blocked, restore from item without creating a Moderation::Event, so no messages sent and no reasons need to be recorded
    contents.blocked.each do |item|
      next if Moderation::Block.currently_blocked_individually?(item)

      item.restore!
    end
  end

  def do_block(block_email = true)
    if self.project?
      # Kick out anyone acting as this project
      User.update_all 'on_behalf_id = 0', ['on_behalf_id=?', self.id]
      # Note: nobody can assume project now because user.projects filters out non-active users
    end
    # Note: application before filter (ensure_valid_user) kicks out any non-active users who try to view a page
    update_attribute(:state_changed_at, Time.now)
    Moderation::Blocked::Email.add( self ) if block_email # No more accounts with this email address

    featured = self.featured_album
    contents.active.each do |item|
      next if item == featured # Don't block featured album, b/c blocks all items within it... which means all will be restored on do_restore, even if individually blocked
      item.block! # Block from item, without creating a Moderation::Block, so no messages sent and no reasons need to be recorded
    end
  end

  def do_delete
    transaction do
      raise 'User deletion forbidden' if deletion_forbidden?
      do_block(false) if self.active?
      delete_projects_owned_solely_by_me
      assign_deleted_login_name
      prevent_viewing_of_content
      delete_relationships
      delete_invites
      delete_activities
      delete_feed_entries
      delete_collection_inclusions
    end
    update_attribute(:state_changed_at, Time.now)
    if self.project?
      project_founders.each {|f| UserNotifier.enq_deliver_project_deleted(f, self) }
    else
      UserNotifier.async_deliver_account_deleted(self)
    end
  end

  # If this user is marked private, can the given user still see it?
  def allow_access_to_private_user?(accessor_user)
    return false if accessor_user.guest?
      
    if accessor_user.id == self.id ||
        accessor_user.admin? ||
        Relationship.has_follower?(self, accessor_user) ||
            accessor_user.invites.pending.collect{|x| x.from_user}.include?(self)
      return true
    end
      
    return false
  end
  
  # Returns true unless the member is a public founder of this project (e.g. if false, show project on user's hosts page (and vice versa))
  def hide_project_membership?(p)
    return true unless p.project?
    return false if p.private?
    rel = Relationship.locate_me(self, p, Relationshiptype.founders)
    return true if rel && rel.privacylevel.to_i > 0
    false
  end

  # Projects with only one founder -- this user.  Only used in deletion context, deciding and displaying which projects to axe.
  def personal_projects
    projects.select{|p| p.project_founders.size == 1}
  end
    
  def albums(options = {})
    albums = Content.active.all(:conditions => ['user_id = ? AND type IN (?) AND cat_id <> ?', self.id,
          [Album.name, FolderWithDownloadables.name, MusicAlbum.name], Content::CATEGORIES[:featured_album][:id]])
    
    return self.class.prepare_albums_for_menu(albums, options[:content]) if options[:for_menu]
    albums
  end
  
  def self.prepare_albums_for_menu(albums, content_to_include)
    albums = albums.select {|a| a.inclusion_allowed?(content_to_include)}

    paired = albums.collect {|album| [album.album_menu_item_caption, album.id]}

    return paired
  end
  
   
  def self.having_music_albums(*args)
    options = (args.length > 0) ? args.pop : Hash.new
    options[:page]       ||= 1
    options[:include]    = :contents
    options[:conditions] = ["contents.user_id = users.id and contents.type in (?)",
      [FolderWithDownloadables.name, MusicAlbum.name]]
    options[:order]      ||= "display_name"
    args.push options
    self.paginate *args
  end

  def self.having_music_albums_with_bundle(*args)
    options = (args.length > 0) ? args.pop : Hash.new
    options.assert_valid_keys :per_page, :page, :filter, :cumulative

    filter = options[:filter]
    conditions = (filter == "new" || filter == "newest") ? 'created_at' : 'popularity'
    order_by = "ORDER BY c.#{conditions} DESC" if conditions

    group = "GROUP BY users.id"
    group << " HAVING ma_count = 1" if options[:filter] == 'newest'
    
    select = <<-EOSQL
        SELECT users.*, count(c.id) as ma_count FROM users
        INNER JOIN contents c ON c.user_id = users.id AND c.title is not null and c.title != ''
          AND c.type = 'MusicAlbum' AND c.state = 'active' AND c.relationshiptype_id = -2
        INNER JOIN contents bundles ON bundles.downloadable_album_id = c.id AND bundles.type = 'Bundle'
        WHERE users.private = 0
        #{group}
        #{order_by}
    EOSQL
    options[:page]       ||= 1
    options[:include]    = :contents
    args.push options
    self.paginate_by_sql(select, *args)
  end

  def qualify_for_fb
    result = self.identity_verified?
    result &&= self.contents.any? {|c| c.downloadable?}
    result &&= self.public?
    result
  end

  # raw sql query for searching users by tag
  def self.user_tag_search_query(tags, count_only = false)
    tags = [tags] unless tags.is_a?(Array)
    display_name_filter = APP_CONFIG.locales.map do |key|
      field = 'display_name'
      field << "_#{key}" if !APP_CONFIG.default_locale?(key)
      SqlMultiplier.multiply_condition('upper(%s) like :like' % field, ':like', tags)
    end.join(' OR ')
    
    sql = <<-EOSQL
        SELECT #{count_only ? "count(*) AS count_users" : "`users`.*"}  
        FROM `users` 
        WHERE `users`.state = :state AND (#{SqlMultiplier.multiply_condition('upper(`users`.login) like :like', ':like', tags)} or #{display_name_filter}) OR
        `users`.id IN (
        			SELECT DISTINCT `profiles`.user_id
        			FROM 
        				`profiles` 
        				INNER JOIN taggings profiles_taggings ON profiles_taggings.taggable_id = profiles.id AND profiles_taggings.taggable_type = 'Profile' 
        				INNER JOIN tags profiles_tags ON profiles_tags.id = profiles_taggings.tag_id 
        			WHERE #{SqlMultiplier.multiply_condition('upper(profiles_tags.name) like :like', ':like', tags)}
        			)
    EOSQL
    result = [sql, {:state => 'active'}.merge(SqlMultiplier.expand_params(:like, tags.map{|tag| tag.chars.strip.upcase}))]
    result
  end
    
  def self.kroogi
    @kroogi_user ||= User.find_by_login(Kroogi::KROOGI_ACCOUNT)
  end

  def kroogi_account?
    self == self.class.kroogi
  end
  
  # Returns an array of ids to ignore when calculating popular kroogi (all those in kroogi projects, and any projects they own)
  def self.kroogi_devs(refresh = false)
    return @@kroogi_devs_cache if !@@kroogi_devs_cache.blank? && !refresh
    kroogi = self.kroogi
    return [] unless kroogi
    @@kroogi_devs_cache = (kroogi.project_founders + kroogi.project_founders.collect{|f| f.respond_to?(:projects) ? f.projects : nil}).flatten.compact.uniq.collect{|x| x.id}
  end


    
  # If there are other ppl we wan to exclude from the popular list, do it here
  def self.manual_exclude_list
    return [] unless RAILS_ENV == 'production'
    return []
  end
    
  # Return the n of the top most popular active users.
  def self.popular(n=4, options = {})
    conditions = "state = 'active' AND private IS FALSE AND id NOT IN (8, 605, 17137, 12651, 643, 272)"
    if options[:only_languages] == 'en'
      conditions << " and display_name is not null and display_name != ''"
    end
    User.find(:all, :limit => n, :order => "popularity desc", :conditions => conditions)
  end

  def self.update_popularity(since = 1.day.ago)
    # popularity decays 1% per day and increases by relationships added in the last day
    counts = Relationship.count(:group => :user_id, :conditions => ['relationshiptype_id in (0,1,2,3,4,5) and created_at >= ?', since])
    User.update_all("popularity = popularity * 0.9", "popularity > 0")

    counts.group_by {|id, count| count}.each do |count, pairs|
      User.update_all("popularity = popularity + #{count}", ['id in (?)', pairs.map {|id, count| id}])
    end
  end

  def actor
    return self if on_behalf_id == 0
    return self if on_behalf.nil?
    return self if on_behalf_id == self.id
    return on_behalf
  end

  # Users have variable numbers of circles. This returns the circles the user has currently enabled.
  def circles(opts = {})
    rel_ids = preference.active_circle_ids.sort
    rel_ids.reject! {|id| id == Relationshiptype.interested} if opts[:without_interested]
    return rel_ids.map(&:to_i) if opts[:just_ids]

    rel_ids.collect{|x| circle(x) }
  end

  # This returns a user_kroog for all POSSIBLE circles (e.g. enabled or not)
  def all_circles(opts = {})
    result = all_circle_ids 
    return result if opts[:just_ids]
    result.collect {|circle_id| circle(circle_id)}
  end

  def all_circle_ids
    Relationshiptype::all_valid - [0]
  end
    
  def has_circle?(circle_id)
    circles(:just_ids => true).include?(circle_id.to_i)
  end

  def has_open_circles?
    open_circles = circles.detect{|x| x.open?}
    return true if open_circles
  end

  # Returns kroog that's closest to the user (e.g. family unless it's off, else next closest open)
  def closest_circle
    closest = circles(:just_ids => true).sort.first
    return nil unless closest
    circle(closest)
  end

  # Returns OPEN kroog that's furthest to the user (e.g. Interested unless it's off, else next furthest open)
  def furthest_open_circle
    circles.select{|x| x.open?}.sort_by(&:relationshiptype_id).last
  end

  # Return true if there is a closer open circle the user can join
  def has_closer_non_joined_open_circle?(user)
    open_circles = circles.select{|x| x.open? || x.can_request_invite?}.sort_by(&:relationshiptype_id)
    return false unless open_circles
    joined_circle = open_circles.each{|c| c}.detect{|x| x.members_include?(user)}
    return false unless joined_circle
    return true if joined_circle.relationshiptype_id > open_circles.first.relationshiptype_id
  end

  # Returns OPEN or REQUESTABLE kroog that's closest to the user (e.g. family unless it's off, else next closest open)
  def closest_open_circle
    circles.select{|x| x.open? || x.can_request_invite?}.sort_by(&:relationshiptype_id).first
  end

  # Am I already a member of the given user or circle?
  def in_circle?(thing)
    user = thing.is_a?(User) ? thing : thing.user
    types = thing.is_a?(User) ? Relationshiptype.followers_and_founders_types : [thing.relationshiptype_id]
    Relationship.has_follower?(user, self, types)
  end
    

  # Say you know A is in B's circles, but you want to know WHICH circle.
  def find_circle_with(user, opts = {})
    circles.each do |circ|
      return circ if Relationship.has_follower?(self, user, [circ.relationshiptype_id])
    end
    return (UserKroog.first(:conditions => {:user_id => user.id, :relationshiptype_id => Relationshiptype.founders}) ||
            UserKroog.new({:user_id => user.id, :relationshiptype_id => Relationshiptype.founders})) if opts[:founders] && Relationship.has_follower?(self, user, [Relationshiptype.founders])
    return nil
  end

  # Returns the user's name for the given circle
  def circle_name(relationshiptype_id)
    raise "Obsolete call with #{relationshiptype_id}" if relationshiptype_id.is_a?(Symbol)
    relationshiptype_id = relationshiptype_id.to_i
    return '' unless all_circle_ids.include?(relationshiptype_id) || relationshiptype_id == Relationshiptype.founders
    circle(relationshiptype_id).name
  end

  def circle(circle_id)
    UserKroog.get_by_user_and_circle(self, circle_id.to_i)
  end
    
  # Items that are in the user's gallery -- in no other album, except maybe showcase, and viewable
  def gallery_items
    return @cached_gallery unless @cached_gallery.blank?
      
    featured_album = self.featured_album
    contents = self.contents
    @cached_gallery = contents.select do |item|
      item.user = self #for item.calc_in_inbox_by_user_data to use cached result (otherwise it will use AR's
      #  cached SQLs - not very bad, but serialization/some CPU cycles/memory overhead I guess)
      result = item.active?
      result &&= item.can_be_in_gallery?
      result &&= not_in_custom_album?(item)
      result &&= item.id != featured_album.id
      result &&= (item.is_in_gallery? || item.cat_id == Content::CATEGORIES[:userpic][:id])

      #TODO: looks like there's no need to check for inbox inclusion in this context. UI doesn't allow you to
      # specify non-public visibility for content if it's included in some inbox. So some domain-based refactoring
      # needed - this is a hack.
      item.calc_in_inbox_by_user_data
      result &&= item.is_view_permitted?

      result
    end
  end

  def content_inbox_inclusions
    return @content_inbox_inclusions if @content_inbox_inclusions
    @content_inbox_inclusions = {}
    InboxItem.connection.select_rows(%Q{SELECT ii.content_id FROM inbox_items ii inner join contents c ON c.user_id = #{id} AND
        ii.content_id = c.id AND c.type NOT IN ('Inbox', 'Bundle', 'CoverArt', 'ImageThumbnail', 'Pvtmessage')}).each do |content_id_row|
      @content_inbox_inclusions[content_id_row[0].to_i] = true
    end
    @content_inbox_inclusions
  end
  
  def content_album_ids
    return @content_album_ids if @content_album_ids
    @content_album_ids = {}
    sql = %Q{SELECT album_items.* FROM album_items
        INNER JOIN contents as albums ON albums.id = album_items.album_id
        WHERE albums.user_id = #{self.id} AND albums.type in (#{Content::ALBUM_TYPES_SQL})
        AND (albums.cat_id IS NULL OR albums.cat_id != #{Content::CATEGORIES[:featured_album][:id]})
    }
    album_items = AlbumItem.find_by_sql(sql)
    album_items.each do |album_item|
      @content_album_ids[album_item.content_id] = album_item.album_id
    end
    @content_album_ids
  end
  
  def not_in_custom_album?(content)
    !content_album_ids[content.id]
  end

  def has_image?
    (profile && !profile.userpic.nil?)
  end

  def anonymous?
    in_role?(Role::ANON)
  end
    
  # if you change this method then make sure you find where it's used in the app,
  # otherwise you run the risk of a major fuck up.
  def admin?
    in_role?(Role::ADMIN)
  end

  def moderator?
    return in_role?(Role::MODERATOR) || admin?
  end

  # Allow calling current_user.guest?
  def guest?
    false
  end

  # Allow user_or_project.project? to be meaningful
  def project?
    false
  end

  def facebook_user?
    self.is_a?(Facebook::User)
  end

  def kd_user?
    return false unless self.facebook_user?
    self.kroogi_dowload_user? && !self.facebook_connected?
  end

  def basic_user?
    false
  end

  def advanced_user?
    false
  end

  def facebook_connected?
    self.fb_details and self.fb_details.fb_session_key and self.fb_details.is_fb_connected
  end

  def facebook_page?
    self.is_a?(Facebook::Page)
  end

  # Accepts one or more users, returns true if self is == or founder of ANY of the provided users
  def  is_self_or_owner?(*others)
    others.compact.any?{|other| self == other || (other.project? && other.project_founders_include?(self))}
  end

  def  is_child?(other)
   if self != other && self.project? && (!other.project? && self.project_founders_include?(other))
     return true
   else
     return false
   end
  end

  def kroogi_has_messages?(circle_id)
    kroogi = UserKroog.find_by_user_id_and_relationshiptype_id(self.id, circle_id)
    kroogi && kroogi.comment_count(true) > 0
  end

  def last_active_at
    activity = Activity.find(:first, :conditions => {:from_user_id => self.id}, :order => 'created_at desc')
    return self.updated_at if activity.nil?
    return activity.created_at
  end

    
  # ##########################################
  #
  # Relationships
  #
  # ##########################################

  # donations
  def donation_account_set?
    account_setting.has_an_approved_account_set? && account_setting.money_approved?
  end
    
  #
  # Not using self.activities to avoid the order by clause (and mysql filesort)
  #
    
  # checks for donations made to a piece of content
  def has_donated_to_content?(content_item)
    Activity.with_user(self).only(:content_purchased).for_content(content_item).find(:first)
  end

  # checks for downloads for items where donations are not enabled
  def has_downloaded?(content_item)
    Activity.with_user(self).only(:content_downloaded).for_content(content_item).find(:first)
  end

  # Lists projects that this user is a founder of
  #
  # returns
  #  - array of projects
  def projects(options = {})
    # Filters out projects that are blocked or deleted
    @projects_list ||= Relationship.find_followed_by(self, [Relationshiptype.founders], {:limit=>1000}).select{|x| x.active?}
    @projects_list = @projects_list.sort_by {|x| "#{x.collection? ? ' ' : ''}#{x.display_name.chars.downcase}"} if options[:sorted]
    @projects_list.dup
  end
    
  # Filter out projects that aren't allowed to view the given item
  def projects_allowed_to_see(item)
    ([self] + projects).select{|p| item.is_view_permitted?(p)}
  end 
    
  def public?
    !private?
  end
    
  # Says so if and only if that user is a follower (any type) of the other user
  #  - other_user: user to check followship against
  #  - types: array of Relationshiptype types to filter relationships by
  #
  # returns
  #  - true if a follower, false otherwise
  def is_a_follower_of?(followed, types = Relationshiptype.followers_and_founders_types)
    # this should be instance cached by some by king of id-id hash (it gets hit lots)
    follows?(followed, types)
  end


  # Lists users if and only if that user is a follower (any type) of the other user
  #  - other_user: user to check followship against
  #  - types: array of Relationshiptype types to filter relationships by
  #
  # returns
  #  - array of users
  def is_a_follower_of(other_user, types = Relationshiptype.followers_and_founders_types)
    Relationship.select_followed_by(self, other_user, types, {})
  end

  # gets a counter of a desired type(s) of relationships that tthis user has established
  #  - types: array of Relationshiptype types to filter relationships by
  #  - block
  #
  # returns
  #  - array of relationships including a count
  def followers_count(types = Relationshiptype.follower_types, options = {}, &block)
    #options.reverse_merge! :include_empties => true
      
    types = Relationshiptype.followers_and_founders_types if types.blank?
    allowed_types = self.circles(:just_ids => true)
    types = types & allowed_types # Only return allowed types

    if @rel_counts.nil?
      # get count for all and cache it it
      real_relationships = Relationship.count_followers_group(self)
      @rel_counts = []
      Invite::MENU_PROJECT.each do |key|
        relationship = real_relationships.detect{|rel| rel.relationshiptype_id.to_i == Invite::TYPES[key][:id]}
        if relationship.nil?
          @rel_counts << Relationship.new(:relationshiptype_id => Invite::TYPES[key][:id])
        else
          @rel_counts << relationship
        end
      end
      #logger.debug "Relationship counts: #{@rel_counts.inspect}"
    end

    cnt_matched = []
    index = 0
    @rel_counts.each do |item|
      #logger.debug "WTF???? #{item[:relationshiptype_id]} \n#{types.inspect}"
      next unless types.include?(item[:relationshiptype_id].to_i)
      next if !options[:include_empties] && item[:cnt].blank?
      if block_given?
        cnt_matched << yield(item, index)
      else
        cnt_matched << item
      end
      index = index.next
    end
    return cnt_matched

  end


  # gets a counter of a desired type(s) of relationships that are established TO this user
  #  - types: array of Relationshiptype types to filter relationships by
  #
  # returns
  #  - array of relationships including a count
  def followed_by_count(types = Relationshiptype.followers_and_founders_types)
    Relationship.count_followed_by_group(self, types)
  end

    
  # ####################################################

  # Allows a user to be found by their livejournal account username
  def self.find_by_livejournal_username(login)
    account = Account.find_by_login(login, :include => :user, :conditions => {:verified => true})
    return account.user if account
    #return User.find_by_identity_url( login + '.livejournal.com' )
  end

  # Provides livejournal username or nil via lj account or openid identity_url
  def livejournal_name
    if livejournal_account.blank?
      #return identity_url.scan(/(http:\/\/)?(\w+)\.livejournal.com/)[0][1]
      return nil # todo - what should it be? (I'd say blank)
    else
      return livejournal_account.display_name if livejournal_account.verified?
    end
  rescue NoMethodError
    return nil
  end
    
  def default_trannies
    # todo - make those user selectable
    ['en-US', 'ru-RU']
  end

  # TODO - kill me
  def translation
    if @translation.nil?
      @translation = APP_CONFIG.languages
      #@translation = {:login => '', :display_name => ''}
    end
    return @translation
  end

  # TODO - kill me
  def translation=(val)
    @translation = val
  end

  # Query if the user belongs to a given role
  #
  # Example:
  #     is_allowed = user.in_role?(Role::ADMIN)
  #
  def in_role?(role_id)
    return roles_list.select{ |element| element.id == role_id}.size == 1
  end

  def create_password_reset
    reset = password_reset || build_password_reset
    new_passwd = reset.randomize_password!
    reset.save_without_validation!
    new_passwd
  end
  
  def reset_password!
    activate_rightaway unless activated?
    self.crypted_password = password_reset.crypted_password
    self.save_without_validation!
    password_reset.destroy
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = self.find_by_login(login)
    return nil unless u && u.active? 
    if u.password_reset && u.password_reset.authenticated?(password)
      u.reset_password!
    end
    if u.facebook_connected? # a previously created FB connected user does not need a password
       return u
    end
    if u.activated? && u.authenticated?(password)
      u.password_reset.destroy if u.password_reset #user logged in with his old login - so cancel the reset
      u
    end
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save_without_validation
  end

  def forget_me
    self.sid = nil
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save_without_validation
  end

  # Activates the user in the database.
  def activate
    @activated = true
    update_attributes(:activated_at => Time.now.utc, :activation_code => nil)
  end

  def activate_rightaway
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def clear_passwords
    self.password = self.password_confirmation = nil
  end

  def randomize_password!
    self.password = random_alphanum_string(6)
    self.skip_password_check = true
    return self.password
  end

  def password_required?
    return false if skip_password_check
    self.new? || !password.blank?
  end

  # Development helper for console - User.lnkali == User.find_by_login 'kali'
  def self.method_missing(method_name, *args)
    if method_name.to_s.starts_with?('ln')
      login = method_name.to_s.sub('ln', '')
      User.find_by_login(login)
    else
      super
    end
  end
    
  def is_kroogi_dev?
    self.class.kroogi_devs.include?(self.id)
  end

  def activated?
    project? || activation_code.nil?
  end

  def show_new_birthdate?
    self.birthdate_visiblity? && self.birthdate.to_s != DEFAULT_BIRTHDATE
  end
  
  def has_new_birthdate?
    !self.birthdate.nil? && self.birthdate.to_s != DEFAULT_BIRTHDATE
  end

  def collection?
    self.is_a?(CollectionProject)
  end

  def public_activities
    user = self
    user.activities.only(Activity.type_group(:public_feed)).only_from(user).newest_first.top(10).with_viewable_content
  end

  def entity_name_for_human
    self.class.name
  end

  def followers_count_sum(*args)
    followers_count(args).collect{|item| Integer(item[:cnt])}.inject{|sum, item| sum + item}
  end

  def unhide
    self.make_interested_of_children if self.collection?
    self.update_attribute(:private, false)
    self.unhide_owned_children if self.collection?
    if self.project?
      # Don't send the creation message until the project goes public
      Activity.send_message(self, self.current_user, :created_project) if Activity.only(:created_project).for_content(self).empty?
    end
  end

  def welcome_content_languages
    I18n.locale == 'en' ? 'en' : :all
  end

  def projects_have_favorite(favorite, new_projects_set)
    all_projects = [self] + self.projects
    projects.each do |p|
      raise Kroogi::Error('{{project_name}} is not your project' / p.login) unless all_projects.include?(p)
    end
    current_favs = all_projects.select {|u| u.has_favorite?(favorite)}

    (current_favs - new_projects_set).each do |removed_from|
      removed_from.has_no_favorite(favorite)
    end
    
    (new_projects_set - current_favs).each do |added_to|
      added_to.has_favorite(favorite)
      Activity.send_message(favorite, added_to, :added_as_favorite)
    end
  end

  def donatable?
    #TODO: just account_setting.donatable? should be fine 
    account_setting && account_setting.donatable?    
  end
  
  def avatar_path(options = {})
    avatar = profile.avatar if profile
    options[:avatar_size] ||= :small
    if avatar
      thumb = avatar.thumb(options[:avatar_size])
      if thumb.new?
        thumb = avatar.thumb(:small) if options[:avatar_size] == :tiny
        thumb = avatar.thumb(:tiny) if options[:avatar_size] == :small
      end
      thumb.public_filename if thumb && !thumb.new?
    else
      nil
    end
  end

  # returns list of projects and users followed by self
  def followed_projects(options = {})
    Relationship.find_followed_by(self, Relationshiptype.all_valid, options)
  end

  def messages_except_private
    self.activities.displayed.only( Activity.type_group(:private_feed) ).not_from(self).except(:sent_pvtmsg).unread_first
  end

  def private_messages
    self.activities.only(:sent_pvtmsg).unread_first
  end
  
  def email_locale
    result = self.preference.email_locale
    result ||= self.preference.current_locale
    result
  end

  def toggle_rare_setting!(key)
    self.rare_user_settings ||= RareUserSettings.create(:user_id => self.id)
    self.rare_user_settings.toggle!(key)
  end

  def questions_enabled?
    return false unless self.rare_user_settings
    self.rare_user_settings.questions_enabled?
  end

  def questions_interval
    result = (rare_user_settings ? rare_user_settings.questions_interval : nil)
    result ||= PublicQuestion::DEFAULT_INTERVAL if questions_enabled?
    result
  end
  
  def questions_interval_random_delta
    result = (rare_user_settings ? rare_user_settings.questions_interval_random_delta : nil)
    result ||= PublicQuestion::DEFAULT_INTERVAL_RANDOM_DELTA if questions_enabled?
    result
  end

  def update_question_interval_settings(questions_interval, questions_interval_random_delta)
    log.debug "questions_interval, questions_interval_random_delta = #{[questions_interval, questions_interval_random_delta].inspect}"
    return if questions_interval.to_i == self.questions_interval && questions_interval_random_delta.to_i == self.questions_interval_random_delta
    return if questions_interval.to_i == PublicQuestion::DEFAULT_INTERVAL && questions_interval_random_delta.to_i == PublicQuestion::DEFAULT_INTERVAL_RANDOM_DELTA
    return if questions_interval.to_i < 1 || questions_interval_random_delta.to_i < 0
    self.rare_user_settings ||= RareUserSettings.create(:user_id => self.id)
    self.rare_user_settings.update_attributes!(:questions_interval => questions_interval, :questions_interval_random_delta => questions_interval_random_delta)
    AnswerIntervalCounter.update_all('counter = 0', ['artist_id = ?', self.id])
  end

  def change_type!(new_class)
    user = self
    User.transaction do
      id = user.id

      from_class = user.class.name
      to_class = new_class.name
      User.update_all(['type = ?', to_class], ['id = ?', id])

      [[FeaturedItem, 'item_type', 'item_id'],
       [Favorite, 'favorable_type', 'favorable_id'], [Moderation::Event, 'reportable_type', 'reportable_id'],
       [SmsPayload, 'payment_for_type', 'payment_for_id']].each do |klass, type_field, id_field|
        klass.update_all ['%s = ?' % type_field, to_class], ['%s = ? and %s = ?' % [id_field, type_field], id, from_class]
      end

      [Activity, ContentStat, Stat].each do |klass|
        klass.update_all ['content_type = ?', to_class], ['content_id = ? and content_type = ?', id, from_class]
      end
    end
    return User.find(user.id) #return object of new class
  end

  def allows_guest_comments?
    result = (rare_user_settings ? rare_user_settings.allows_guest_comments? : nil)
    result
  end

  def fwd_tos_allowed?
    result = (rare_user_settings ? rare_user_settings.fwd_tos_allowed? : nil)
    result
  end
  
  def self.anonymous
    find(ANONYMOUS_ID)
  end

  def find_or_create_featured_album
    user = self
    album = Album.find_by_user_id_and_cat_id(user.id, Content::CATEGORIES[:featured_album][:id])
    if album.nil?
      album = Album.create(
        :title => Content::CATEGORIES[:featured_album][:name],
        :user_id => user.id, :is_in_gallery => false,
        :is_in_startpage => false,
        :cat_id => Content::CATEGORIES[:featured_album][:id],
        :relationshiptype_id => Relationshiptype.everyone)
    end
    album
  end
  
  def folder_for_pictures_from_notes
    Album.find_by_user_id_and_cat_id(self.id, Content::CATEGORIES[:folder_for_pictures_from_notes][:id])
  end
  
  def find_or_create_folder_for_pictures_from_notes
    user = self
    album = folder_for_pictures_from_notes
    if album.nil?
      # 'Pictures from Notes'.t
      album = Album.create(
        :_title => Content::CATEGORIES[:folder_for_pictures_from_notes][:name],
        :title_ru => Content::CATEGORIES[:folder_for_pictures_from_notes][:name].t(:locale => 'ru'),
        :user_id => user.id, :is_in_gallery => true,
        :is_in_startpage => false,
        :cat_id => Content::CATEGORIES[:folder_for_pictures_from_notes][:id],
        :relationshiptype_id => Relationshiptype.everyone)
    end
    return album
  end

  def has_wall_posts?
    profile && !profile.comment_count.zero?
  end
  
  def generic_circle_name(cid, opts = {})
    case cid.to_i
    when -2 then 'Everyone'.t
    when -1 then (opts[:use_i] ? 'Only I'.t : 'Only Me'.t)
    when 0 then 'Hosts'.t
    when 1 then 'Family'.t
    when 2 then 'Friends'.t
    when 3 then 'Supporters'.t
    when 4 then 'Fans'.t
    when 5 then 'Interested'.t
    when 6 then (opts[:include_site] ? 'Site'.t : '')
    else ''
    end
  end

  def last_pending_invitation_of(invited_user)
    invites_i_sent.sent_to(invited_user).pending.ordered.first
  end

  def last_pending_invitation_request_to(desired_user)
    invites_i_requested.requests_to(desired_user).pending.ordered.first
  end

  def upload_quota
    upload_quota_mb * 1.megabyte
  end

  def upload_quota_used
     Content.sum('size', :conditions => ['user_id = ? and type in (?)', self.id, ['Track', 'Image']])
  end

  def upload_quota_used_mb
    upload_quota_used / 1.megabyte
  end

  def upload_quota_left
    upload_quota - upload_quota_used
  end

  def follows?(followed, types = nil)
    Relationship.has_follower?(followed, self, types)
  end

  def likes?(followed, types = nil)
    WhatYouLike.has_liker?(followed, self, types)
  end

  def followed_collections
    Relationship.find_followed_by(self, Relationshiptype.all_valid,
                                  :conditions => ['users.type = ?', CollectionProject.name], :limit => nil)
  end

  def friend_feed(options = {})
    options.reverse_merge!(:include_dirs => true)
    options.reverse_merge!(:categories => FeedEntry::CONTENT_CATEGORIES.keys)

    categories = options[:categories].map {|cat| FeedEntry::CONTENT_CATEGORIES[cat]}

    activity = FeedEntry.with_details.to_user(self).newest_first.only(categories)
    activity = activity.without_dirs unless options[:include_dirs]
    activity.paginate :page => options[:page], :per_page => options[:per_page]
  end

  def set_flash(key, data)
    key = key.to_s
    flash = self.flashes.find_by_key(key)
    unless flash
      self.flashes.create!(:key => key, :data => data)
    else
      flash.update_attribute(:data, data)
    end
  end

  def get_and_delete_flash(key)
    flash = self.flashes.find_by_key(key.to_s)
    return unless flash
    flash.destroy
    return flash.data
  end

  def escape_content_descriptions?
    !self.account_setting.has_an_approved_account_set? && !self.account_setting.verified_by_kroogi?    
  end

  def wall_notes_tab_index
    result = (rare_user_settings ? rare_user_settings.wall_notes_tab_index : nil)
    result || DEFAULT_WALL_NOTES_INDEX
  end

  def wall_tab_active?
    wall_notes_tab_index == WALL_TAB_INDEX
  end

  def set_wall_tab_active
    self.rare_user_settings ||= RareUserSettings.create(:user_id => self.id)
    self.rare_user_settings.update_attribute(:wall_notes_tab_index, WALL_TAB_INDEX)
  end

  def maybe_set_wall_tab_active(wall_post_or_comment)
    return if wall_tab_active?
    wall_post = wall_post_or_comment.head_of_thread
    latest5 = Comment.find(:all, :conditions => {:commentable_id => wall_post_or_comment.commentable.id,
                                                 :commentable_type => wall_post_or_comment.commentable.class.name,  
                                                 :parent_id => nil},
                           :order => 'id desc', :limit => CHECKED_LAST_POSTS_FOR_WALL_NOTES_TAB).last
    if wall_post.created_at >= latest5.created_at
      set_wall_tab_active
    end
  end
  
  def set_notes_tab_active
    self.rare_user_settings ||= RareUserSettings.create(:user_id => self.id)
    self.rare_user_settings.update_attribute(:wall_notes_tab_index, NOTES_TAB_INDEX)
  end

  def maybe_set_notes_tab_active(commented_note)
    return unless wall_tab_active?
    note = commented_note
    latest5 = Board.with_details.usernotes.ordered.top(CHECKED_LAST_POSTS_FOR_WALL_NOTES_TAB).last
    if note.created_at >= latest5.created_at
      set_notes_tab_active
    end
  end

  def self.find_all_by_emails(emails)
    self.with_preferences.searchable_by_email.find(:all, :conditions => ['email in (?)', emails])
  end

  def fb_user_name
    return nil if self.project?
    return nil unless self.fb_details
    fb_user = Mogli::User.find(self.fb_details.fb_user_id)
    return fb_user && fb_user.name
  end

  def facebook_session
    return nil unless self.facebook_connected?
    session = Facebooker::Session.create(FB_CONNECT_CONFIG[:api_key], FB_CONNECT_CONFIG[:secret_key])
    session.secure_with!(self.fb_details.fb_session_key, self.fb_details.fb_user_id, 0)
    session
  end

  def auto_like_to_fb_enabled?
    self.preference.fb_like_consolidation.eql?("always")
  end

  def connect_fb_account(fb_user_id, fb_session_key)
    unless self.fb_details
      if User.by_fb_id(fb_user_id).empty?
        self.create_fb_details(:fb_user_id => fb_user_id, :fb_session_key => fb_session_key, :is_fb_connected => 1)
      end
    else
      self.fb_details.update_attribute(:fb_session_key, fb_session_key)
    end
  end

  def show_fb_like_dialog?
    return true unless self.preference.fb_like_consolidation
    self.preference.fb_like_consolidation.eql?("ask_me")
  end

  def get_fb_friends
    return self.fb_friends unless self.fb_friends.empty?
    friends = facebook_connected? ? facebook_session.user.friends!(:uid, :name).map{|f| {:uid => f.uid, :name => f.name}} : []
    FbFriend.transaction do
      self.fb_friends.create(friends)
    end
  end

  def find_kroogi_users_matched_fb_friends
    res = []
    User.by_fb_id(self.get_fb_friends.map(&:uid)).each do |kr_user|
      unless Relationship.has_follower?(kr_user, self)
        res << {:kroogi_user => kr_user, :fb_user => self.get_fb_friends.find_by_uid(kr_user.fb_details.fb_user_id)}
      end
    end
    res
  end

  def follow_users_found_with_fb(users_to_follow)
    return if users_to_follow.blank?
    User.find(users_to_follow).each do |u|
      Relationship.make_user_follow_project(:follower => self, :followed => u, :created_with_fb => true)
    end
  end

  def show_find_fb_friends_sm?
    self.fb_friends.empty?
  end

  def can_change_questions_kit?
    PublicQuestion.with_user(self).unpublished.untouched.size == 5
  end

  def update_questions_kit(kit_id)
    settings = self.rare_user_settings

    return if settings.questions_kit_id == kit_id

    questions_kits = YAML.load_file(File.join(Rails.root, "config", "public_questions.yml"))
    questions_kit = questions_kits.detect {|q| q[:id] == kit_id && q[:enabled]}

    User.transaction do
      questions = PublicQuestion.with_user(self).unpublished.untouched

      questions.map(&:destroy)

      questions_kit[:questions].each do |question|
        q = PublicQuestion.new(
          :user_id => self.id,
          :text_en => question[:en],
          :text_ru => question[:ru],
          :show_on_events => true
        )
        q.without_monitoring { q.save }
      end

      settings.update_attribute(:questions_kit_id, kit_id)
    end
  end

  def roles_cache_key
    "user_roles/#{id}"
  end

  def roles_list
    Rails.cache.fetch(roles_cache_key){ roles.to_a }
  end

  def invalidate_roles_cache
    Rails.cache.delete(roles_cache_key)
  end

  def tps_setup_enabled?
    rare_user_settings ? rare_user_settings.tps_setup_enabled? : nil
  end

  def max_easy_notification_count
    return 1500 if self.login == 'tequilajazzz'
    500
  end

  def can_write_pvtmessage_to?(user)
    !BlockedUser.by_pvt.exists?({:blocked_by_id => user.id, :blocked_user_id => self.id})
  end

  def default_circles
    self.class.default_circles
  end

  def can_not_follow?
    Relationship.count(:conditions => {:related_user_id => self.id, :relationshiptype_id => Relationshiptype.follower_types}) >= MAX_FOLLOWED
  end

  def can_follow?
    !can_not_follow?
  end

  protected
  # before filter
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    #logger.info "Before:#{self.crypted_password}"
    self.crypted_password = encrypt(password)
    #logger.info "After:#{self.crypted_password}"
  end


    
  def make_activation_code
    return unless self.respond_to?("activated_at")
    return unless self.activated_at.nil?
    self.activation_code = Digest::SHA1.hexdigest(Time.now.to_s) if self.respond_to?("activation_code")
  end




  ######### State Change Methods #########

  # All content permissions except avatars are set to 'viewed by owner only'
  def prevent_viewing_of_content
    Content.update_all ['relationshiptype_id=?', Relationshiptype.nobody], ["user_id=? and cat_id != ?", self.id, Content::CATEGORIES[:avatar][:id]]
    # Note: is_view_permitted? now prevents viewing any user controller page for deleted users
  end

  # Prevent orphans by deleting projects with only one, about-to-be-deleted, owner
  def delete_projects_owned_solely_by_me
    personal_projects.each do |p|
      p.delete!
    end
  end

  # Delete relationships (both ways - to and from)
  def delete_relationships
    Relationship.delete_all ["user_id=? or related_user_id=?", self.id, self.id]
  end

  # Delete pending invites involving deleted user
  def delete_invites
    Invite.delete_all ["user_id=?", self.id] # I'm invited to
    Invite.delete_all ["inviter_id=? and user_id is not null", self.id] # My invitations, unless they're site invites
  end

  # Delete activities involving deleted user
  def delete_activities
    Activity.delete_all ['user_id=? OR from_user_id=?', self.id, self.id] # to or from user
    Activity.delete_all ['content_id=? AND content_type in (?)', self.id, [BasicUser, AdvancedUser, Project].map(&:name)] # involving user
  end

  def delete_feed_entries
    FeedEntry.remove_entries_of_user(self)
  end

  def delete_collection_inclusions
    CollectionInclusion.delete_all(['child_user_id = ? OR parent_id = ?', self.id, self.id])
    #let's not remove ProjectAsContents here: keep them just as we keep content - to restore if user is restored
  end

  # When we delete user with login passed in, we need to change name to deleted_LOGIN_NN.
  def assign_deleted_login_name
    # change loginname deleted_<username>_<counter>
    ndn = User.next_deleted_number_for(self.login)
    update_attribute(:login, "deleted_#{self.login}_#{ndn}")
  end

  # When we delete user with login passed in, we need to change name to deleted_LOGIN_NN. Find NN
  def self.next_deleted_number_for(login)
    begin
      dels = User.find(:all, :conditions => ['login like ?', "deleted_#{login}_%"])
      num_from_deleted_login(dels.sort_by{|x| num_from_deleted_login(x.login) }.last.login) + 1
    rescue
      1
    end
  end

  # Parse out the integer part of deleted_LOGIN_nn
  def self.num_from_deleted_login(login)
    begin
      login.match(/^deleted_.+?_(\d+)$/)[1].to_i
    rescue
      0
    end
  end
    
  def set_display_name
    self.display_name    = self.login if self.display_name.blank? && self.display_name_ru.blank?
    self.write_attribute(:display_name_ru, self.display_name_ru.strip) if self.display_name_ru
    self.write_attribute(:display_name, self.read_attribute(:display_name).strip) if self.read_attribute(:display_name)
  end

  def method_missing(meth, *args, &blk)
    # return cache key based on method name
    if meth.to_s.ends_with?("_key") && respond_to?(m = meth.to_s.sub("_key", ""))
      "user/#{id}/#{m}"
    else
      super
    end
  end

  include StringUtilsMixin

  def init_circles
    self.circles.each_with_index do |circle, ci|
      APP_CONFIG.locales.each do |locale|
        I18n.with_locale(locale) do
          circle.name =  default_circle_names[ci] ? default_circle_names[ci].call : ""
        end
      end
      circle.save!
    end
  end

  #just for IDE to show overrides
  def self.default_circles
    raise 'wrong class was asked!'
  end

  def default_circle_names
    raise 'wrong class was asked!'
  end

  def deletion_forbidden?
    return false if current_user.admin?
    true if login == 'cardioprogram'
  end

  def for_projects_select
    name = self.display_name
    (name = '{{project_name}} collection' / name) if self.collection?
    [name, self.id]
  end

end
