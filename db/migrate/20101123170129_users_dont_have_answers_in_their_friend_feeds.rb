#actually, not precise name: from now on, user will only have his followed users' answers in his friend feed
class UsersDontHaveAnswersInTheirFriendFeeds < ActiveRecord::Migration
  def self.up
    remove_column(:rare_user_settings, :wants_answers_in_friend_feed) rescue nil
  end

  def self.down
  end
end
