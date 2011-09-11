#  create_table "collection_inclusions", :force => true do |t|
#    t.column "parent_id",           :integer,                    :null => false
#    t.column "child_pac_id",        :integer,                    :null => false
#    t.column "child_user_id",       :integer,                    :null => false
#    t.column "direct_parent_id",    :integer,                    :null => false
#    t.column "child_is_collection", :boolean,                    :null => false
#    t.column "stopped",             :boolean, :default => false, :null => false
#  end
#

class CollectionInclusion < ActiveRecord::Base
  belongs_to :parent, :class_name => 'CollectionProject' 
  belongs_to :direct_parent, :class_name => 'CollectionProject' 
  belongs_to :child_pac, :class_name => 'ProjectAsContent'
  belongs_to :child_project, :class_name => 'User', :foreign_key => 'child_user_id'

  named_scope :collections, lambda { { :conditions => "collection_inclusions.child_is_collection"} }
  named_scope :projects, lambda { { :conditions => "!collection_inclusions.child_is_collection"} }
  named_scope :of_child_project, lambda { |project_id| { :conditions => ['child_user_id = ?', project_id]} }
  named_scope :with_projects, lambda { { :joins => "JOIN users on collection_inclusions.child_user_id = users.id"} }
  named_scope :direct, lambda { { :conditions => "direct_parent_id = parent_id"} }
  named_scope :order_by_popularity, lambda { {:order => "users.popularity desc"} }
  named_scope :order_by_date, lambda { {:order => "users.created_at desc"} }
  named_scope :unstopped, lambda { { :conditions => "!stopped"} }
  named_scope :children_of, lambda {|parent_id| { :conditions => ['parent_id = ?', parent_id]} }

  order_by_name_scope_lambda = lambda do
    one, two = (I18n.base_locale? ? ['', '_ru'] : ['_ru', '']).map {|suf| "users.display_name#{suf}"}
    {:order => "if(#{one} is null OR #{one} = '', #{two}, #{one})" }
  end
  named_scope :order_by_name, order_by_name_scope_lambda 


  def direct?
    parent_id == direct_parent_id
  end

  def self.find_all_ancestor_ids_of_pac(pac)
    self.of_child_project(pac.parent_id).map {|ci| ci.parent_id} + [pac.parent_id]
  end

  def self.maybe_create_for(pac, collection_id, existing_inclusions, child_is_collection)
    new_ci = pac.build_collection_inclusion(collection_id, child_is_collection)

    #existing inclusion should either remain or be replaced with new
    if ci = existing_inclusions[collection_id]
      if ci.direct?
        return #existing inclusion is direct - skip new
      else
        if new_ci.direct?
          ci.destroy #existing inclusion is indirect and new is direct: replace with new
        else
          return #both existing and new inclusions are indirect - skip new
        end
      end
    end
    new_ci.save!
    true
  end

  def self.included?(child_user_id, parent_user_id)
    self.find(:first, :conditions => {:child_user_id => child_user_id, :parent_id => parent_user_id})
  end

  def release!
    CollectionStopListItem.transaction do
      stop_item = CollectionStopListItem.find(:first, :conditions => {:parent_id => parent_id, :child_id => child_user_id})
      stop_item.destroy if stop_item
      self.update_attributes!(:stopped => false)
    end
  end

  def stop!
    CollectionStopListItem.transaction do
      CollectionStopListItem.create!(:child_id => child_user_id, :parent_id => parent_id)
      self.update_attributes!(:stopped => true)
    end
  end

  def toggle_stop!
    self.stopped? ? self.release! : self.stop!
  end

  def self.unstopped_parent_ids(project_id)
    self.of_child_project(project_id).unstopped.map(&:parent_id)
  end

  def self.remove_unfollowed_feed_entries(follower, questionably_followed_project_ids)
    questionably_followed_project_ids.each do |questionably_followed_id|
      next if follower.follows?(questionably_followed_id)
      next if follower.followed_collections.any? {|col| col.has_unstopped_inclusion?(questionably_followed_id)}
      FeedEntry.remove_directed_entries(follower, questionably_followed_id)
    end      
  end
  
  def self.remove_collection_driven_friendfeed_entries(excluded_project, options = {})
    excluded_project = excluded_project.id if excluded_project.is_a?(User)
    questionably_followed_project_ids = [excluded_project] + CollectionInclusion.unstopped.
            children_of(excluded_project).map(&:child_user_id)
    if options[:follower]
      remove_unfollowed_feed_entries(options[:follower], questionably_followed_project_ids)
    else
      Relationship.find_followers_paginated(options[:collections_with_followers]) do |follower|
        remove_unfollowed_feed_entries(follower, questionably_followed_project_ids)
      end
    end
  end
end
