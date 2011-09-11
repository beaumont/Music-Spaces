# == Schema Information
# Schema version: 20081006211752
#
# Table name: activities
#
#  id               :integer(11)     not null, primary key
#  user_id          :integer(11)     not null
#  activity_type_id :integer(4)
#  status           :integer(4)      default(1), not null
#  db_file_id       :integer(11)
#  from_user_id     :integer(11)
#  from_username    :string(30)
#  content_id       :integer(11)
#  content_type     :string(20)
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  friendcast       :boolean(1)
#

require "hash"
class Activity < ActiveRecord::Base
  #skip_caching
  before_save :increment_counts
  before_destroy :clear_user_cache
  after_save :clear_user_cache
  
  belongs_to :user
  belongs_to :from_user, :class_name => 'User', :foreign_key => "from_user_id"
  belongs_to :content, :polymorphic => true

  named_scope :unread_first, :order => 'status, created_at DESC'
  named_scope :newest_first, :order => 'created_at DESC'
  named_scope :unread,              :conditions => {:status => Status::ACTIVE}
  named_scope :not_friends,         :conditions => {:friendcast => false}
  named_scope :only_friends,        :conditions => {:friendcast => true}
  named_scope :read_and_unread,     :conditions => {:status => [Status::ACTIVE, Status::READ]}
  named_scope :today,  lambda {       { :conditions => ['created_at > ?', 1.day.ago] } }
  named_scope :top,    lambda {|size| { :limit => size || 5} }
  
  named_scope :not_from,  lambda {|who| { :conditions => ['from_user_id <> ?', who.id]} }
  named_scope :only_from, lambda {|user_ids| user_ids = [user_ids.id] if user_ids.is_a?(User); { :conditions => {:from_user_id => user_ids}} }

  named_scope :without_user,    lambda {|who| { :conditions => ['user_id <> ?', who.id]} }
  named_scope :with_user,       lambda {|user_ids| user_ids = [user_ids.id] if user_ids.is_a?(User); { :conditions => ['user_id in (?)', user_ids]} }

  
  # Limits to given types (ids or symbols). If filters (from params) given, return only intersection of filters and types.
  named_scope :only,   lambda { |*types| { :conditions => {:activity_type_id => limit_type_to(types) } } }
  named_scope :except, lambda { |*types| { :conditions => {:activity_type_id => all_type_ids - limit_type_to(types) } } }
  named_scope :for_content, lambda { |thing| { :conditions => {:content_type => content_types(thing), :content_id => thing.id} } }
  named_scope :self_owned, :conditions => ['from_user_id = user_id']
  named_scope :tps_messages, lambda {{:conditions => ['activity_type_id in (?)', id_group(:tps)]}}
  named_scope :displayed, :conditions => {:show => true}

  attr_accessor :dont_increment, :skip_ccing
    
  ACTIVITIES = {
    # Messages sent from me to a single person when
    # Comment on their's post
    :comment_made => {:id => 1, :cc_myself => true},
        
    # Comment on their's profile
    :comment_replied_to => {:id => 2, :cc_myself => true},

    # Add them as a friend
    :added_as_friend => {:id => 3, :cc_myself => false}, # TODO: ask AV what is cc_myself?

    # Add their content as a favorite
    :added_as_favorite => {:id => 4, :cc_myself => true, :friendcast => true},
        
    # Invite them to my circle
    :invite_sent => {:id => 5},
        
    # my invitation is accepted or denied
    :invite_accepted =>   {:id => 6, :invert_sender => true},
    :invite_denied =>     {:id => 7, :invert_sender => true},
    :invite_reinvited =>  {:id => 8},
    :invite_cancelled =>  {:id => 9},    # Cancelled == you were removed.    OBSOLETE. use removed_from_circle
    :invite_deleted =>    {:id => 10},      # Deleted == you removed yourself.  OBSOLETE. use removed_from_circle
    :removed_from_circle => {:id => 11},
    :moved_to_down_circle => {:id => 16},
    :moved_to_up_circle => {:id => 17},
        
    # Sent them private message
    :sent_pvtmsg => {:id => 12, :cc_myself => true},
        
    # sent get closer request
    :sent_getcloser => {:id => 13, :cc_myself => false},
    :getcloser_granted => {:id => 15, :cc_myself => false},
        
    # logged in activity, mostly used for activity tracking and is not displayed anywhere
    :logged_in => {:id => 14, :cc_myself => false},
        

    # Messages sent to everybody in my krug of Friend (broadcasted) when I
    # Publish Content
    :published_image        => {:id => 100, :cc_myself => true, :friendcast => true},
    :published_track        => {:id => 101, :cc_myself => true, :friendcast => true},
    :published_blog         => {:id => 102, :cc_myself => true},
    :published_writing      => {:id => 103, :cc_myself => true, :friendcast => true},
    :published_announcement => {:id => 104, :cc_myself => true, :friendcast => true},
    :published_topic        => {:id => 105, :cc_myself => true},
    :published_album        => {:id => 106, :cc_myself => true, :friendcast => true},
    :published_music_album  => {:id => 107, :cc_myself => true, :friendcast => true},
    :published_video        => {:id => 108, :cc_myself => true, :friendcast => true},
    :published_inbox        => {:id => 109, :cc_myself => true, :friendcast => true},
    :added_project_to_collection => {:id => 111, :cc_myself => true, :friendcast => true},
    :published_music_contest => {:id => 112, :cc_myself => true},
    :published_question     => {:id => 113, :cc_myself => true, :friendcast => true},
    :published_answer       => {:id => 114, :cc_myself => true, :friendcast => true},
    :published_usernote     => {:id => 115, :cc_myself => true, :friendcast => true},

    :submitted_to_inbox     => {:id => 120, :cc_myself => true},
    :accepted_from_inbox    => {:id => 121, :cc_myself => true, :friendcast => true},
    :content_item_adopted   => {:id => 122},
        
    # Create a project
    :created_project        => {:id => 150, :cc_myself => true, :friendcast => true},

    # More selective broadcasting (logic handled elsewhere)
    :alert_forum_post       => {:id => 160},
    :inbox_submission_received => {:id => 161},
    :inbox_submission_accepted => {:id => 162},
        
    # Money events
    # Generic messages, need logic added later to track what exactly changed
    :donation_account_added    => {:id => 200},
    :donation_account_changed  => {:id => 201},
    :donation_account_removed  => {:id => 202},
       
    # Alert user to admin response to paypal account verification
    :paypal_account_verified   => {:id => 203},
    :paypal_account_rejected   => {:id => 204},
       
    # General systems approved message
    :payments_systems_approved => {:id => 220},

    # Other admin events
    :user_featured =>  {:id => 300},
    :content_featured =>  {:id => 301},

    # donation coupons
    #:coupon_received => {:id => 302},

    # purchased content
    :content_purchased => {:id => 303, :reverse_recepient => true},

    :donation_received => {:id => 306},
        
    :account_blocked => {:id => 310},
    :account_restored => {:id => 311},
    :content_blocked => {:id => 312},
    :content_restored => {:id => 313},
        
    # User clicked download link for a music album or folder
    :content_downloaded => {:id => 319, :reverse_recepient => true},

    # Downloaded a downloadable content item (at time written, only supports Track)
    :content_download_initiated => {:id => 320},

    #currently it's about FB users sending album invites, but let it be generic
    :content_invite_sent => {:id => 321},

    :content_published_to_wall => {:id => 322},

    :content_saved_to_my_albums => {:id => 323},

    :author_answered_his_question => {:id => 340, :cc_myself => true, :friendcast => true},
    :author_commented_an_answer => {:id => 341, :cc_myself => true, :friendcast => true},

    #different than :content_download, because we don't want it to increase downloads counter by itself 
    :content_download_link_given => {:id => 342, :reverse_recepient => true},
    :tps_participant_info_request_sent => {:id => 350},
    :tps_participant_info_request_answered => {:id => 351},
    :tps_participant_was_questioned => {:id => 352},
    :tps_participant_answered => {:id => 353},
    :tps_goodie_bought => {:id => 360, :reverse_recepient => true},
    :goodie_bought => {:id => 365, :reverse_recepient => true},
  }
    
  # Messages sent to Me Only when I:
  # use :cc_myself => true flag for those
  # Publish content
  # Comment on someone's post
  # Comment on someone's profile
  # Add a friend
  # Add a favorite
  # Create a project

  def self.type_group(type)
    # General categories to simplify the group selecting, and make it make more sense
    published_content = [ :published_album, :published_image, :published_track, :published_blog, 
      :published_writing, :published_announcement, :published_usernote, :created_project, :published_video,
      :published_inbox, :accepted_from_inbox, :added_project_to_collection, :published_music_album, :published_question,
      :published_answer, :author_answered_his_question, :author_commented_an_answer]
    other_public      = [ :submitted_to_inbox ]
    comments          = [ :comment_made, :comment_replied_to, :published_answer, :author_commented_an_answer]
    favorited         = [ :added_as_favorite]
    money             = [ :donation_account_added, :donation_account_changed, :donation_account_removed, :donation_received, :payments_systems_approved]
    featured          = [ :user_featured, :content_featured]
    personal          = [ :sent_pvtmsg, :content_purchased, :content_download_initiated, :content_downloaded,
                          :content_download_link_given, :account_blocked, :account_restored, :added_as_friend,
                          :alert_forum_post, :inbox_submission_received, :inbox_submission_accepted]
    invites           = [ :invite_sent, :invite_reinvited, :invite_accepted, :invite_denied, :invite_cancelled, :invite_deleted, :removed_from_circle]
    invites_requests_accepted = [:invite_accepted, :getcloser_granted]
    invite_sent       = [ :invite_sent, :invite_reinvited]
    invite_requests   = [ :sent_getcloser, :getcloser_granted]
    tps               = [ :tps_participant_info_request_sent, :tps_participant_info_request_answered,
                          :tps_participant_was_questioned, :tps_participant_answered, :tps_goodie_bought,
                          :goodie_bought]
    friending         = [:removed_from_circle, :moved_to_down_circle, :moved_to_up_circle]
    
    case type
        # Recent entries from your network
      when :content_river   then published_content - [:published_blog] + favorited

        # Shown on /activity/list to current_actor (and maybe owners) only. Show reinvites, but not first invites.
        # Can show published content, because filtering out all by current user -- so owner can see project's posts
      when :private_feed    then comments + favorited + featured + money + personal + tps + friending + invites_requests_accepted

        # Displayed on user's Kroogi Page and in their RSS feed
      when :public_feed     then published_content + comments + favorited + featured + other_public

        # When an invite is deleted, remove all associated messages except these (closed, accepted, etc)
      when :invite_handled  then invites - invite_sent
      when :invites then invites

        # These are just for in-model convenience
      when :published_content then published_content
      when :comments then comments
      when :favorited then favorited
      when :money then money
      when :featured then featured
      when :personal then personal
      when :invites then invites
      when :invite_sent then invite_sent
      when :invite_requests then invite_requests
      when :other_public then other_public
      when :tps then tps
      when :friendcast then ACTIVITIES.keys.select {|key| ACTIVITIES[key][:friendcast]}
    end
  end
  
  def self.id_group(type)
    symbols = type_group(type)
    symbols.collect {|x| mapid(x)}.compact.uniq
  end
  
  def self.content_name(content_obj)
    if content_obj.respond_to?('cat_id') && content_obj.cat_id && content_obj.cat_id > 0 && !content_obj.is_a?(MusicContest)
      cname = Content::CATEGORIES.find{|key_val| key_val[1][:id] == content_obj.cat_id}[1][:name]
    elsif content_obj.is_a?(MusicContest)
      # translation hint: 'Music Contest'.t
      cname = 'music contest'
    else
      cname = content_obj.class.name.to_s
    end
    cname.tdown
  end
  
  def comment
    self.content_type == 'Comment' ? content : nil
  end
  alias_method :comment?, :comment
  
  # Who is responsible? (showing actual user who did it, if it was on behalf of a project)
  # Handles :public_feed cases
  def who_did_it
    # If msg is about publishing something, return content's creator
    # If msg is about someone commenting, return the person who commented
    if Activity.type_group(:published_content).include?(self.keyname) || Activity.type_group(:comments).include?(self.keyname)
      content.created_by
      # If msg is about someone favoriting, return the person doing the favoriting
    elsif Activity.type_group(:favorited).include?(self.keyname)
      nil # favorite activities point to the content, not the favorite, so we don't know who actually favorited on behalf of project
    else
      # return from_user
      # Not sure yet how to handle other cases
      nil
    end
  end
  
  def content_is_viewable?
    log.debug "content_is_viewable?: activity #{id}"
    return true if self.content.is_a?(ProjectAsContent)
    
    self.content && 
      self.content.try(:is_view_permitted?) &&
      # IF activity is a comment, comment's content mube be viewable
    (
      !(self.keyname == :comment_made || self.keyname == :comment_replied_to) ||
        self.content.commentable && self.content.commentable.is_view_permitted?
    ) && 
      # IF activity is for a inboxitem, see if the content itself is viewable
    (
      !(self.keyname == :submitted_to_inbox) || self.content.content.is_view_permitted?
    ) &&
    (
      !(self.content.respond_to?(:private?) && self.content.private? && !current_actor.is_self_or_owner?(self.content.is_a?(User) ? self.content : self.content.user))
    ) &&
      Activity.partial_exists?(self)
  end
  
  def self.partial_exists?(activity)
    keyname = activity.keyname
    keyname = :comment_made_or_replied_to if keyname.to_s.match(/comment/)
    rhtml = File.join(RAILS_ROOT, 'app', 'views', 'activity', 'messages', "_#{keyname}.rhtml")
    erb = File.join(RAILS_ROOT, 'app', 'views', 'activity', 'messages', "_#{keyname}.html.erb")
    File.exists?(erb) || File.exists?(rhtml)
  end
  
  def self.mapid(keyname)
    Activity::ACTIVITIES[keyname] ? Activity::ACTIVITIES[keyname][:id] : nil
  end

  def self.keyname(activity_type_id)
    res = ACTIVITIES.find{|key_val| key_val[1][:id] == activity_type_id}
    res[0] if res    
  end

  def keyname
    Activity.keyname(self.activity_type_id)
  end
  
  def display_name
    Activity.display_name(self)
  end
  
  def self.display_name(obj)
    return unless obj.respond_to?('activity_type_id')
    Activity::ACTIVITIES.find{|key_val| key_val[1][:id] == obj.activity_type_id}[1][:name]
  end
  
  def unread?
    self.status == Status::ACTIVE
  end
  
  def skip_emails?
    @skip_emails_on_create
  end
  
  # So alerts for projects don't require emails
  def skip_emails!
    @skip_emails_on_create = true
  end
  
  # Choose who to send to based on content type
  def self.target_user_from_content(content, from, activity_type, opts = {})
    return opts[:to_user] unless opts[:to_user].blank?
    return content.reportable if (activity_type == :account_blocked || activity_type == :account_restored)
    return content.reportable.user if (activity_type == :content_blocked || activity_type == :content_restored)

    tu = case content.class.name
      when BasicUser.name, AdvancedUser.name then content
      when Project.name              then (activity_type == :created_project) ? content.project_founders.first : content
      when Pvtmessage.name           then content.recipient
      when InviteRequest.name        then content.wants_to_join
      when Invite.name               then (activity_type == :invite_accepted || activity_type == :invite_denied) ? content.inviter : content.user
      when MonetaryDonation.name     then content.receiver.user
      when Comment.name              then
        if activity_type == :comment_replied_to
          content.parent.user
        elsif activity_type == :tps_participant_was_questioned
          content.commentable.user
        elsif activity_type == :tps_participant_answered
          content.commentable.content.user
        else
          content.commentable.user # comment_replied_to doesn't care about target_user -- later on it's shifted into a separate method
        end
      when UserKroog.name            then (activity_type == :alert_forum_post ? nil : content.user)
      when InboxItem.name            then (activity_type == :submitted_to_inbox) ? content.content.user : content.inbox.user
      when PublicAnswer.name         then content.question.user
      when Tps::GoodieTicket.name    then content.artist
      when Tps::ParticipantInfoRequest.name then
        (activity_type == :tps_participant_info_request_answered ? content.participant.content.user : content.participant.user)
      else                                content.respond_to?(:user) ? content.user : content
    end
    
    return tu
  end

  def content_owner?(user)
    return self.content == user if self.content.is_a?(User)
    self.content.user == user
  end

  def self.send_message(content, from, activity_type, opts = {}, optional_data = {})    
    # Lookup the type
    activity_type = activity_type.to_sym
    raise "unknown activity: #{activity_type}" unless message_type_info = ACTIVITIES[activity_type]

    # Figure out who should be sent message(s) for this activity
    target_user = target_user_from_content(content, from, activity_type, opts)
    return unless target_user || message_type_info[:friendcast] || content.class == FeaturedItem || activity_type == :comment_replied_to || activity_type == :alert_forum_post

    # Send the message(s) as necessary
    @skip_ccing = false
    if message_type_info[:friendcast]
      send_to_all_friends_and_content_owner(content, from, message_type_info, target_user, opts)
    elsif content.class == FeaturedItem then send_for_featured_item(content, message_type_info, optional_data)
    elsif activity_type == :comment_made && content.commentable.flat_comments? then send_for_flat_comment(content, from, message_type_info, optional_data)
    elsif activity_type == :comment_replied_to      then send_for_comment_reply(content, from, message_type_info, optional_data)
    elsif activity_type == :alert_forum_post        then send_for_forum_post_alert(content, from, message_type_info, optional_data)
    elsif message_type_info[:reverse_recepient]          then Activity.create_for(from, target_user, content, message_type_info[:id], optional_data)       # there should really be a better way to send system messages ...
    else
      @skip_ccing = true if from && target_user.id == from.id # skip the cc if i am doing this to myself
      Activity.create_for(target_user, from, content, message_type_info[:id], optional_data)
    end

    #we send this both to f. feed and to Messaging Center
    if activity_type == :author_commented_an_answer
      send_for_flat_comment(content, from, message_type_info, optional_data, false) #skip answer owner here - it's already processed in friends sender
    end

    #cc me
    Activity.create_for(from, from, content, message_type_info[:id],
      optional_data.merge(:dont_increment => true), :skip_emails => true, :cc_myself => true) if message_type_info[:cc_myself] && !@skip_ccing
  end

  def self.send_to_friend(target_user, activity, processed_friends, options = {})
    return if processed_friends.include?(target_user.id)
    return if target_user.collection? #to populate collections' friend feeds seems to be overkill. let's keep 'em clean. 
    processed_friends << target_user.id
    FeedEntry.create_for(target_user.id, activity, options)
  end

  def self.levels_can_see(activity_content)
    if activity_content.respond_to?(:levels_can_see)
      activity_content.levels_can_see
    else
      Relationshiptype.followers_and_founders_types
    end
  end

  def self.send_to_all_friends_and_content_owner(content, from_user, message_type_info, target_user, opts)

    #send to MC immediately for consistence 
    activity = Activity.create_for(target_user, from_user, content, message_type_info[:id])

    #cc myself if needed, and let this activity be referenced for consistency with Start Following logic
    if message_type_info[:cc_myself] && (!from_user || target_user.id != from_user.id) # skip the cc if i am doing this to myself
      activity = Activity.create_for(from_user, from_user, content, message_type_info[:id],
        {:dont_increment => true}, :skip_emails => true, :cc_myself => true)
    end
    @skip_ccing = true

    args = [activity.id, opts]

    unless APP_CONFIG.disable_bdrb
      key = "send_to_all_friends_#{activity.id}"
      if BdrbJobQueue.find_by_job_key(key)
        log.error "Warning: dupe call of send_to_all_friends_and_content_owner (ignoring). Args were #{args.inspect}, job_key #{key}"
        return
      end
      begin
        MiddleMan.worker(:misc_tasks_worker).enq_send_to_all_friends(:arg => args, :job_key => key)
      rescue => e
        raise "Error scheduling broadcasting to friend feeds: #{e.inspect}. \n Args were #{args.inspect}, job_key #{key}"
      end
    else
      send_to_all_friends(activity, opts)
    end    
  end
  
  # Send an alert to all friends
  def self.send_to_all_friends(original_activity, opts)
    content = original_activity.content
    return unless content
    from_user = original_activity.from_user
    return unless from_user

    friend_types = levels_can_see(content)

    unless friend_types.empty?
      processed_friends = Set.new
      if opts[:add_friends_of]
        Relationship.find_followers_paginated(opts[:add_friends_of], friend_types) do | user |
          send_to_friend(user, original_activity, processed_friends)
        end
      end
      
      Relationship.find_followers_paginated(from_user, friend_types) do | user |
        send_to_friend(user, original_activity, processed_friends)
      end

      unless CollectionInclusion.of_child_project(from_user).unstopped.empty?
        Relationship.find_followers_paginated(CollectionInclusion.of_child_project(from_user).map {|ci| ci.parent_id}, friend_types) do | user |
          send_to_friend(user, original_activity, processed_friends, :from_collection => true)
        end
      end

    end
  end
  
  # Send an alert to all members of this circle and closer circles
  def self.send_for_forum_post_alert(comment, sender, message_type_info, optional_data)
    forum = comment.commentable
    to_alert = [[forum] + forum.closer_circles].flatten.map(&:members).flatten
    to_alert.each do |u|
      Activity.create_for(u, sender, comment, message_type_info[:id], optional_data)
    end
  end
  
  # Send messages to the writer of the comment replying to, plus the owner of the content, if available
  def self.send_for_comment_reply(comment, from, message_type_info, optional_data)
    reply_to = comment.parent.user
    content_owner = comment.commentable.try(:user)
    
    [reply_to, content_owner].compact.uniq.each do |to_user|
      @skip_ccing = true if from && to_user.id == from.id # skip the cc if i am doing this to myself
      Activity.create_for(to_user, from, comment, message_type_info[:id], optional_data)
    end
  end
  
  def self.send_for_flat_comment(comment, from, message_type_info, optional_data, send_to_content_owner = true)
    content_owner = comment.commentable.user

    other_commenters = comment.commentable.all_comments(false).map {|c| c.user}.uniq - [from]
    other_commenters.reject! {|x| x && x.anonymous?}
    other_commenters += [content_owner] if send_to_content_owner
    other_commenters.compact.uniq.each do |to_user|
      @skip_ccing = true if to_user == from # skip the cc if i am doing this to myself
      Activity.create_for(to_user, from, comment, message_type_info[:id], optional_data)
    end
  end

  def self.send_for_featured_item(content, message_type_info, optional_data)
    # Send to project owners, if project featured. If content featured, send to content owner if user, content owner's founders if proj
    to_notify = if content.is_project? then content.item.project_founders + content.item
    elsif content.is_content?
      content.item.user.project? ? content.item.user.project_founders + content.item.user : [content.item.user]
    end

    # set FROM to kroogi_project
    from = Project.kroogi
    to_notify.each do |recipient|
      Activity.create_for(recipient, from, content, message_type_info[:id], optional_data)
    end
  end
    
  def mark_read
    self.dont_increment = true
    return if self.status != Status::ACTIVE
    what = {:user_id => self.user_id, :activity_type_id => self.activity_type_id}
    counter = ActivityCounts.find(:first, :conditions => what) || ActivityCounts.new(what)
    counter.unread = counter.unread - 1
    counter.save!
    self.update_attributes(:status => Status::READ)
  end

  def mark_new
    self.dont_increment = true
    return if self.status == Status::ACTIVE
    what = {:user_id => self.user_id, :activity_type_id => self.activity_type_id}
    counter = ActivityCounts.find(:first, :conditions => what) || ActivityCounts.new(what)
    counter.unread = counter.unread + 1
    counter.save!
    self.update_attributes(:status => Status::ACTIVE)
  end

  
  def mark_done
    self.dont_increment = true
    return if self.status == Status::DISABLED
    what = {:user_id => self.user_id, :activity_type_id => self.activity_type_id}
    counter = ActivityCounts.find(:first, :conditions => what) || ActivityCounts.new(what)
    counter.unread = counter.total - 1
    counter.unread = counter.unread - 1 if self.status != Status::READ 
    counter.save!
    self.update_attributes(:status => Status::DISABLED)
  end
  
  # Given a mixed array of symbols and ids, return ids of valid activities (converting symbols to appropriate ids)
  def self.type_ids_from_mixed(types)
    types = [types] unless types.is_a?(Array)
    types.collect { |t|
      if t.is_a?(Symbol) then mapid(t)
      elsif t.is_a?(Fixnum) || t.is_a?(String) && Activity::ACTIVITIES.detect{|key,val| val[:id] == t.to_i} then t.to_i
      else raise "unrecognized type: #{t.inspect}"
      end
    }.compact.uniq
  end
  
  def self.create_for(to_user, from_user, content, type_id, optional_data = {}, options = {})
    options.reverse_merge!(:skip_emails => false)
    optional_data.reverse_merge!(:dont_increment => false, :friendcast => false, :created_at => Time.now)
    
    return nil if to_user.nil?

    new_activity = Activity.new(optional_data.merge(
        :user_id => to_user.id,
        :from_user_id => from_user ? from_user.id : nil,
        :from_username => from_user ? from_user.login : nil,
        :content => content,
        :activity_type_id => type_id)
    )
    new_activity.status = Status::READ if options[:cc_myself]
    new_activity.skip_emails! if options[:skip_emails]
    new_activity.save! #unless user == from_user # needs more checks for certain content
    new_activity
  end
  

  def self.limit_type_to(types)
    types = [types] unless types.is_a?(Array)
    types = types[0] if types.size == 1 && types[0].is_a?(Array)
    valid_filters = if types[1] && types[1].is_a?(Hash)
      # A filter was given, apply it (allow e.g. 101,103,105, as well as just 101). 
      filters = types[1][:filter]
      types = types[0]
      unless filters.nil?
        type_ids_from_mixed(filters.split(','))
      end
    end
    
    limit_to = type_ids_from_mixed(types)
    limit_to = limit_to & valid_filters unless valid_filters.blank? # Gracefully degrade to unfiltered if no valid filters given
    return limit_to
  end

  def self.all_type_ids
    ACTIVITIES.collect{|x| x[1][:id]}
  end

  def purchase?
    id == ACTIVITIES[:content_purchased][:id]
  end

  def monetary_donation
    MonetaryDonation.find_by_id(self.monetary_donation_id)
  end

  def anonymous?
    user_id == -1
  end

  def in_id_group?(group_key)
    self.class.id_group(group_key).include?(activity_type_id)
  end

  def pvtmessage?
    Activity::ACTIVITIES.find {|k, v| v[:id] == self.activity_type_id}.first == :sent_pvtmsg
  end

  private
  def clear_user_cache
    log.debug "clear_user_cache"
    unless ACTIVITIES[keyname][:invert_sender]
      user = self.user
    else
      user = self.from_user
    end
    user.clear_unread_message_count_cache if user
    true
  end
  
  def increment_counts
    return true if self.dont_increment || self.user_id.nil?
    what = {:user_id => self.user_id, :activity_type_id => self.activity_type_id}
    counter = ActivityCounts.find(:first, :conditions => what) || ActivityCounts.new(what)
    counter.total = counter.total.next
    counter.unread = counter.unread.next
    counter.save!
  end

  # See ticket #2084. Apparently we have a number of activity items whose timestamps are set months BEFORE the creation of their associated content items. Not sure why, but this at least cleans them (careful -- remarkably hard on the DB!)
  def self.clean_activity_dates
    last_ran = Time.parse("Sat Feb 28 01:33:23 +0000 2009")
    dates_are_off = []
    date_offsets = []
    puts "Searching for all activities with content..."
    all_activities_under_consideration = Activity.find(:all, :conditions => ['content_id is not null and created_at > ?', last_ran], :include => :content)
    puts "Found #{all_activities_under_consideration.count} matching activities"
    all_activities_under_consideration.each do |activity_with_content|
      next unless activity_with_content.content && activity_with_content.content.respond_to?(:created_at) && activity_with_content.content.created_at

      if activity_with_content.created_at < activity_with_content.content.created_at
        puts "Activity #{activity_with_content.id} is older than its associated content. Moving #{activity_with_content.created_at} to #{activity_with_content.content.created_at}"
        dates_are_off << activity_with_content.id
        date_offsets << [activity_with_content.created_at, activity_with_content.content.created_at]
        new_vals = {:created_at => activity_with_content.content.created_at}
        if activity_with_content.updated_at < activity_with_content.content.created_at
          new_vals.merge!({:updated_at => activity_with_content.content.created_at})
        end
        activity_with_content.update_attributes(new_vals)
      end
    end
    puts "Cleaned #{dates_are_off.size} date mismatches"
    # [dates_are_off, date_offsets]
  end

  def self.content_publishing_type_key(content)
    return :published_music_album if content.is_a?(MusicAlbum)
    return :published_album if content.is_a?(Album)
    return :published_image if content.is_a?(Image)
    return :published_track if content.is_a?(Track)
    return :published_video if content.is_a?(Video)
    return :published_writing if content.is_a?(Textentry)
    return :published_usernote if content.is_a?(Board) && content.usernote?
    return :published_announcement if content.is_a?(Board) && !content.usernote?
    return :published_inbox if content.is_a?(Inbox)
    raise "unknown content type: #{content.class.name}"
  end

  def self.content_publishing_type_id(content)
    mapid(content_publishing_type_key(content))
  end

  def self.content_types(thing)
    thing.is_a?(Content) ? [thing.class.to_s, 'Content'] : (thing.is_a?(User) ? [thing.class.to_s, 'User'] : [thing.class.to_s])
  end
end
