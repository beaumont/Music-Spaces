class WhatYouLike < ActiveRecord::Base

  belongs_to :user
  belongs_to :related_user, :class_name => 'User'
  
  def self.make_user_like_project(options)
    # Handle creating from existing like or independently
    followed   = options.delete(:followed)
    follower   = options.delete(:follower)
    type       = options.delete(:type) || :interested

    # Ensuring we have user objects, not just ids
    follower = User.active.find(follower) unless follower.is_a?(User)
    followed = User.active.find(followed) unless followed.is_a?(User)

    type = Relationshiptype::TYPES[type] if type.is_a?(Symbol)
    raise "Nobody to establish relationship between, or no relationship type" unless followed && follower && type
    raise "Can't establish relationship with yourself" if followed == follower

    # Create the requested like
    like = WhatYouLike.create(
      :user_id => followed.id,
      :related_user_id => follower.id,
      :relationshiptype_id => type
    )

    like
  end

  def self.break_user_like_project(opts)
    followed = opts[:followed]; followed = User.find(followed) unless followed.is_a?(User)
    follower = opts[:follower]; follower = User.find(follower) unless follower.is_a?(User)
    WhatYouLike.delete_all(:user_id => followed.id, :related_user_id => follower.id)
  end

  def self.has_liker?(liked_projects_or_ids, liker, types = nil)
    if liked_projects_or_ids.is_a?(User)
      return false if liked_projects_or_ids.guest?
      liked_projects_or_ids = [liked_projects_or_ids.id]
    elsif !liked_projects_or_ids.is_a?(Array)
      liked_projects_or_ids = [liked_projects_or_ids]
    end
    return false if liker.nil? || liker.guest?
    types = Relationshiptype.followers_and_founders_types unless types
    count = WhatYouLike.count_by_sql(['select count(id) as cnt from what_you_likes where
      what_you_likes.user_id in (?) AND what_you_likes.related_user_id = ? AND relationshiptype_id IN (?)', liked_projects_or_ids, liker.id, types]).to_i
    return false if count == 0
    count
  end

end