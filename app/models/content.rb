# == Schema Information
# Schema version: 20090212135816
#
# Table name: contents
#
#  id                    :integer(11)     not null, primary key
#  user_id               :integer(11)     not null
#  title                 :string(255)
#  description           :text
#  type                  :string(255)
#  content_type          :string(255)
#  filename              :string(255)
#  filepath              :string(255)
#  size                  :integer(11)
#  parent_id             :integer(11)
#  thumbnail             :string(255)
#  width                 :integer(11)
#  height                :integer(11)
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  is_in_gallery         :boolean(1)
#  db_file_id            :integer(11)
#  foruser_id            :integer(11)
#  cat_id                :integer(11)     default(0), not null
#  is_in_startpage       :boolean(1)
#  is_in_myplaylist      :boolean(1)
#  created_by_id         :integer(11)     default(0), not null
#  updated_by_id         :integer(11)     default(0), not null
#  author_id             :integer(11)     default(0), not null
#  artist                :string(80)
#  album                 :string(80)
#  year                  :integer(4)
#  genre                 :string(60)
#  bitrate               :integer(4)
#  chanels               :string(20)
#  samplerate            :integer(4)
#  length                :integer(6)
#  post_db_store_id      :integer(11)
#  language_code         :string(8)
#  owner                 :string(255)
#  title_ru              :string(255)
#  description_ru        :text
#  title_fr              :string(255)
#  description_fr        :text
#  post_db_store_ru_id   :integer(11)
#  post_db_store_fr_id   :integer(11)
#  state                 :string(255)     default("active")
#  state_changed_at      :datetime
#  artist_ru             :string(255)
#  album_ru              :string(255)
#  artist_fr             :string(255)
#  album_fr              :string(255)
#  downloadable          :boolean(1)
#  downloadable_album_id :integer(11)
#  relationshiptype_id   :integer(11)
#  body_project_id       :integer(11)
#

