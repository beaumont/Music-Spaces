class UsersCanBeBasicAndAdvanced < ActiveRecord::Migration
  def self.up
    conditions = {:conditions => ['type in (?)', ['AdvancedUser', 'BasicUser', 'User']]}
    count = User.count(conditions)
    page_size = 100
    user_idx = 0
    User.paginated_each(conditions.merge(:order => 'id', :per_page => page_size)) do |user|
      puts "Processed #{user_idx} users out of #{count}." if user_idx % page_size == 0
      user_idx += 1
      next if user.class != User #already processed
      new_type = user_is_advanced?(user) ? AdvancedUser : BasicUser

      user.change_type!(new_type)
    end
    puts "Processed #{user_idx} users: #{AdvancedUser.count} advanced and #{BasicUser.count} basic."
  end

  def self.user_is_advanced?(user)
    #user has money attached?
    return true if user.account_setting && user.account_setting.has_an_approved_account_set?
    
    #does user have content?
    reject_categories = Content.categories_rejected_from_public_stream
    allow_classes = Content.public_stream_classes
    return true if user.contents.all(:conditions => ['type in (?) AND cat_id not in (?)', allow_classes, reject_categories]).count > 0
    return true if user.has_wall_posts?
    return true if user.preference && user.followers_count.reject {|rel| BasicUser.default_circles.include?(rel.relationshiptype_id)}.any? {|rel| rel.cnt.to_i > 0 }

    return true unless user.projects.empty?
    return true unless PublicQuestion.with_user(user).empty?
    return true unless user.inboxes.empty?
    return true unless Board.announcements_of(user).empty?

    false
  end

  def self.down
  end
end
