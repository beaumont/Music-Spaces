class UserMayWantNoAnswersInFriendFeed < ActiveRecord::Migration
  def self.up
    add_column :rare_user_settings, :wants_answers_in_friend_feed, :boolean
  end

  def self.down
  end
end
