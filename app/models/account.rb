# == Schema Information
# Schema version: 20090211222143
#
# Table name: accounts
#
#  id               :integer(11)     not null, primary key
#  user_id          :integer(11)     not null
#  crypted_password :text            not null
#  verified         :boolean(1)
#  last_sync        :datetime        default(Thu Jan 01 00:00:00 -0800 1970)
#  created_at       :datetime
#  updated_at       :datetime
#  login            :string(255)
#  connect_friends  :boolean(1)      default(TRUE)
#  last_manual_sync :datetime
#  usejournal       :string(255)
#  friend_circle    :integer(11)
#  allow_friends    :boolean(1)
#  import_mine      :boolean(1)
#

# This class is used for verification and persistance of LiveJournal account information
require 'livejournal/login'
require 'lib/live_journal_friends'
class Account < ActiveRecord::Base
  cattr_accessor :lj_user
  validates_presence_of :user_id, :crypted_password, :login
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
   
  alias_attribute :username, :login
  symmetrically_encrypts :password
  validate :validate_login
  
  @skip_pw_check = false

  belongs_to :user
  has_many :blogs, :through => :entries, :source => :blogentry
  before_destroy :remove_blogs
  has_many :entries,  :class_name => 'LiveJournalEntry', :dependent => :delete_all
  has_many :comments, :class_name => 'LiveJournalComment', :dependent => :delete_all do
    
    # provides the last comment which has meta data
    def last_meta
      find :first, :order => 'comment_id DESC'
    end
    
    # provides the last comment that has a body 
    def last_body
      find :first, :order => 'comment_id DESC', :conditions => ['body IS NOT NULL']
    end
  end
    
  # Provides the account's community name (if available) or login
  def display_name
    usejournal.blank? ? login : usejournal
  end
  
  # A LiveJournal server link based on community or personal journal
  def url
    if is_community?
      "http://community.livejournal.com/"
    else
      "http://#{login}.livejournal.com/"
    end
  end
  
  # A direct link to the account owners page
  def link
    if is_community?
      url + "#{usejournal}"
    else
      url + "profile"
    end
  end
  
  # can has community journal?
  def is_community?
    !usejournal.blank?
  end
  
  # Authenticates a user against LiveJournal with account information and
  # returns a LiveJournal::User object upon success, returns false on error otherwise.
  # Setting the usejournal is required for community blog integration.
  def authenticate
    lj_user = LiveJournal::User.new(self.username, self.password)
    lj_user.usejournal = self.usejournal if is_community?
    login = LiveJournal::Request::Login.new(lj_user)
    login.run
    raise LiveJournal::AuthenticationException if lj_user.fullname.nil?
    return lj_user
  rescue LiveJournal::Request::ProtocolException
    logger.debug "Unable to login as #{self.username}"
    return false
  rescue => e
    logger.debug 'Errored out:' + e.inspect
    false
  end
  
  # TODO: When a user has lots of friends, this will make a sql query for each one
  def import_friends
    logger.debug("checking lj account of user #{self.user.login}")
    return[] unless self.verified? && self.connect_friends?
    logger.debug("importing  lj friends of user #{self.user.login}")
    count = 0
    imp = 0
    for nick in LiveJournalFriends.friends_of(user.livejournal_name) do
      logger.debug("checking for friends of #{nick}")
      friend = User.find_by_livejournal_username(nick)
      logger.debug("found friend for #{}: #{friend.login}") if friend
      count = count.next
      if friend
        next if self.user.follows?(friend)
        
        logger.debug("trying out friending: #{self.user.login} to #{friend.login}")
        if relationship = Relationship.make_user_follow_project(:follower => self.user, :followed => friend)
          relationship.update_bitmask_attribute(:friended_through_lj, true)
          imp = imp.next
        end
      end
    end
    logger.info("Imported #{imp} out of #{count} lj friends for user #{self.user.login}")
  end
  
  # Updates the local cache for this livejournal account
  def update_cache(force = false)    
    if (force || self.last_manual_sync.nil? || self.last_manual_sync < 1.hour.ago)
      LiveJournalEntry.update_cache_for(self, force) 
      self.import_friends
    else
      raise Exception.new('Entries have already been updated within the past hour.'.t)
    end
    #LiveJournalComment.update_cache_for(self)
    #LiveJournalFriend.update_cache_for(self)
  end
  
  def password_required?
    return false if @skip_pw_check
    crypted_password.blank? || !password.blank? 
  end
  
  # force password skipping for validation
  def skip_pw_check!
    @skip_pw_check = true
  end
  
  # clear passwords so they are not available.
  def clear_passwords
     self.password = self.password_confirmation = nil
  end
  
  protected
  
  def validate_login
    return unless password_required?
    errors.add_to_base("#{'Account verification failed'.t}") unless self.send(:verified=, !!authenticate)
  end
  
  def remove_blogs
    self.blogs.each{|d| d.destroy}
  end
    
end