class Content < ActiveRecord::Base
  include AASM
  include SiteActivityLoggerForModels
  #skip_caching

  acts_as_logging

  VALID_SUBCLASS_NAMES = %w(Content Album Bundle Image Track Textentry Blog Board Pvtmessage Video FolderWithDownloadables CoverArt Inbox MusicAlbum)
  ALBUM_TYPE_NAMES = %w(Album FolderWithDownloadables MusicAlbum MusicContest)  
  ALBUM_TYPES_SQL = ALBUM_TYPE_NAMES.map{|t| "'#{t}'"}.join(", ")
  attr_accessor :just_uploaded, :require_terms
  xss_terminate :except => [:description, :owner, :original_owner]
  translates :title, :description, :artist, :base_as_default => true
    
  belongs_to :user
  belongs_to :recipient, :class_name => 'User', :foreign_key => 'foruser_id'
  belongs_to :author,    :class_name => 'User'
  belongs_to :submitter, :class_name => 'User', :foreign_key => 'created_by_id'
    
  belongs_to :relationshiptype
    
  # Items can be included in albums (although right now support for more than 1 + featured is shaky in terms of permissions, etc)
  has_many :album_items, :dependent => :destroy, :order => 'position'
  has_many :albums, :through => :album_items, :order => '`contents`.created_at ASC',
           :conditions => 'contents.user_id = #{user_id}', :uniq => true

  # Items can be submitted to inboxes
  has_many :inbox_items, :dependent => :destroy, :order => 'inbox_id, position'

  #don't remove or nullify on content deletion - good to still know import chain
  has_one :this_import_details, :class_name => 'ContentImportDetails', :foreign_key => :content_id
  has_many :all_imports, :class_name => 'ContentImportDetails', :foreign_key => :original_content_id

  has_one :contest_submission, :dependent => :destroy

  has_one :content_i18n, :dependent => :destroy

  belongs_to :post, :class_name => 'DbStore', :foreign_key => 'post_db_store_id'
  belongs_to :post_ru, :class_name => 'DbStore', :foreign_key => 'post_db_store_ru_id'

  def inboxes
    Inbox.find(:all, :include => :inbox_items, :conditions =>
        ['inbox_items.original_content_id = ?', self.original_content_id], :order => 'inbox_items.id')
  end

  def in_inbox?
    return @in_inbox unless @in_inbox.nil?
    @in_inbox = !self.is_a?(Inbox) && !inbox_items.empty?
  end

  def calc_in_inbox_by_user_data
    @in_inbox = !!user.content_inbox_inclusions[self.id]
  end
    
  has_many :monetary_donations

  has_one :donation_setting, :as => :accountable, :dependent => :destroy, :validate => false

  has_many :downloads, :class_name => 'Activity', :conditions =>
    ['activity_type_id = ?', Activity::ACTIVITIES[:content_downloaded][:id]]
    
  #TODO: extract this to smth more appropriately named, like new LinkedImage class, in separate table.
  # For Announcements foreign key's name is totatlly misleading
  has_one :embedded_image, :class_name => 'CoverArt', :foreign_key => 'downloadable_album_id'

  def nonzero_donations
    MonetaryDonation.donations_received.all(:conditions => ['gross_amount_usd > 0 AND content_id = ?', self.id])
  end

  def nonzero_donations_count
    MonetaryDonation.donations_received.count(:conditions => ['gross_amount_usd > 0 AND content_id = ?', self.id])
  end

  def moderation_events
    Moderation::Event.for_content(self.id)
  end
    
  include DonationSettingMethods

  # 'Pictures from Notes'.t
  CATEGORIES = {
    :blog => {:id => 1, :name => 'Blog'},
    :image => {:id => 2, :name => 'Image'},
    :avatar => {:id => 3, :name => 'Avatar'},
    :userpic => {:id => 4, :name => 'Krugi Id'},
    :writing => {:id => 5, :name => 'Writing'},
    :announcement => {:id => 6, :name => 'Announcement'},
    :topic => {:id => 7, :name => 'Topic'},
    :track => {:id => 8, :name => 'Audio Track'},
    :pvtmsg => {:id => 9, :name => 'Private Message'},
    :album => {:id => 10, :name => 'Album'},
    :featured_album => {:id => 11, :name => 'Content on Kroogi Page'},
    :bundle => {:id => 13, :name => 'File Bundle'},
    :video => {:id => 14, :name => 'Video'},
    :cover_art => {:id => 15, :name => 'Cover Art'},
    :inbox => {:id => 16, :name => 'Inbox'},
    :project => {:id => 17, :name => 'User or project'},
    :original_contest_track => {:id => 18, :name => 'Original contest track'},
    :folder_for_pictures_from_notes => {:id => 19, :name => 'Pictures from Notes'}
  }
    
  #named_scope :albums,    :conditions => ['type=?', 'Album']
  named_scope :in_rainbows,    :conditions => ['type in (?)', ['FolderWithDownloadables', 'MusicAlbum']]
  named_scope :music_albums,    :conditions => ['type=?', 'MusicAlbum']
  named_scope :music_contests,    :conditions => ['type=?', 'MusicContest']
  named_scope :bundles,    :conditions => ['type=?', 'Bundle']
  named_scope :thumbs,    :conditions => ['type=?', 'ImageThumbnail']
  named_scope :tracks,    :conditions => ['type=?', 'Track']
  named_scope :texts,     :conditions => ['type=?', 'Textentry']
  named_scope :images,    :conditions => ['type=?', 'Image']

  named_scope :downloadable, :conditions => ['downloadable=?', true]

  # Subtypes of images
  named_scope :avatars,           :conditions => ['type=? and cat_id=?', 'Image', Content::CATEGORIES[:avatar][:id]]
  named_scope :kroogi_pictures,   :conditions => ['type=? and cat_id=?', 'Image', Content::CATEGORIES[:userpic][:id]]

  # Subclasses of text
  named_scope :blogs,         :conditions => ['type=?', 'Blog']
  named_scope :pvtmessages,   :conditions => ['type=?', 'Pvtmessage']
  named_scope :videos,        :conditions => ['type=?', 'Video']
  named_scope :boards,        :conditions => ['type=?', 'Board']
    
  # Misc
  named_scope :limit,    lambda {|l| {:limit => l || 10}}

  #named_scope :public,        :conditions => ['relationshiptype_id = ?', Relationshiptype.everyone]

  before_destroy :clean_associated_models

  # Set language of content to user's current language
  def before_save
    if self.respond_to?(:language_code) # For migrations from before field added
      begin
        self.language_code = I18n.locale
      rescue
        self.language_code = 'en'
      end
    end
  end
    
  acts_as_threaded
  acts_as_taggable
  acts_as_voteable
  acts_as_permitted
  acts_as_favorite
  acts_as_rated :with_stats_table => true, :stats_class => 'RatingStat', :rating_range => 1..5, :no_rater => true
    
  named_scope :blocked, :conditions => ['state=?', 'blocked']
  named_scope :active, :conditions => ['state=?', 'active']

  aasm_column :state
  aasm_initial_state  :active  
  aasm_state :active,   :enter => proc{|c| c.do_restore }
  aasm_state :blocked,  :enter => :do_block
    
  aasm_event :block do
    transitions :from => :active, :to => :blocked
  end
    
  aasm_event :restore do
    transitions :from => :blocked, :to => :active
  end
    
  def do_block
    # When you block an album, you block all of that album's contents, too
    if self.respond_to?(:album_contents) && !self.is_a?(Inbox)
      self.album_contents.each {|x| x.block! unless x.blocked?}
    end
      
    update_attribute(:state_changed_at, Time.now)
  end
    
  def do_restore
    # In case this is called when record is created, don't bother doing anything special with it.
    return true if self.new_record?
    return true unless self.blocked? #restoring only makes sense if it's blocked 
    # When you unblock an album, you unblock all of that album's contents, too
    if self.respond_to?(:album_contents) && !self.is_a?(Inbox)
      self.album_contents.each {|x| x.restore! }
    end
      
    update_attribute(:state_changed_at, Time.now)
  end

  def self.public_stream_classes
    %w(Album FolderWithDownloadables Image MusicAlbum Textentry Track Video)
  end

  def self.searchable_classes
    public_stream_classes + ['Board']
  end

  def self.categories_rejected_from_public_stream
    [:featured_album, :avatar, :userpic, :folder_for_pictures_from_notes].map {|c| Content::CATEGORIES[c][:id]}
  end

  # Sphinx Index
  define_index do
    # fields
    indexes [:title, :title_ru], :as => :title_all , :sortable => true
    indexes [:description, :description_ru], :as => :description_all , :sortable => true
    indexes :genre
    indexes [:artist, :artist_ru], :as => :artist_all , :sortable => true
    indexes [:album, :album_ru], :as => :album_all , :sortable => true
    indexes [user(:display_name), user(:display_name_ru)], :as => :user_display_name
    indexes tags.name, :as=>:tag_names
    indexes [post(:content), post_ru(:content)], :as => :post

    # attributes
    has :created_at

    #it also excludes LJ.. but it's probably fine
    where %Q{!users.private and contents.state = 'active'
      and contents.relationshiptype_id = #{Relationshiptype.everyone}
      and contents.type in (#{Content.searchable_classes.map {|c| "'#{c}'"}.join(',')})
      and contents.cat_id not in (#{Content.categories_rejected_from_public_stream.join(',')})}
  end

  def set_ownership_from_params(ownership_as_string, owner_name)
    self.owner = case ownership_as_string
    when 'me'     then current_actor.login
    when 'other'  then owner_name
    else nil
    end
  end
    
  def owner
    #TODO: make a migration and get rid of this [self]
    return user.login if (self['owner'] == '[self]' || self['owner'].blank?)
    self['owner']
  end
    
  # Add this item to the owner's kroogi page "featured items" panel
  def assign_to_featured_album
    return if self.is_a?(Board)
    if self.is_in_startpage
      return if self.album_ids.include?(self.user.featured_album.id)
      self.albums << self.user.featured_album
      self.save!
    end
  end
    
  # Add this item to the given album. Update permissions for self and for all children, children's children, etc.
  def assign_to_album(album_id)
    return if self.is_a?(Board)
      
    album_id = album_id.is_a?(Album) ? album_id.id : album_id.to_i
    unless album_id.blank? or self.album_ids.include?(album_id)
      album = Content.active.find_by_id(album_id)
      album = nil unless album && album.is_a?(Album) # Allow assigning to album subclasses
      album = nil unless album && album.user_id == self.user_id # Don't allow assigning to other users' albums
      album = nil if album && self.requires_public_permissions? && !(album && album.public?)
      if album && !album.inclusion_allowed?(self)
        self.errors.add_to_base("Sorry, album doesn't allow this item now".t)
        raise ActiveRecord::RecordInvalid.new(self)
      end
      if album
        #return if self.albums.include?(album)
        self.is_in_gallery = false
        self.albums << album

        # Set security same as album - NOTE: THIS SCREWS UP ROYALLY if content in more than one album
        set_permissions_to( album.relationshiptype_id )
          
        self.save!
        return album
      end
    end
    nil
  end
    
  # Make the permission setting recursive into album items as necessary
  def set_permissions_to(perm_level)
    unless self.relationshiptype_id == perm_level
      if self.new?
        self.relationshiptype_id = perm_level
        self.save! #for validation on create to happen
      else
        update_attribute(:relationshiptype_id, perm_level)
      end
    end
      
    if self.is_a?(Album)
      self.album_contents.each {|item| item.set_permissions_to(perm_level) }
    end
  end
    
  def action_cache_key_suffix(controller)
    [updated_at.to_i, comment_count]
  end
    
  def can_be_in_gallery?
    allowed = %w(image userpic writing track video album project folder_for_pictures_from_notes cover_art)
    allowed.collect{|a| CATEGORIES[a.to_sym][:id]}.include?(self.cat_id)
  end
    
  # Boolean - submitted to the given inbox, or if given a user, ANY of the given user's inboxes
  def submitted_to?(to_what)
    if to_what.is_a?(Inbox)
      self.inboxes.include?(to_what)
    elsif to_what.is_a?(User)
      self.inboxes.any?{|b| to_what.is_self_or_owner?(b.user)}
    else false
    end
  end
    
  # Shouldn't this be handled by acts_as_favorite?
  def favorited
    Favorite.find(:all, :conditions => {:favorable_type => self.class.to_s, :favorable_id => self.id})
  end
    
  # Return the n of the top most popular content.
  def self.popular(n=4)
    Content.find(:all, :joins => "LEFT JOIN users on contents.user_id = users.id",
      :order => "popularity desc", :limit => n,
      :conditions => "contents.state = 'active' and users.private = FALSE and relationshiptype_id = #{Relationshiptype.everyone}")
  end

  def self.update_popularity
    # popularity decays 1% per day and increases by popularity gained in last day
    Content.update_all("popularity = popularity * 0.9", "popularity > 0")
    ContentStat.connection.update(%Q{update contents c, content_stats cs
      set c.popularity = c.popularity + cs.viewed_today + ifnull(cs.played_today,0)*3 + ifnull(cs.commented_today,0)*5 + ifnull(cs.favorited_today, 0)*7
      where c.id = cs.content_id and c.type = cs.content_type and (viewed_today > 0 or favorited_today > 0 or played_today > 0)
      })
  end

  def self.announcement_count_for(user)
    Board.active.count(:all, :conditions => {:user_id => user.id})
  end

  def self.weekly_top_contributions(options = {})
    options.assert_valid_keys :limit, :lang

    limit = options[:limit] ? " LIMIT #{options[:limit]}" : ''

    #this is only for testing purpose
    time_range = (RAILS_ENV == 'production') ? 1.week.ago.to_s(:db) : 1.years.ago.to_s(:db)
    
    lang = options.delete(:lang)

    join = 'INNER JOIN monetary_transactions mt ON mt.content_id = contents.id'

    conditions = "WHERE contents.type in ('#{Album.name}', '#{MusicAlbum.name}', '#{FolderWithDownloadables.name}') and mt.created_at > '#{time_range}'"
    if lang == 'en'
      join << ' LEFT JOIN contents_i18n i18n ON mt.content_id = i18n.content_id'
      conditions << " AND (i18n.content_id is null || !i18n.hide_from_eng_top)"
    end

    select = <<-EOSQL
      SELECT contents.*, sum(mt.net_amount_usd) as c FROM contents
      #{join}
      #{conditions}
      GROUP BY contents.id
      ORDER BY c desc
      #{limit}
    EOSQL

    Content.find_by_sql(select)
  end

  def featured_album?
    self.cat_id == Content::CATEGORIES[:featured_album][:id]
  end
        
  def display_type
    c = CATEGORIES.detect{|name, hash| hash[:id] == self.cat_id}
    #'Content'.t
    return 'Content' unless c
    #'Post'.t
    return 'Post' if c[1][:name] == 'Writing'
    c[1][:name]
  end
    
  def title_long
    self.title_short(200)
  end
    
    
  def title_short(howlong = 14, ellipsis = true)
    text = title.blank? ? 'Untitled'.t : title
    if ellipsis
      howlong > 14 ? truncate_string = '...' : truncate_string = '..'
    else
      truncate_string = ''
    end
    l = howlong - truncate_string.chars.length
    (text.chars.length > howlong ? text.chars[0...l] + truncate_string : text).to_s
  end
    
  def editable?
    true
  end
    
  # Permissions set to public - anyone can see, so show viral-type features
  def public?
    restriction_level == Relationshiptype.everyone
  end

    
  def self.privacy_menu(user)
    types = user.circles(:just_ids => true)
    types.push user.project? ? Relationshiptype.founders : Relationshiptype.nobody
    types << Relationshiptype.everyone

    menuobj = Relationshiptype.find(:all, :conditions => {:id => types}, :order => 'position asc')

    menu = menuobj.collect do |item|
      circ_name = item.id > (user.project? ? 0 : 1) ? ('%s and closer' / user.circle_name(item.id)) : user.generic_circle_name(item.id)
      circ_name = 'Hosts only'.t if item.id == 0
      [circ_name, item.id]
    end
  end

  # Can this item be put in non-public folders or otherwise hidden from view?
  def requires_public_permissions?
    in_inbox? || (self.is_a?(Album) && album_item_in_inbox?)
  end
    
  # Returns a list of the circle levels that are allowed to see this item (e.g. public item returns all, friends item return friends and closer)
  def levels_can_see
    if public? || !Relationshiptype.followers_and_founders_types.include?(relationshiptype_id)
      Relationshiptype.followers_and_founders_types
    elsif relationshiptype_id == Relationshiptype.nobody
      Relationshiptype.founders
    else Relationshiptype.circle_and_closer(relationshiptype_id)
    end
  end
    
  # The furthest circle that can be seen, or various special values less than 0. Can be overriden to ignore privacy settings altogether (e.g. Bundle)
  def restriction_level
    # Pvtmessages not so much
    return Relationshiptype.nobody if self.is_a?(Pvtmessage)
      
    # Items in inboxes MUST have security set to public
    return Relationshiptype.everyone if self.in_inbox?
      
    # Otherwise, return the level (default to open if something got messed up)
    self.relationshiptype_id.blank? ? Relationshiptype.everyone : self.relationshiptype_id
  end
        
  # Moderators can see content in this and further circles (e.g. if content is only viewable by poster, no need for moderator to see it)
  def self.allow_moderators_to_view_this_circle_and_further
    Relationshiptype::TYPES[:family]
  end
    
  # Checks if given user has permission to see the content
  def is_view_permitted?(given_user = nil)
    return false unless self.active?
      
    given_user ||= self.current_user
      
    # If item is public, no need for further permission checks
    return true if self.public? && self.user && self.user.public? 
      
    # Base case of identity, no need to check relationships
    return true if given_user && ((given_user.id == self.author_id) || (given_user.id == self.foruser_id) || given_user.is_self_or_owner?(self.user))

    # Special case -- allow recipient and owners to see private messages
    if self.is_a?(Pvtmessage)
      return true if given_user.is_self_or_owner?(self.foruser) || given_user.is_self_or_owner?(self.user)
      return false
    end

    return true if given_user.admin?
    
    # Otherwise no can do if only my owner can see it (if you got to here, you aren't my owner)
    return false if self.restriction_level == Relationshiptype.nobody

    # Content of private or blocked projects cannot be seen
    return false if self.user && !self.user.is_view_permitted?

    # Fine, we'll actually run some DB queries...
    return Relationship.has_follower?(self.user, given_user, self.levels_can_see)
  end
    
  def remove_from_album(album)
    content = self
    album_item = album.album_contents_items.detect{|item| item.content_id == content.id }
    return if album_item.nil?
    unless album.featured_album?
      # note - featured albums dont fall in here
      if content.can_be_in_gallery?
        content.is_in_gallery = true

        # Set security to same as album
        content.relationshiptype_id = album.relationshiptype_id
      end
    else
      # removal from featured
      content.is_in_startpage = false
    end
    album.album_items.delete(album_item)
    content.save!
  end

  def remove_from_inbox(inbox)
    inbox_items.select{|item| item.inbox_id == inbox.id}.each{|x| x.destroy}
  end

  def find_album_for_content(album_id)
    return if self.is_a?(Board)
    album_id = album_id.to_i
    unless album_id.blank? or self.album_ids.include?(album_id)
      album = Content.active.find_by_id(album_id)
      album = nil unless album && album.is_a?(Album) # Allow assigning to album subclasses
      album = nil if self.requires_public_permissions? && !(album && album.public?)
    end
    album
  end

  #absense of this caused errors on Prod for image thumbnails at Explore page once
  def post
  end

  #TODO: merge it with display_type - they do the same
  def entity_name_for_human
    self.class.name.titleize
  end

  def removal_success_message
    # 'Video was successfully deleted'.t
    # 'Track was successfully deleted'.t
    msg = self.entity_name_for_human.humanize + ' was successfully deleted'
    msg.t
  end

  def clone_content_from_inbox(inbox)
    my_clone = self.create_clone if self.respond_to?(:create_clone)
    my_clone ||= self.clone

    # A few things we need to change
    my_clone.attributes = {:user_id => inbox.user_id, :created_by_id => self.user_id, :is_in_gallery => true, :created_at => Time.now, :updated_at => Time.now}
    my_clone.is_in_startpage = true if my_clone.is_a?(ProjectAsContent)

    # Create a shallow copy of any post text
    %w(post_db_store post_db_store_ru post_db_store_fr).each do |field|
      next if !self.respond_to?(field) || self.send("#{field}_id").blank?
      if self.send(field).blank? || self.send(field).content.blank?
        my_clone.send("#{field}_id=", nil)
      else
        my_clone.send("#{field}=", DbStore.create(:content => self.send(field).content))
      end
    end

    # We just want a shallow copy of these, thanks very much (note db_file_id - NEVER USED)
    %w(description description_ru description_fr).each do |field|
      next if self.send(field).blank?
      my_clone.send("#{field}=", self.send(field))
    end
      
    my_clone.tags = self.tags
    if self.is_a?(ProjectAsContent)
      my_clone.being_cloned = true
      my_clone.save!
    else
      Content.transaction do
        my_clone.save! #so that we have validation and exceptioning on errors
        ContentImportDetails.create!(:previous_owner_id => self.user_id,
          :previous_content_id => self.id,
          :inbox_id => inbox.id,
          :new_owner_id => inbox.user.id,
          :original_content_id => self.original_content_id,
          :content_id => my_clone.id)
      end
    end

    my_clone.send_submission_alerts(inbox, self)
    return my_clone
  end

  def original_content_id
    this_import_details ? this_import_details.original_content_id : self.id  
  end

  def original_content
    if original_content_id == self.id
      content = self
    else
      content = Content.find_by_id(original_content_id)
      content ||= self
    end
    content
  end
  
  def imports_history
    return @imports_history if @imports_history
    @imports_history = []
    all_imports = original_content.all_imports.to_a
    import = this_import_details
    while import
      @imports_history << import
      import = all_imports.find {|cid| cid.content_id == import.previous_content_id} 
    end
    @imports_history.reverse!
  end
  
  def send_submission_alerts(inbox, old_content)
    Activity.send_message(self, inbox.user, :accepted_from_inbox)
    Activity.send_message(self, inbox.user, :inbox_submission_accepted, {:to_user => old_content.user})
    User.active.find(:all, :conditions => ["id in (?)", imports_history.map{|oo| oo.previous_owner_id}.uniq]).each do |u|
      Activity.send_message(self, self.user, :content_item_adopted, {:to_user => u})
    end
  end

  def self.all_content_finder_params(options = {})
    conditions = ["contents.cat_id not in (?) and contents.type not in (?)",
      [CATEGORIES[:featured_album][:id],
        CATEGORIES[:avatar][:id],
        CATEGORIES[:pvtmsg][:id]],
      ['ImageThumbnail', 'Bundle', 'FileDownload']]
    if options[:exclude_type]
      conditions.last << options[:exclude_type]
    end
    if options[:public_only]
      conditions[0] += ' and relationshiptype_id = ?'
      conditions << Relationshiptype.everyone
    end

    {:conditions => conditions, :order => 'created_at DESC'}
  end

  def container_album
    self.albums.detect{|album| !album.featured_album?}
  end
  
  def change_album(album_id)
    old_album = self.container_album
    if old_album
      if album_id.blank?
        # removing from albums
        self.remove_from_album(old_album)
      elsif album_id != old_album.id.to_s
        # changing belongenness to the album
        self.remove_from_album(old_album)
        self.assign_to_album(album_id)
      end
    elsif !album_id.blank?
      # adding for first time
      self.assign_to_album(album_id)
    end
  end

  def commentable?
    self.active? && self.editable?
  end

  # Returns true if the given user has taken this content item to their showcase from this inbox
  def taken_to_showcase?(of_user)
    if of_user.collection?
      of_user.featured_album.album_contents.map(&:body_project_id).include?(self.body_project_id)
    else
      ContentImportDetails.count(:include => :content, :conditions =>
          ['original_content_id = ? and new_owner_id = ? and contents.id is not null', original_content_id,
          of_user.id]) > 0
    end
  end

  def self.recent(options = {})
    NewContent.recent_content(options)[0]
  end

  def destroy
    return if self.undeletable?
    if (self.is_a?(Image) || self.is_a?(Track)) && self.filename.nil?
      # this is completely wasted
      Content.delete_all("id = '#{self.id}' OR parent_id = '#{self.id}'")
    else
      super
    end
  end

  def related_contents(num = nil)
    Content.all(:joins => "INNER JOIN related_contents rc on rc.first_content_id = #{id} AND rc.second_content_id = contents.id",
      :order => "rc.relatedness desc",
      :limit => num || 5)
  end

  def self.update_related_contents
    # writing this in Ruby since I'm finding it impossible to CREATE PROCEDURE from Rails
    connection.execute("TRUNCATE related_contents")
    connection.insert_sql(<<-EOQ
      INSERT INTO related_contents
      SELECT a1_content_id, a2_content_id, count(*), 0.0, 0.0
      FROM (
        SELECT DISTINCTROW a1.user_id, a1.content_id a1_content_id, a2.content_id a2_content_id
          FROM activities a1
          CROSS JOIN activities a2 ON a2.user_id = a1.user_id
                                  AND a2.activity_type_id = 319
                                  AND a2.content_id <> a1.content_id
                                  AND a2.content_type = 'Content'
                                  AND a2.created_at > (NOW() - INTERVAL 90 DAY)
                                  AND (a2.from_related IS NULL OR a2.from_related <> 1)
          where a1.user_id IS NOT NULL
            AND a1.user_id > 1
            AND a1.activity_type_id = 319
            AND a1.content_type = 'Content'
            AND a1.created_at >  (NOW() - INTERVAL 90 DAY)
            AND (a2.from_related IS NULL OR a1.from_related <> 1) ) i1
        GROUP BY a1_content_id, a2_content_id
      EOQ
    )
    connection.insert_sql(<<-EOQ
      INSERT INTO related_contents
        SELECT first_content_id, NULL, sum(download_count), 0.0, 0.0
        FROM related_contents
        GROUP BY first_content_id
      EOQ
    )
    download_count_sum = count_by_sql("SELECT sum(download_count) from related_contents WHERE second_content_id IS NULL")
    connection.update_sql("UPDATE related_contents SET download_percentage = (download_count / #{download_count_sum}) WHERE second_content_id IS NULL")
    connection.execute("TRUNCATE related_contents_work_table")
    connection.insert_sql("INSERT INTO related_contents_work_table SELECT * FROM related_contents WHERE second_content_id IS NULL;")
    connection.update_sql(<<-EOQ
      UPDATE related_contents rc LEFT JOIN related_contents_work_table rcc on rcc.first_content_id = rc.first_content_id
        SET rc.download_percentage = (rc.download_count) / (rcc.download_count)
        WHERE rc.second_content_id IS NOT NULL;
      EOQ
    )
    connection.execute("TRUNCATE related_contents_work_table");
    connection.insert_sql("INSERT INTO related_contents_work_table SELECT * FROM related_contents WHERE second_content_id IS NULL")
    connection.update_sql(<<-EOQ
      UPDATE related_contents rc LEFT JOIN related_contents_work_table rcc on rcc.first_content_id = rc.first_content_id
        SET rc.relatedness = rc.download_percentage / rcc.download_percentage
        WHERE rc.second_content_id IS NOT NULL;
      EOQ
    )
  end

  def navigation_within_parent(parent_id)
    if parent_id
      # its possible for content to be in multiple albums (normal + showcase)
      container ||= self.albums.find_by_id(parent_id)
      container ||= Inbox.find_by_id(parent_id) 
    end

    # hopefully only one album besides showcase, but just in case we're sorting so at least we always return the same album, even if it's not the correct one
    container ||= self.albums.to_a.reject{|a| a.featured_album? }.sort_by(&:id).first
    album_id = container ? container.id : nil
    klass = container ? container.class : Album
    navigation = klass.navigation(self, :container => container)
    navigation[:album_id] = album_id
    navigation
  end

  def undeletable?
    false
  end

  def update_blank_owner(user_login)
    self.owner = user_login if self.owner == user_login #this covers blank, and '[self]'    
  end

  def music_contest_item?
    container_album.is_a?(MusicContest)
  end

  def downloadable?
    false
  end

  def update_specific_params(params)

  end

  def own_cover_art_url
  end

  def cover_art_url
    result = own_cover_art_url
    result = container_album.cover_art_url if !result && container_album
    log.debug "content id = #{self.id}"
    result = user.avatar_path unless result 
    result
  end

  def hidden_from_eng_top?
    self.content_i18n ? self.content_i18n.hide_from_eng_top? : false 
  end

  def min_contribution_amount
    nil
  end

  def recommended_contribution_amount
    nil
  end

  # For subclasses -- Create an image for cover art
  def set_or_update_embedded_image(params)
    return if params.blank? || params[:uploaded_data].blank?
    raise "Method only works for subclasses" unless self.respond_to?(:embedded_image)

    #set existing embedded image free 
    embedded_image.update_attribute(:downloadable_album_id, nil) if embedded_image

    folder = self.user.find_or_create_folder_for_pictures_from_notes
    ei = CoverArt.new(params)
    ei.user_id = self.user_id
    ei.user = self.user
    ei.cat_id = Content::CATEGORIES[:cover_art][:id]
    ei.is_in_startpage = false
    ei.is_in_gallery = true
    ei.author_id = self.author_id
    ei.created_by_id = self.author_id
    ei.relationshiptype_id = folder.relationshiptype_id
    self.embedded_image = ei
    ei.downloadable_album_id = self.id
    ei.title = self.title(40)
    ei.save!

    ei.albums << folder
  end

  def host_user
    user
  end
  
  def flat_comments?
    false
  end

  def is_folder_for_pictures_from_notes?
    false
  end

  def can_be_deleted?
    true
  end

  def set_specific_params_before_saving(params)
    
  end

  def multiple_uploader_needed?(kind = nil)
    false
  end

  def make_private!
    self.update_attributes!(:relationshiptype_id => Relationshiptype.nobody)
  end
  
  def make_public!
    self.update_attributes!(:relationshiptype_id => Relationshiptype.everyone)
  end

  def has_goodies?
    !Tps::Goodie.of_content(self).blank?
  end

  def verbose_param_parts
    [Russian.translit(self.title_short(40, false))]
  end
  
  def to_verbose_param
    verbose_param_parts.map do |part|
      if part.is_a?(String)
        part = part.strip
        part = part.gsub(/\.+$/, '') #remove trailing dots
        part = part.gsub(/[\.\s]/, '-') #replace spaces and dots with '-'
        part = part.gsub('&', 'and'.t) #replace '&' with translated 'and'
        part = part.gsub('#', '') #chomp hashes
        part = part.gsub('?', '') #chomp questions
        part = part.gsub(/['"]/, '') #chomp quotes
      end
      part
    end.unshift(self.id).join('-')
  end

  protected
  # Before destroy callback
  def clean_associated_models
    # Remove comments
    Comment.belonging_to(self).each{|c| c.destroy} #virtual deletion
      
    # Remove activities
    Activity.for_content(self).delete_all
    FeedEntry.remove_content_entries(self)
  end
    
  def check_quota
    if self.user.upload_quota_left < self.size
      self.errors.add_to_base("This upload would exceed your quota".t)
      raise UploadQuotaExceeded.new(self)
    end
  end

end
