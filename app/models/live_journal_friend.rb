# == Schema Information
# Schema version: 20090211222143
#
# Table name: live_journal_friends
#
#  id         :integer(11)     not null, primary key
#  account_id :integer(11)     not null
#  last_sync  :datetime        default(Thu Jan 01 00:00:00 -0800 1970)
#

# == Schema Information
# Schema version: 20081224151519
#
# Table name: live_journal_friends
#
#  id         :integer(11)     not null, primary key
#  account_id :integer(11)     not null
#  last_sync  :datetime        default(Thu, 01 Jan 1970 00:00:00 +0300)
#

require 'livejournal/login'
require 'livejournal/friends'

# This class provides friendship caching for livejournal accounts.
# It is not meant to be used as a representation of a Friendship.
class LiveJournalFriend < ActiveRecord::Base
    
  # Checks for livejournal friendships and creates any new friendships for users.
  # 'account' refers to an 'Account' model which represents a LiveJournal Account.
  def self.update_cache_for(account)
    sync = find_or_create_by_account_id(account)
    user = account.authenticate
    return false unless user
    checkfriend = LiveJournal::Request::Friends.new(user, :include_friendsof => true)
    friends = checkfriend.run
    return false if friends.blank?
    friends.each{|f| update_friend(account,f) }
    sync.update_attribute(:last_sync, Time.now)
  end
  
  private
  
  # Update the cache for the provided lj friend for the specified account
  # Only should be accessed from the update_cache_for class method.
  def self.update_friend(account, f)
    if f.is_a?(User)
      logger.debug("++ #{account.username} has friend #{f.username}")
      friend = User.find_by_livejournal_username(f.username) # should update them all not just the first account
      if friend
        raise Exception
        # TODO: Rework this using the relationship model to apply any new friendships
        #       to the outermost circle of friends (interested)
        #
        # friendship = Friendship.find_by_user_id_and_friend_id(account.user_id, friend.id)
        # if friendship.nil? && f.username != account.username
        #   logger.debug("++ #{account.login} is now friends with #{f.username}")
        #   Friendship.create( :user_id   => account.user_id, 
        #                      :friend_id => friend.id,
        #                      :nickname  => f.fullname,
        #                      :accepted_at => Time.now )
        # else
        #   logger.debug("-- skipping #{account.username} having friend #{f.username}")
        # end
      end
    end
  end
  
  
end
