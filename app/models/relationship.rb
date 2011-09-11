# == Schema Information
# Schema version: 20090211222143
#
# Table name: relationships
#
#  id                          :integer(11)     not null, primary key
#  user_id                     :integer(11)     default(0), not null
#  related_user_id             :integer(11)     default(0), not null
#  relationshiptype_id         :integer(4)      default(0), not null
#  related_entity_id           :integer(11)
#  created_at                  :datetime        not null
#  attributebits               :integer(11)     default(0), not null
#  expires_at                  :datetime        default(Fri Jan 01 00:00:00 -0800 2038)
#  privacylevel                :integer(4)      default(0), not null
#  display_order               :integer(11)     default(0)
#  last_notified_of_expiration :datetime
#

class Relationship < ActiveRecord::Base
  # Note: relationships may be destroyed without callbacks if either user or related_user is deleted.

  # Note: say Anya is invited to Kali's circle. invite.inviter == Kali, invite.user == Anya. 
  # Relationship from invite -- r.user == invite.inviter, r.related_user == invite.user,
  # So if she accepts the invite, then for the relationship user == Kali and related_user == Anya
  
  named_scope :followers,               :conditions => {:relationshiptype_id => Relationshiptype.follower_types}
  named_scope :founders,                :conditions => {:relationshiptype_id => Relationshiptype.founders}
  named_scope :followers_and_founders,  :conditions => {:relationshiptype_id => Relationshiptype.followers_and_founders_types}
  named_scope :today,                   lambda { { :conditions => ['created_at > ?', 1.day.ago] } }
  named_scope :with, lambda {|user| {:conditions => {:related_user_id => user.id}}}
  
  belongs_to :user
  belongs_to :related_user, :class_name => 'User'
  belongs_to :related_entity

  after_create :create_relationship_message

  after_destroy :delete_relationship_message

  attr_accessor :stored_relationshiptype_id

  validates_uniqueness_of :user_id, :scope => :related_user_id

  before_save :can_create_this_relationship?

  def validate
    # Ensure no founder relationship established between two projects, or to a user
    if self.relationshiptype_id == Relationshiptype.founders
      if related_user.project?
        errors.add_to_base "Projects can't be members of other projects".t
      end
      unless user.project?
        errors.add_to_base "Projects can have members, but not users".t
      end
    end
  end
  
  def method_missing(sym, *args, &block)
    if args.length == 0 && sym.to_s == 'cnt'
      super rescue 0
    else
      super
    end
  end
    
  def self.friended_through_lj?(target)
    (2 & target[:attributebits].to_i) == 2 if target
  end
  
  # Finds all the relationships that are established to this user, 
  #   such as all users who are members of this users kroogi and people that watch this user
  def find_followers(user, options = {})
    Relationship.find_followers(user, [self.relationshiptype_id], options)
  end

  def self.find_followers_paginated(of_user_ids, types = nil, options = {})
    i = 0
    types = Relationshiptype.followers_and_founders_types unless types
    while true
      i += 1
      log.info "iteration %s" % i
      users_batch = find_followers(of_user_ids, types, options)
      users_batch.each {|friend| yield(friend)}
      options[:offset] = (options[:offset] || 0) + users_batch.count
      break if users_batch.count == 0
    end
  end
  
  def self.find_followers(user_or_user_ids, types = [], options = {})
    return [] if user_or_user_ids.is_a?(User) && user_or_user_ids.guest?
    user_ids = user_or_user_ids.is_a?(User) ? [user_or_user_ids.id] : user_or_user_ids
    options.reverse_merge!(:limit => 100)
    User.active.find(:all, :select => 'users.*, related_entity_id, relationshiptype_id, attributebits, privacylevel, relationships.user_id as relative_id, \'follower\' as rel_direction',
      :joins => 'LEFT JOIN relationships ON users.id = relationships.related_user_id', 
      :conditions => ['relationships.user_id in (?) AND relationshiptype_id IN (?) AND expires_at > CURDATE()', user_ids, types],
      :order => options[:order] ||= 'relationships.created_at asc',
      :limit => options[:limit],
      :offset => options[:offset] ||= 0
      )
  end

  def self.has_follower?(followed_projects_or_ids, follower, types = nil)
    if followed_projects_or_ids.is_a?(User)
      return false if followed_projects_or_ids.guest?
      followed_projects_or_ids = [followed_projects_or_ids.id]
    elsif !followed_projects_or_ids.is_a?(Array)
      followed_projects_or_ids = [followed_projects_or_ids]
    end
    return false if follower.nil? || follower.guest?
    types = Relationshiptype.followers_and_founders_types unless types
    count = Relationship.count_by_sql(['select count(id) as cnt from relationships where
      relationships.user_id in (?) AND relationships.related_user_id = ? AND relationshiptype_id IN (?) AND expires_at > CURDATE()', followed_projects_or_ids, follower.id, types]).to_i
    return false if count == 0
    count
  end
  
  def self.count_followers_group(user, types = nil)
    return [] if user.guest?
    types = Relationshiptype.followers_and_founders_types unless types
    Relationship.find_by_sql(['select count(id) as cnt, relationshiptype_id from relationships where 
      user_id = ? and relationshiptype_id IN (?) AND expires_at > CURDATE() group by relationshiptype_id', user.id, types])
  end
  
  def self.count_followers(user, types = [])
    return 0 if user.guest?
    types = [types] unless types.is_a?(Array)
    Relationship.count(:conditions => ['user_id = ? and relationshiptype_id in (?) AND expires_at > CURDATE()', user.id, types])
  end
  
  # Finds all the relationships that are established by this user, 
  #  such as user whos krugi this user is a member of
  #  and user he watches 
  def find_followed_by(user, options = {})
    Relationship.find_followed_by(user, [self.relationshiptype_id], options)
  end
  
  # Get the actual relationship objects from from_user to to_user in types categories
  def self.relationships(followed, follower, types, options = {})
    return [] if followed.guest? || follower.guest?
    Relationship.find(:all, 
      :conditions => ['user_id=? and related_user_id=? and relationshiptype_id IN (?) and expires_at > CURDATE()', followed.id, follower.id, types],
      :order => options[:order]   ||= 'created_at asc',
      :limit => options[:limit]   ||= 100,
      :offset => options[:offset] ||= 0
    )
  end

  # Get the actual relationship objects from from_user to to_user in types categories
  def self.all_relationships(user, types, options = {})
    return [] if user.guest?
    Relationship.find(:all, 
      :conditions => ['user_id=? and relationshiptype_id IN (?) and expires_at > CURDATE()', user.id, types],
      :order => options[:order]   ||= 'created_at asc',
      :limit => options[:limit]   ||= 100,
      :offset => options[:offset] ||= 0
    )
  end

  
  def self.find_followed_by(follower, types = [], options = {})
    return [] if follower.guest?
    options.reverse_merge!(:limit => 100)

    conditions = ['relationships.related_user_id = ? AND relationshiptype_id IN (?) AND expires_at > CURDATE()', follower.id, types]
    conditions = User.merge_conditions(conditions, options[:conditions]) if options[:conditions]
    User.active.find(:all, :select => 'users.*, related_entity_id, relationshiptype_id, attributebits, privacylevel, relationships.related_user_id as relative_id, \'followed_by\' as rel_direction',
      :joins => 'LEFT JOIN relationships ON users.id = relationships.user_id', 
      :conditions => conditions,
      :order => options[:order] ||= 'relationships.created_at asc',
      :limit => options[:limit],
      :offset => options[:offset] ||= 0
    )
  end

  #Finds relationships of user following followed_user. Returns array of user mixed with his relationships with followed_user.
  def self.select_followed_by(user, followed_user, types = [], options = {})
    return [] if user.guest? || followed_user.guest?
    User.active.find(:all, :select => 'users.*, related_entity_id, relationshiptype_id, attributebits',
      :joins => 'LEFT JOIN relationships ON users.id = relationships.related_user_id', 
      :conditions => ['relationships.user_id = ? AND relationships.related_user_id = ? AND relationshiptype_id IN (?) AND expires_at > CURDATE()', followed_user.id, user.id,  types],
      :order => options[:order] ||= 'relationships.created_at asc',
      :limit => options[:limit] ||= 100,
      :offset => options[:offset] ||= 0
      )
  end

  def self.count_followed_by_group(user, types = [], options = {})
    return [] if user.guest?
    Relationship.find_by_sql(['select count(id) as cnt, relationshiptype_id from relationships 
        where related_user_id = ? and relationshiptype_id IN (?) AND expires_at > CURDATE() group by relationshiptype_id', user.id, types])
  end
    
  # Create any other relationshiptype
  def self.create_kroogi_relationship(options = {})
    followed   = options.delete(:followed)
    follower   = options.delete(:follower)
    type       = options.delete(:type) || options.delete(:relationshiptype_id)

    if invite = options.delete(:invite)
      # Site invite doesn't get any relationships created between the inviter and invitee
      return if invite.circle_id == Invite::TYPES[:site_invite][:id]

      followed = invite.inviter
      follower = invite.user
      type     = invite.circle_id
    end

    # Ensuring we have user objects, not just ids
    follower = User.active.find(follower) unless follower.is_a?(User)
    followed = User.active.find(followed) unless followed.is_a?(User)

    options[:expires_at]      ||= Time.end
    options[:privacylevel]    ||= (followed.project? && followed.private?) ? 1 : 0
    options[:created_with_fb] ||= false

    type = type.is_a?(Symbol) ? Relationshiptype::TYPES[type] : type
    options[:type] = type
    raise "Nobody to establish relationship between, or no relationship type" unless followed && follower && type
    raise "Can't establish relationship with yourself" if followed == follower

    invite.clear_other_invitations if invite

    relationship = create_or_update_relationship(follower, followed, invite, options)

    if [followed, follower].all? {|u| !u.is_a?(Project)} && type < Relationshiptype.interested
      invite = followed.invites.pending.detect {|i| i.inviter_id == follower.id}
      if invite
        invite.revoke!
        invite.clear_other_invitations
      end
      create_or_update_relationship(followed, follower, nil, options)
    end

    if followed.project? && follower.is_self_or_owner?(followed)
      follower.preference.also_receive_emails_for(followed)
    end

    Rails.cache.delete(followed.friend_list_key)
    Rails.cache.delete(follower.friend_list_key)

    relationship
  end

  def self.create_or_update_relationship(follower, followed, invite, options = {})
    existing = Relationship.first(:conditions => {:user_id => followed.id, :related_user_id => follower.id})
    opts = {
      :user_id => followed.id,
      :related_user_id => follower.id,
      :related_entity_id => invite ? invite.id : nil,
      :relationshiptype_id => options[:type],
      :expires_at => options[:expires_at],
      :privacylevel => options[:privacylevel],
      :created_with_fb => options[:created_with_fb]
    }
    self.populate_friendfeed(follower, followed, :circle_type => options[:type])
    existing ? existing.update_attributes(opts) : Relationship.create(opts)
  end

  def self.make_user_follow_project(options)
    self.create_kroogi_relationship(:followed => options[:followed], :follower => options[:follower], 
                                    :created_with_fb => options[:created_with_fb], :type => :interested)
  end
  
  def self.downgrade_kroogi_relationship(opts)
    if opts[:invite]
      Relationship.all(:conditions => {
        :relationshiptype_id => opts[:invite].circle_id, 
        :related_entity_id => opts[:invite].id}).map(&:destroy)
    elsif opts[:project_as_content]
      follower, followed = follower_followed_by(opts)
      remove_relationship(follower, followed)
    else
      follower, followed = follower_followed_by(opts)
      kroog = opts[:kroog].is_a?(UserKroog) ? opts[:kroog] : UserKroog.find(opts[:kroog])
      current_actor = opts[:current_actor]

      if kroog.interested?
        remove_relationship(follower, followed)
        flash = "{{follower}} removed from the {{circle_name}} circle of {{followed}}" / [follower.login, kroog.name, followed.login]
      elsif kroog.fanclub?
        Relationship.first(:conditions => ["user_id = ? AND related_user_id = ?", followed.id, follower.id]).move_to_interested
        flash = "{{follower}} moved to the Audience circle of {{followed}}" / [follower.login, followed.login]
        downgrade_relationship_message(followed, follower, current_actor, Relationshiptype.interested)
      elsif kroog.friends? && follower.is_a?(Project)
        Relationship.first(:conditions => ["user_id = ? AND related_user_id = ?", followed.id, follower.id]).move_to_interested
        flash = "{{follower}} moved to the Interested circle of {{followed}}" / [follower.login, followed.login]
        downgrade_relationship_message(followed, follower, current_actor, Relationshiptype.interested)
      elsif kroog.friends?
        Relationship.all(:conditions => ["user_id = ? AND related_user_id = ? OR user_id = ? AND related_user_id = ?", followed.id, follower.id, follower.id, followed.id]).map(&:move_to_interested)
        flash = "{{follower}} moved to the Interested circle of {{followed}}" / [follower.login, followed.login]
        downgrade_relationship_message(followed, follower, current_actor, Relationshiptype.interested)
      elsif kroog.family? && (followed.is_a?(Project) || [followed, follower].all?(&:project?))
        Relationship.first(:conditions => ["user_id = ? AND related_user_id = ?", followed.id, follower.id]).move_to_fanclub
        flash = "{{follower}} moved to the Fun Club circle of {{followed}}" / [follower.login, followed.login]
        downgrade_relationship_message(followed, follower, current_actor, Relationshiptype.fanclub)
      elsif kroog.family? && follower.is_a?(Project)
        Relationship.first(:conditions => ["user_id = ? AND related_user_id = ?", followed.id, follower.id]).move_to_friends
        flash = "{{follower}} moved to the Fun Club circle of {{followed}}" / [follower.login, followed.login]
        downgrade_relationship_message(followed, follower, current_actor, Relationshiptype.friends)
      elsif kroog.family?
        Relationship.all(:conditions => ["user_id = ? AND related_user_id = ? OR user_id = ? AND related_user_id = ?", followed.id, follower.id, follower.id, followed.id]).map(&:move_to_friends)
        flash = "{{follower}} moved to the Friends circle of {{followed}}" / [follower.login, followed.login]
        downgrade_relationship_message(followed, follower, current_actor, Relationshiptype.friends)
      elsif kroog.founders? && followed.is_a?(CollectionProject)
        Relationship.first(:conditions => ["user_id = ? AND related_user_id = ?", followed.id, follower.id]).move_to_interested
        flash = "{{follower}} moved to the Interested circle of {{followed}}" / [follower.login, followed.login]
        downgrade_relationship_message(followed, follower, current_actor, Relationshiptype.interested)
      elsif kroog.founders?
        Relationship.first(:conditions => ["user_id = ? AND related_user_id = ?", followed.id, follower.id]).move_to_studio
        flash = "{{follower}} moved to the Studio circle of {{followed}}" / [follower.login, followed.login]
        downgrade_relationship_message(followed, follower, current_actor, Relationshiptype.studio)
      end

      Rails.cache.delete(follower.friend_list_key)
      Rails.cache.delete(followed.friend_list_key)

      return flash
    end
  end

  # Break this invite's relationship, or break all relationships between the given users
  # If no more connections, remove the associated activity message if user is no longer a friend (else, with no removed as friend message, when they readd get ininte list of a started following. a started following. etc.)
  def self.remove_relationship(follower, followed)
    Relationship.all(:conditions => {:user_id => followed.id, :related_user_id => follower.id}).map(&:destroy)
    Activity.delete_all ['activity_type_id = ? AND content_id = ? AND from_user_id = ?', Activity.mapid(:added_as_friend),
                         followed.id, follower.id]

    unless followed.collection?
      # Remove any f. feed entries from followed user to ex-follower
      FeedEntry.remove_directed_entries(follower, followed)
    else
      #advanced case
      CollectionInclusion.remove_collection_driven_friendfeed_entries(followed, :follower => follower)
    end
  end

  def self.follower_followed_by(opts)
    followed = opts[:followed]; followed = User.find(followed) unless followed.is_a?(User)
    follower = opts[:follower]; follower = User.find(follower) unless follower.is_a?(User)
    
    return follower, followed
  end
  
  # Extend to one month from existing expiration or now, whichever is larger
  def self.extend_expiration(fromuser, touser, type)
    rel = Relationship.locate_me(fromuser, touser, type)
    base = [Time.now, rel.expires_at].max
    rel.expires_at = base + 1.month
    rel.save!
  end
  
  def self.change_expiration(fromuser, touser, type, expiration_date)
      rel = Relationship.locate_me(fromuser, touser, type)
      rel.expires_at = expiration_date
      rel.save!
  end
  
  def self.update_relationship_privacylevel(fromuser, touser, type, privacylevel)
      rel = Relationship.locate_me(fromuser, touser, type)
      rel.privacylevel = privacylevel
      rel.save!
    rescue
      nil # let it blow if relationship notformed yet
  end
  
  def update_bitmask_attribute(attribute_key, on_off)
      case attribute_key
      when :friended_through_lj
        self.attributebits = self.attributebits.to_i & ~2 | (on_off ? 2 : 0)
        self.save!
      end
  end
  
  def self.locate_me(fromuser, touser, type)
    Relationship.find(:first, :conditions => {:user_id => touser.id, :related_user_id => fromuser.id, :relationshiptype_id => type})
  end
  
  def self.populate_friendfeed(follower, followed, options = {})
    options.reverse_merge!(:circle_type => Relationshiptype::TYPES[:interested], :limit => 50, :from_collection => followed.collection?)
    added = Set.new
    activity_sources = [followed.id]
    if followed.collection?
      activity_sources += CollectionInclusion.children_of(followed.id).unstopped.map(&:child_user_id)
    end
    activities = Activity.with_user(activity_sources).self_owned.newest_first.top(options[:limit]*3)
    
    activities = activities.select do |activity|
      result = true &&
              activity.content &&
              !added.include?(activity.content) &&
              activity.in_id_group?(:friendcast) &&
              Activity.levels_can_see(activity.content).include?(options[:circle_type]) &&
              true
      
      added << activity.content
      result
    end
    #user can get some of collection events as direct project follower
    #or he can get some of project events as collection follower
    #let's not dupe them
    activities = FeedEntryActivity.substract_existing(activities, follower)

    activities = activities[0..(options[:limit]-1)]
    return if activities.empty?
    activities.each {|a| FeedEntry.create_for(follower.id, a, :from_collection => options[:from_collection])}
    log.info "#{activities.count} f.feed entries added to #{follower.login}'s friend feed from #{followed.login}"
  end

  def self.can_invite_closer?(followed, follower)
    return false if followed.id == follower.id
    return false if follower.collection?
    circles = followed.circles
    return false if circles.count == 1
    existing = Relationship.relationships(followed, follower, Relationshiptype.all_valid - [Relationshiptype.family, Relationshiptype.founders]).first
    return false if !existing
    return circles.any? {|c| c.relationshiptype_id < existing.relationshiptype_id}
  end

  def move_to_interested
    self.update_attribute(:relationshiptype_id, Relationshiptype::TYPES[:interested])
  end

  def move_to_friends
    self.update_attribute(:relationshiptype_id, Relationshiptype::TYPES[:backstage])
  end

  def move_to_fanclub
    self.update_attribute(:relationshiptype_id, Relationshiptype::TYPES[:fanclub])
  end

  def move_to_studio
    self.update_attribute(:relationshiptype_id, Relationshiptype::TYPES[:family])
  end

  private

  def create_relationship_message
    receiver = self.user

    people_to_contact = if receiver.project?
      ids = receiver.people_tracking_me.kroogi_notifications.map(&:tracking_user_id).uniq
      User.active.all(:conditions => {:id => ids}, :include => :preference)
    else
      [receiver]
    end

    people_to_contact.each do |recipient|
      next unless recipient.active?
      next if recipient == self.related_user
      circle = receiver.circle(self.relationshiptype_id)
      next if Activity.exists?({:user_id => recipient.id, :from_user_id => self.related_user_id,
          :activity_type_id => Activity::ACTIVITIES[:getcloser_granted][:id], :content_type => 'UserKroog'})

      Activity.send_message(
        circle, self.related_user, :added_as_friend,
        {:to_user => recipient}, {:show => recipient.preference.kroogi_notify_joins_interested_circle?})
    end
  end

  def self.downgrade_relationship_message(owner, exfollower, current_actor, relationshiptype_id)
    return # #4701: don't notify when user go down in circles 

    receiver = current_actor.is_self_or_owner?(owner) ? exfollower : owner

    people_to_contact = if receiver.project?
      ids = receiver.people_tracking_me.kroogi_notifications.map(&:tracking_user_id).uniq
      User.active.all(:conditions => {:id => ids}, :include => :preference)
    else
      [receiver]
    end

    people_to_contact.each do |recipient|
      next unless recipient.active?
      next if recipient == current_actor

      Activity.send_message(
        owner.circle(relationshiptype_id), current_actor, :moved_to_down_circle,
        {:to_user => recipient})
    end
  end

  def delete_relationship_message
    receiver = self.user

    people_to_contact = if receiver.project?
      ids = receiver.people_tracking_me.kroogi_notifications.map(&:tracking_user_id).uniq
      User.active.all(:conditions => {:id => ids}, :include => :preference)
    else
      [receiver]
    end

    people_to_contact.each do |recipient|
      next unless recipient.active?
      next if recipient == self.related_user

      Activity.send_message(
        receiver.circle(self.relationshiptype_id),
        self.related_user,
        :removed_from_circle,
        {:to_user => recipient}, {:show => recipient.preference.kroogi_notify_leaves_interested_circle?})
    end
  end

  def can_create_this_relationship?
    return if self.relationshiptype_id == Relationshiptype.founders
    # Users have default circles. we needn't get self.user.preference.active_circle_ids
    raise Kroogi::NotPermitted unless self.user.default_circles.include?(self.relationshiptype_id)
  end

end
