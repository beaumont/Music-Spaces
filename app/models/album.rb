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

class Album < Content
  
  # grrr, has_many through is broken when caller is polymorphic subclass, makes invalid where clause with content_id instead of album_id and ingnores foreign_key
  #has_many :album_contents, :class_name => "Content", :through => :album_items, :as => :album, :source => 'content'
        
  # Gimpy, but can be changed later
  has_many :album_contents, :class_name => "Content",
   :finder_sql => 'SELECT contents.* FROM contents INNER JOIN album_items ON contents.id = album_items.content_id WHERE (album_items.album_id = #{id}) order by position asc'
  
  has_many :album_contents_items, :class_name => "AlbumItem", :foreign_key => 'album_id', :order => 'position', :dependent => :destroy

  # What WOULD the bundle item be, if this were switched to be a MusicAlbum? Used for editing when was MA, but now A
  has_one :pending_cover_art, :class_name => 'CoverArt', :foreign_key => 'downloadable_album_id', :conditions => 'type="CoverArt"', :dependent => :destroy
  has_many :pending_bundles, :class_name => 'Bundle', :foreign_key => 'downloadable_album_id', :conditions => 'type="Bundle"', :dependent => :destroy
  has_one :fwd_details, :class_name => 'ExtraFieldset::FolderWithDownloadables', :foreign_key => 'folder_id', :dependent => :destroy

  has_one :cover_art, :class_name => 'CoverArt', :foreign_key => 'downloadable_album_id', :conditions => 'type="CoverArt"', :dependent => :destroy  

  def album_contents_sql
    "SELECT contents.* FROM contents INNER JOIN album_items ON contents.id = album_items.content_id WHERE album_items.album_id = #{id}"
  end

  def contents
    @contents ||= Content.find_by_sql(album_contents_sql)
  end

  def tracks
    @tracks ||= Content.find_by_sql(album_contents_sql + " AND type = 'Track'")
  end

  def images
    @images ||= Content.find_by_sql(album_contents_sql + " AND type in ('Image', 'CoverArt')")
  end

  def last_images
    @last_images ||= Content.find_by_sql(album_contents_sql + " AND type in ('Image') order by created_at desc limit 3")
  end

  # IF passed an album, do navigation within that
  # ELSE if passed a nil album, assume we're looking at the user's gallery (e.g. showcase + anything NOT in a different album)
  def self.navigation(viewed_item, options = {})
    container = options[:container]
    what_we_are_iterating_over = options[:what_we_are_iterating_over]
    # permission aware pager is a pain in the butt
    # todo - see if will_paginate can be tricked to do this or make a plugin
    before_slice = []
    after_slice = []
    all = []
    #init first and last to currently viewd in case permissions forbid from seeing anything at all
    first_item = last_item = viewed_item
    first_item_found = center_item_found = false
    after_count = 0

    what_we_are_iterating_over ||= container.album_contents if container
    what_we_are_iterating_over ||= viewed_item.user.gallery_items

    what_we_are_iterating_over = what_we_are_iterating_over.to_a.partition {|c| c.is_a?(Track)}.inject {|sum, x| sum + x}

    what_we_are_iterating_over.to_a.each do |album_item|
      next unless album_item.is_view_permitted?
      all << album_item
      # store first and last
      # dont just use first last of array, etc cause the permissions need to be checked
      last_item = album_item
      unless first_item_found
        first_item_found = true
        first_item = album_item
      end

      if viewed_item.id == album_item.id
        # check if its a center item
        center_item_found = true
      else
        # otherwise, looking at slice either before or after center item
        # build slice window of four items (two before and two after viewed one)
        unless center_item_found
          before_slice << album_item
          before_slice.shift if before_slice.size > 2
        else
          after_count += 1
          after_slice << album_item if after_slice.size < 2
        end
      end
    end

    
    return {:first => first_item, 
            :last => last_item, 
            :next => after_slice.empty? ? viewed_item : after_slice.first, 
            :previous => before_slice.empty? ? viewed_item : before_slice.last,
            :position => before_slice.empty? ? 1 : all.size - after_count,
            :size => all.size,
            :slice => (before_slice << viewed_item) + after_slice,
          }
  end

  def navigation(viewed_item)
    Album.navigation(viewed_item, :container => self)
  end


  def update_security_of_children
    all_contents = self.get_all_contents_of_album
    all_contents.each {|x| x.update_attribute(:relationshiptype_id, self.relationshiptype_id)}
  end

  # Recursion - get contents, and if contents are albums, get THEIR contents
  def get_all_contents_of_album(origin = nil)
    all = self.album_contents.inject([]) do |array, c|
      if c.is_a?(Album) && c != origin
        subcontents = c.get_all_contents_of_album(origin || self)
        array << subcontents.flatten if subcontents
      end
      array << c      
    end
    return all ? all.flatten : nil
  end
  
  def empty?
    album_contents.empty?
  end

  def random_image
    images[rand( images.count) ]
  end

  def has_image?
    !images.empty?
  end

  def post=(entry)
  end
  
  def empty!
    album_contents.each {|x| x.destroy }
  end

  def album_menu_item_caption
    self.title_short(25)
  end

  # Menu for select tag
  def self.album_menu(content)
    # current_actor is not available in a static method
    return [] unless content.user
    content.user.albums(:for_menu => true, :content => content)
  end

  def self.upload_tracks_album_menu(user)
    return [] unless user
    user.albums(:for_menu => true, :content => Track.new)
  end

  def self.upload_images_album_menu(user)
    return [] unless user
    user.albums(:for_menu => true, :content => Image.new)
  end

  def inclusion_allowed?(content_to_include)
    return false if self.id == content_to_include.id
    return false if !self.public? && content_to_include.requires_public_permissions?
    return false if content_to_include.is_a?(MusicAlbum) && self.downloadable?
    return false if content_to_include.is_a?(Album) && content_to_include.get_all_contents_of_album.include?(self)
    true
  end

  def album_item_in_inbox?
    album_contents.any?{|x| x.in_inbox?}
  end
  
  # this needs to be defined here so that FolderWithDownloadables and Album can swap in views.
  def fwd_details_if_needed
    self.fwd_details || self.build_fwd_details
  end
  
  # this is the show_on_kroogi_page content (Featured Showcase Items)
  def self.find_or_create_featured_for(user)
    return nil unless user
    return user.find_or_create_featured_album
  end

  def set_or_update_cover_art(params)
    return if params.blank? || params[:uploaded_data].blank?
    raise "Method only works for subclasses" unless self.respond_to?(:cover_art)

    #now that we're renaming all cover arts files to same name (user_albumid_cover.xxx), cloudfront has a
    #delay updating old name to new content in case of update (see #3050). Hence more reliable to destroy and add.
    cover_art.destroy if cover_art && !cover_art.undeletable?

    ca = CoverArt.new(params)
    set_cover_art_filename(ca)
    ca.user_id = self.user_id
    ca.user = self.user
    ca.cat_id = Content::CATEGORIES[:cover_art][:id]
    ca.is_in_startpage = false
    ca.is_in_gallery = false
    ca.author_id = self.author_id
    ca.created_by_id = self.author_id
    ca.relationshiptype_id = Relationshiptype.nobody
    ca.downloadable_album_id = self.id
    ca.save!
    ca
  end

  def set_cover_art_filename(ei)
    original_name = ei.filename
    ei.filename = '%s_%s_cover%s' % [self.user.login, self.id, File.extname(original_name).downcase]
  end

  def entity_name_for_human
    # 'Folder'.t
    'Folder'.t
  end

  def player_embeddable?
    true
  end

  def last_item_date
    return nil if album_contents_items.empty?
    album_contents_items.first(:order => 'created_at desc').created_at
  end

  def own_cover_art_url
    img = (self.cover_art || random_image)
    result = img.cover_art_url if img
    result
  end

  def is_folder_for_pictures_from_notes?
    self.cat_id == Content::CATEGORIES[:folder_for_pictures_from_notes][:id]
  end

  def can_be_deleted?
    return false if is_folder_for_pictures_from_notes? && !empty?
    true
  end

  def validate
    if @require_terms
      if self.donatable?
        errors.add_to_base "Album cannot be donatable if terms acceptance is required.".t
      elsif self.fwd_details_if_needed.terms.blank?
        errors.add_to_base "Terms cannot be left blank if terms acceptance is required.".t
      end
    end
  end

  def require_terms_acceptance?
    user.fwd_tos_allowed? && fwd_details_if_needed.require_terms_acceptance?
  end

  def multiple_uploader_needed?(kind = nil)
    return true if kind == :images
    if kind == :tracks
      return false unless APP_CONFIG.multiple_tracks_uploader_enabled      
    end
    true
  end
end
