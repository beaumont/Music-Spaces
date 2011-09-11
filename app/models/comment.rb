# == Schema Information
# Schema version: 20081006211752
#
# Table name: comments
#
#  id               :integer(11)     not null, primary key
#  title            :string(50)      default("")
#  created_at       :datetime        not null
#  commentable_id   :integer(11)     default(0), not null
#  commentable_type :string(15)      default(""), not null
#  user_id          :integer(11)     default(0), not null
#  comments_count   :integer(11)     default(0), not null
#  parent_id        :integer(11)
#  lft              :integer(11)
#  rgt              :integer(11)
#  created_by_id    :integer(11)     default(0), not null
#  avatar_id        :integer(11)
#  db_store_id      :integer(11)
#  deleted_at       :datetime
#  deleted_by       :integer(11)
#  private          :boolean(1)
#

class Comment < ActiveRecord::Base
  LIMIT_FOR_SHOW = 3

  belongs_to :commentable, :polymorphic => true
  belongs_to :db_store
  
  named_scope :deleted, :conditions => 'deleted_at is not null'
  named_scope :active, :conditions => 'deleted_at is null'
  named_scope :public, :conditions => '!private OR private is null'

  # Toggle whether or not to allow private comments. If no private comments, OK to cache comments displays
  def self.enable_private_comments?
    false
  end
  
  # If private comments are disabled, ensure none are created here as well as UI
  def before_create
    self['private'] = false unless Comment.enable_private_comments?
    true
  end
  
  
  xss_terminate :except => [:comment]
  # NOTE: install the acts_as_votable plugin if you 
  # want user to vote on the quality of comments.
  #acts_as_voteable
  acts_as_nested_set :text_column => 'title', :scope => [:commentable_id,:commentable_type]
            
  
  # NOTE: Comments belong to a user
  belongs_to :user
  
  acts_as_permitted
  
  attr_accessor :comment
  
  def comment=(data)
    return nil if data.blank?
    self.db_store ||= DbStore.new
    self.db_store.update_attribute(:content, data)
  end
  
  def comment
    return nil unless self.db_store
    return '[ Comment Deleted ]'.t    if self.deleted?
    return '[ Comment is Private ]'.t unless self.can_see?
    return self.db_store.content
  end
    
  def delete_thread!
    deletable = self.self_and_descendants.select{|x| x.can_delete?}
    return false if deletable.empty?
    deletable.each {|c| c.delete!(true)}
    return true
  end
  
  # Our custom deletion
  def delete!(skip_thread_check = false)
    return false unless can_delete?
    
    # Delete all comments if first post in thread (profile or user kroog). Needs skip_thread_check to avoid infinite loop
    if !skip_thread_check && head_of_thread?
      delete_thread!
    else
      Comment.update_all(['deleted_at = ?, deleted_by = ?', Time.now, current_actor ? current_actor.id : 0], ['id = ?', self.id])
    end
    return true
  end

  def head_of_thread?
    (parent.nil? && !children.empty? && (commentable.is_a?(UserKroog) || commentable.is_a?(Profile)))
  end

  #find first comment to commentable, which formed thread with self
  def head_of_thread
    parent = self
    while parent.parent_id != nil
      parent = parent.parent
    end
    parent
  end
  
  # Can the contents of this message be read by current_actor?
  def can_see?
    return true unless self.private?
    return true if current_actor.is_self_or_owner?(self.user) # Poster
    return true if has_commentable_user? && current_actor.is_self_or_owner?(self.commentable.user) # Content owner
    return true if self.parent && current_actor.is_self_or_owner?(self.parent.user) # Parent's poster (the user replying to)
    return false
  end

  def can_see_ancestors?
    return false if self.ancestors.any? {|x| !x.can_see?}
    return true
  end

  def can_see_children?
    return self.can_see? if self.children.empty?
    return true if self.children.any? {|x| x.can_see?}
    return false
  end

  def non_deleted_children?
    return false if self.children.empty?
    return false if self.children.all? {|x| x.deleted? }
    return true
  end

  # Can the current actor delete this comment?
  def can_delete?
      return true if current_user.moderator?
      return true if current_user.is_self_or_owner?(self.user)
      return true if has_commentable_user? && current_user.is_self_or_owner?(self.commentable.user)
      return true if commentable.respond_to?(:can_delete?) && commentable.can_delete?
      return false
  end

  def deleted?
    not deleted_at.nil?
  end
  
  
  # Apparently acts_as_nested_set breaks the before and after filters to ensure concurrency blah blah blah... which means this has
  # to be a separate method, rather than a filter
  def set_privacy!
    if self.parent && self.parent.private?
      update_attribute(:private, true)
    end    
  end
    
  # Manage Stats
  def after_create
    if self.commentable && self.commentable.kind_of?(Content)
      ContentStat.mark_async(:commented!, {:content => self.commentable, :user_id => self.user_id})
    end
  end
  
  def before_destroy
    if self.commentable.kind_of?(Content)
      ContentStat.mark_async(:decommented!, {:content => self.commentable, :user_id => self.user_id}) if self.commentable
    end
  end
  
  # a pointless wrapper
  def top
    self.root
  end
  
  # Return the most recent comments
  def self.newest(n=4)
    seen = {}
    viewable = []
    loops = 0
    while (viewable.size < n)  do
      overkill = self.find(:all, :limit => 2*n, :order => 'created_at DESC', :offset => 2*loops*n)
      viewable += overkill.select {|s| s.commentable.is_view_permitted?}
      loops += 1
      
      # Only one comment per commentable item
      viewable = viewable.select do |x| 
        seen["#{x.commentable_type}/#{x.commentable_id}"].to_i.zero? && seen["#{x.commentable_type}/#{x.commentable_id}"] = 1
      end
    end
    viewable[0..(n-1)]
  end
  
  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  def self.find_comments_by_user(user)
    # todo
    return nil
  end
  
  # Helper class method to look up all comments for 
  # commentable class name and commentable id.
  def self.find_comments_for_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find_comments_for_commentable_id(commentable_id)
  end

  # Helper class method to look up a commentable object
  # given the commentable class name and id 
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end
  
  
  def self.comment_count_multi(clazz, commentable_ids)
    count_map = {}
    return count_map if commentable_ids.empty?
    dacount = Comment.find_by_sql(["select count(commentable_id) AS count_all, commentable_id  FROM comments WHERE commentable_id in (?) AND commentable_type = ? AND deleted_at is NULL group by commentable_id", commentable_ids, clazz.name.to_s])
    dacount.each do |comm|
      count_map[comm.commentable_id.to_i] = comm['count_all']
    end
    return count_map
  end

  def commentable_user
    return commentable if commentable.is_a?(User)
    return commentable.user
  end

  def host_user
    commentable.host_user
  end

  def title_short(length)
    AutoExcerpt.new(comment || "", :characters => length, :strip_tags => true)
  end

  def post
    comment
  end

  def tag_list
    []
  end
  
  protected
  
  def has_commentable_user?
    self.commentable && self.commentable.respond_to?(:user) && self.commentable.user
  end
  
end
