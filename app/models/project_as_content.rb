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

class ProjectAsContent < Content

  belongs_to :body_project, :class_name => 'User',
    :foreign_key => 'body_project_id'

  has_many :collection_inclusions, :class_name => 'CollectionInclusion', :foreign_key => 'child_pac_id'

  attr_accessor :body_project_name, :being_cloned

  # Skip on create validations for cloning
  validate_on_create :validate_project_name_specified, :unless => :skip_create_validation?
  validate_on_create :validate_project_exists, :unless => :skip_create_validation?
  validate_on_create :validate_name_uniqueness, :unless => :skip_create_validation?
  validate_on_create :validate_no_cycles, :unless => :skip_create_validation?

  #hmm, if these are put before associations, 1 spec starts to fail - need to investigate
  after_create :populate_inclusions_after_creation
  after_create :populate_friendfeeds
  before_destroy :make_container_not_interested
  after_destroy :remember_old_parents
  after_destroy :remove_inclusions_after_death
  after_destroy :remove_friendfeed_entries_after_inclusion_breaks

  def skip_create_validation?
    !!being_cloned
  end

  def validate_project_name_specified
    errors.add_to_base("Project name must be specified".t) if body_project_name.blank?
  end

  def validate_project_exists
    if !body_project_name.blank?
      return if body_project_id
      self.body_project_name.strip!
      #it can be User or Project
      self.body_project = User.find_by_login(body_project_name)
      errors.add_to_base("Project with that name not found".t) if !self.body_project
    end
  end

  def featured_album
    user.featured_album
  end

  def validate_name_uniqueness
    if featured_album.album_contents.to_a.find {|c| c.is_a?(ProjectAsContent) &&
          c.body_project_id == body_project_id}
      
      errors.add_to_base("That project is already present in this collection".t)
    end
  end

  def self.find_ancestory_chain_with(searched_parent_id, starting_child_user_id,
      current_chain = [starting_child_user_id])
    
    parent_ids = ProjectAsContent.find(:all, :conditions => 
        {:body_project_id => starting_child_user_id}).map {|pac| pac.parent_id}

    if parent_ids.empty? && searched_parent_id == :root
      return nil if current_chain[0] == 1 #for some reason Guests are often roots in DB, to be investigated/fixed
      return current_chain
    end
    parent_ids.each do |parent_id|
      new_chain = [parent_id] + current_chain
      if parent_id == searched_parent_id
        return new_chain
      else
        #in theory current chain can include parent_id (existing cycle) -
        # don't dive into it
        unless current_chain.include?(parent_id)
          found = find_ancestory_chain_with(searched_parent_id, parent_id,
            new_chain)
          
          return found if found
        end
      end
    end
    return nil
  end

  def validate_no_cycles
    if self.user_id == body_project_id
      errors.add_to_base("You can't add a collection to itself".t) and return
    end

    chain = self.class.find_ancestory_chain_with(body_project_id, self.user_id)
    if chain
      chain_string = chain.map {|id| User.find(id).display_name}.join(' -> ')
      if chain.size > 2
        msg = "Cannot add collection '%s' to '%s'. The later is already included in former indirectly so that would create a circular dependency. Inclusion path: %s." /
          [body_project.display_name, self.user.display_name, chain_string]
      else
        msg = "Cannot add collection '%s' to '%s'. The later is already included in former so that would create a circular dependency." /
          [body_project.display_name, self.user.display_name]
      end
      errors.add_to_base(msg) and return
    end
  end

  def post
  end

  def title
    body_project.display_name
  end

  def entity_name_for_human
    # 'Unknown'.t
    body_project ? body_project.entity_name_for_human : 'Unknown'
  end

  def removal_success_message
    msg = self.entity_name_for_human.humanize + ' \'%s\' was successfully ' +
      'removed from this collection'
    msg / title
  end

  def make_container_interested
    Relationship.make_user_follow_project(:follower => user, :followed => body_project)
  end

  def make_container_not_interested
    #note :from and :to are opposite to make_container_interested, but it
    #  works only this way!
    Relationship.downgrade_kroogi_relationship(:follower => user, :followed => body_project, :project_as_content => true)
    true
  end

  def self.find_all_ancestor_ids(starting_child_user_id, current_ancestors = [])
    parent_ids = ProjectAsContent.find(:all, :conditions =>
        {:body_project_id => starting_child_user_id}).map {|pac| pac.parent_id}

    parent_ids.each do |parent_id|
      skip_parent = current_ancestors.include?(parent_id)
      #current_ancestors can include parent_id (another path) - don't dive into it
      unless skip_parent
        current_ancestors << parent_id
        find_all_ancestor_ids(parent_id, current_ancestors)
      end
    end
    current_ancestors
  end

  def find_all_ancestor_ids
    self.class.find_all_ancestor_ids(self.user_id, [self.user_id])
  end

  def repopulate_collection_inclusions(options = {})
    options.reverse_merge! :use_collection_inclusions_to_find_ancestors => true, :clear => true
    
    im_collection = self.body_project.collection?
    CollectionInclusion.delete_all(['child_pac_id = ?', self.id]) if options[:clear]
    i = 0
    if options[:use_collection_inclusions_to_find_ancestors]
      #faster, but needs CollectionInclusions prepopulated 
      parent_ids = CollectionInclusion.find_all_ancestor_ids_of_pac(self)
    else
      parent_ids = find_all_ancestor_ids
    end
    existing_inclusions = CollectionInclusion.of_child_project(body_project_id).map {|ci| [ci.parent_id, ci]}.to_hash

    parent_ids.each do |collection_id|
      i += 1 if CollectionInclusion.maybe_create_for(self, collection_id, existing_inclusions, im_collection)
    end
    i
  end

  def parent_id
    user_id
  end

  def build_collection_inclusion(collection_id, child_is_collection)
    stop_item = CollectionStopListItem.find(:first, :conditions => ['parent_id = ? and child_id = ?', collection_id, self.body_project_id])
    self.collection_inclusions.build({
            :parent_id => collection_id, :child_user_id => self.body_project_id, :direct_parent_id => self.parent_id,
            :child_is_collection => child_is_collection, :stopped => !!stop_item
    })
  end

  def create_collection_inclusion!(collection_id, child_is_collection)
    build_collection_inclusion(collection_id, child_is_collection).save!
  end

  def self.remove_junk
    self.find_all_by_user_id(1).each {|pac| pac.destroy}
  end
  
  def do_populate_friendfeeds
    Relationship.find_followers_paginated(CollectionInclusion.unstopped_parent_ids(body_project_id)) do | follower |
      Relationship.populate_friendfeed(follower, self.body_project, :from_collection => true)
    end
  end

  private
  
  def promote_family_after_death
    others = self.class.find(:all, :conditions => ['body_project_id = ?', self.body_project_id])
    others.each {|pac| pac.repopulate_collection_inclusions}
  end

  def remove_inclusions_after_death
    if body_project.collection?
      children = body_project.inclusions
    end
    CollectionInclusion.delete_all(['child_pac_id = ?', self.id])
    log.debug "children are #{children.inspect}"
    if children
      CollectionInclusion.delete_all(['child_pac_id in (?)', children.map(&:child_pac_id)])      
      children.each do |ci|
        ci.child_pac.repopulate_collection_inclusions(:clear => false,
                                                      :use_collection_inclusions_to_find_ancestors => ci.direct?)
      end
    end
    promote_family_after_death
    true
  end

  def populate_inclusions_after_creation
    repopulate_collection_inclusions
    if body_project.collection?
      children = body_project.inclusions
      children.each do |ci|
        ci.child_pac.repopulate_collection_inclusions(:use_collection_inclusions_to_find_ancestors => ci.direct?)
      end
    end
    true
  end

  def populate_friendfeeds
    unless APP_CONFIG.disable_bdrb
      key = "populate_friendfeeds_on_collection_inclusion_#{self.id}"
      if BdrbJobQueue.find_by_job_key(key)
        log.error "Warning: dupe call of populate_friendfeeds_on_collection_inclusion (ignoring). Job_key #{key}"
        return
      end
      begin
        MiddleMan.worker(:directories_feeds_worker).enq_populate_friendfeeds_on_collection_inclusion(:arg => self.id,
                                                                                                     :job_key => key)
      rescue => e
        raise "Error scheduling #{key}: #{e.inspect}"
      end
    else
      do_populate_friendfeeds
    end
    true
  end

  def project_parent_ids
    CollectionInclusion.unstopped.of_child_project(body_project_id).map(&:parent_id)
  end

  def remember_old_parents
    @old_parent_ids = project_parent_ids
  end

  def remove_friendfeed_entries_after_inclusion_breaks
    args = [body_project_id, @old_parent_ids]
    unless APP_CONFIG.disable_bdrb
      key = "remove_friendfeed_entries_after_death_#{self.id}"
      if BdrbJobQueue.find_by_job_key(key)
        log.error "Warning: dupe call of remove_friendfeed_entries_after_death (ignoring). Job_key #{key}"
        return
      end
      begin
        MiddleMan.worker(:directories_feeds_worker).enq_remove_friendfeed_entries_after_inclusion_breaks(:arg => args, :job_key => key)
      rescue => e
        raise "Error scheduling #{key}: #{e.inspect}. Args are #{args.inspect}"
      end
    else
      self.class.remove_friendfeed_entries_after_inclusion_breaks(*args)
    end
    true
  end
  
  def self.remove_friendfeed_entries_after_inclusion_breaks(excluded_project_id, previous_parent_ids)
    collections_with_followers = previous_parent_ids - CollectionInclusion.unstopped_parent_ids(excluded_project_id)
    CollectionInclusion.remove_collection_driven_friendfeed_entries(excluded_project_id, :collections_with_followers =>
            collections_with_followers)
  end

end
