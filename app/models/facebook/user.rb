module Facebook
  class User < ::User
    has_one :details, :class_name => 'Facebook::UserDetails', :dependent => :delete

    def kroogi_dowload_user?
      self.details.is_kd_user
    end
    
    def facebook_connected?
      false
    end

    def self.default_circles
      [5]
    end

    def default_circles
      self.class.default_circles
    end

    def default_circle_teasers
      #lambda needed to have it translated to particular language later
      [lambda{'Express interest in {{username}}, get updates from him' / self.display_name}]
    end

    def default_circle_names
      #lambda needed to have it translated to particular language later
      [lambda{'Interested'.t}]
    end

    def facebook_id
      self.details.fb_user_id
    end

    def facebook_display_name
      Rails.cache.fetch(facebook_display_name_key, :expires_in => 5.minutes) do
        Facebooker::User.new(self.facebook_id).name
      end
    end

    def friends_with_this_app
      facebooker_user = Facebooker::User.new(self.facebook_id)
      Rails.cache.fetch(friends_with_this_app_key, :expires_in => 5.minutes) do
        facebooker_user.friends_with_this_app
      end
    end

    def friends_activities
      return [] unless friends_with_this_app
      friends = friends_with_this_app.map {|fb_user| User.find_by_fb_user(fb_user.uid)}.reject {|friend| !friend}
      friends_filtered = friends.reject {|friend| friend.total_music_albums_in_collection == 0}
      friends_filtered[0..4].sort_by {|friend| friend.total_music_albums_in_collection}.reverse
    end

    def self.find_or_create(fb_user_id, facebook_session, opts = {})
      user = UserDetails.find_user(fb_user_id, opts)
      if user
        unless facebook_session.nil?
          user.details.maybe_update(facebook_session.session_key)
        end
        yield(user) if block_given?
      else
        user = self.new(:login => fb_user_id.to_s, :crypted_password => "", :email => "")
        fb_session_key = facebook_session.nil? ? nil : facebook_session.session_key
        self.transaction do
          user.save_without_validation!
          user.create_details(:fb_user_id => fb_user_id, :fb_session_key => fb_session_key, :is_kd_user => opts[:is_kd_user])
          user.preference.update_attribute(:email_notifications, Preference::EMAIL[:none]) 
        end
        user.update_attribute(:state, 'invited') if opts[:invited]
      end
      user
    end

    def mark_deleted!
      self.state = 'deleted'
      self.save_without_validation!
    end

    def self.find_by_fb_user(*args)
      UserDetails.find_user(args, :is_kd_user => 1)
    end

    def linked_artist_id
      self.details.linked_artist_id
    end

    def header_text
      self.details.header_text
    end

    def is_linked_to_artist?
      !self.details.linked_artist_id.nil?
    end

    def last_fb_activities(limit)
      select = <<-EOSQL
        SELECT activities.*,
         MAX(activities.created_at) AS last_action_at
  			 FROM `activities`
  			 WHERE ((activities.activity_type_id IN (303,319) AND (user_id = #{self.id})) OR (activities.activity_type_id IN (321,322,323) AND (from_user_id = #{self.id})))
  			 GROUP BY content_id
  			 ORDER BY last_action_at DESC
         LIMIT #{limit}
      EOSQL
      
      Activity.find_by_sql(select)
    end

    def total_music_albums_in_collection
      select = <<-EOSQL
        SELECT activities.*
  			 FROM `activities`
  			 WHERE ((activities.activity_type_id IN (303,319) AND (user_id = #{self.id})) OR (activities.activity_type_id IN (321,322,323) AND (from_user_id = #{self.id})))
  			 GROUP BY content_id
      EOSQL
      Activity.find_by_sql(select).count
    end

    #User Activities
    def fb_activities(*args)
      options = (args.length > 0) ? args.pop : Hash.new
      options.assert_valid_keys :per_page, :page, :conditions, :cumulative

      select = <<-EOSQL
        SELECT activities.*, gross_amount_usd,
  			 MAX(activities.created_at) AS last_action_at,
  			 SUM(monetary_transactions.gross_amount_usd) AS amount_total,
  			 COUNT(activities.id) AS num_action
  			 FROM `activities`
  			 LEFT JOIN monetary_transactions ON activities.monetary_transaction_id = monetary_transactions.id and monetary_transactions.type = 'MonetaryDonation'
  			 WHERE ((activities.activity_type_id IN (303,319) AND (user_id = #{self.id})) OR (activities.activity_type_id IN (321,322,323) AND (from_user_id = #{self.id})))
  			 GROUP BY content_id
  			 ORDER BY last_action_at DESC
      EOSQL

      options[:page]       ||= 1
      args.push options
      Activity.paginate_by_sql(select, *args)

    end

    def self.fb_friend_activities(*args)
      options = (args.length > 0) ? args.pop : Hash.new
      options.assert_valid_keys :friend, :per_page, :page, :conditions, :cumulative

      friend = options[:friend]
      select = <<-EOSQL
        SELECT activities.*, gross_amount_usd,
  			 MAX(activities.created_at) AS last_action_at,
  			 SUM(monetary_transactions.gross_amount_usd) AS amount_total,
  			 COUNT(activities.id) AS num_action
  			 FROM `activities`
  			 LEFT JOIN monetary_transactions ON activities.monetary_transaction_id = monetary_transactions.id and monetary_transactions.type = 'MonetaryDonation'
  			 WHERE ((activities.activity_type_id IN (303,319) AND (user_id = #{friend.id})) OR (activities.activity_type_id IN (321,322,323) AND (from_user_id = #{friend.id})))
  			 GROUP BY content_id
  			 ORDER BY last_action_at DESC
      EOSQL

      options[:page]       ||= 1
      args.push options
      Activity.paginate_by_sql(select, *args)

    end

    def self.has_content_in_collection?(user_id, content_item)
      Activity.find(:all,
        :conditions=>['(activities.activity_type_id IN (?) AND (user_id = ?) AND content_id = ?) OR (activities.activity_type_id IN (?) AND (from_user_id = ?) AND content_id = ?)',
          [Activity::ACTIVITIES[:content_purchased][:id],
            Activity::ACTIVITIES[:content_downloaded][:id],
            Activity::ACTIVITIES[:content_published_to_wall][:id],
            Activity::ACTIVITIES[:content_saved_to_my_albums][:id]
          ],user_id,content_item,Activity::ACTIVITIES[:content_invite_sent][:id],user_id,content_item]).count > 0

    end

    def content_invites_receveived(*args)
      options = (args.length > 0) ? args.pop : Hash.new
      options.assert_valid_keys :per_page, :page, :conditions, :cumulative

      select = <<-EOSQL
        SELECT * FROM activities
        WHERE ((activities.activity_type_id IN (321)) AND (user_id = #{self.id}))
        GROUP BY content_id
        ORDER BY created_at DESC
      EOSQL
      
      options[:page]       ||= 1
      args.push options
      Activity.paginate_by_sql(select, *args)
    end

    def has_sent_content?(content_item)
      Activity.only_from(self).only(:content_invite_sent).for_content(content_item).find(:first)
    end

    def sent_to_friends_count
      Activity.only_from(self).only(:content_invite_sent).count(:group =>"content_id")
    end

    def sent_artist_to_friends_counts(artist)
      Activity.count(:all,
        :select => '*',
        :joins => 'LEFT OUTER JOIN contents C ON C.id = activities.content_id LEFT OUTER JOIN users U ON U.id = C.user_id',
        :conditions => ['(activities.activity_type_id IN (321)) AND (from_user_id = ?) AND (U.id = ?)',self.id,artist.id],
        :group => 'content_id')
    end

    def last_activities_on_content(content_item)
      Activity.find(:first,
        :conditions=>['(activities.activity_type_id IN (?) AND (user_id = ?) AND content_id = ?) OR (activities.activity_type_id IN (?) AND (from_user_id = ?) AND content_id = ?)',
          [Activity::ACTIVITIES[:content_purchased][:id],
            Activity::ACTIVITIES[:content_downloaded][:id],
            Activity::ACTIVITIES[:content_published_to_wall][:id],
            Activity::ACTIVITIES[:content_saved_to_my_albums][:id]],self.id,content_item,Activity::ACTIVITIES[:content_invite_sent][:id],self.id,content_item],
        :order => "created_at DESC")
    end

    def self.friend_last_activities_on_content(content_item,friend_id)
      Activity.find(:first,
        :conditions=>['(activities.activity_type_id IN (?) AND (user_id = ?) AND content_id = ?) OR (activities.activity_type_id IN (?) AND (from_user_id = ?) AND content_id = ?)',
          [Activity::ACTIVITIES[:content_purchased][:id],
            Activity::ACTIVITIES[:content_downloaded][:id],
            Activity::ACTIVITIES[:content_published_to_wall][:id],
            Activity::ACTIVITIES[:content_saved_to_my_albums][:id]],friend_id,content_item,Activity::ACTIVITIES[:content_invite_sent][:id],friend_id,content_item],
        :order => "created_at DESC")
    end

    def content_receive_from_friends(content_item, options = {})
      Activity.find(:all,
        :select=>'content_id, created_at, count(*) AS count_all, from_user_id AS from_user_id',
        :conditions=>['(activities.content_type IN (?) AND activities.content_id = ?) AND (activities.activity_type_id IN (?) AND (user_id = ?))',['MusicAlbum','Content'],content_item, Activity::ACTIVITIES[:content_invite_sent][:id], self.id],
        :group=>'from_user_id',
        :order=>'created_at DESC')
    end

    def self.has_already_received_content?(content,to_user_id,from_user_id)
      Activity.with_user(to_user_id).only_from(from_user_id).only(:content_invite_sent).for_content(content).find(:first)
    end

    def content_download_count(content_item)
      Activity.with_user(self).only(:content_downloaded).for_content(content_item).count
    end

    def content_donate_count(content_item)
      Activity.with_user(self).only(:content_purchased).for_content(content_item).count
    end

    def content_sent_to_friends_count(content_item, options = {})
      @count = []
      if options[:group] == true
        @count = Activity.only_from(self).only(:content_invite_sent).for_content(content_item).count(:group =>"user_id")
      else
        @count = Activity.only_from(self).only(:content_invite_sent).for_content(content_item).count
      end
      @count
    end

    def has_viewed_content?(content_item, from_user_id)
      activity = Activity.find(:first, :conditions => [ "(activities.activity_type_id IN (?) AND (user_id = ?) AND content_id = ? AND from_user_id = ?)", Activity::ACTIVITIES[:content_invite_sent][:id], self.id, content_item, from_user_id])
      activity.status == Status::ACCEPTED if activity
    end

    def has_bookmarked_content?(content_item)
      activity = Activity.find(:first, :conditions => [ "(activities.activity_type_id IN (?) AND (user_id = ?) AND content_id = ? AND from_user_id = ?)", Activity::ACTIVITIES[:content_saved_to_my_albums][:id], self.id, content_item, self.id])
    end
    
    ### Impacts ##
    def download_impact
      ImpactCounter.download.with_user(self).order_by_attr('updated_at','DESC')
    end

    def download_impact_count
      ImpactCounter.download.with_user(self).count
    end

    def dowload_albums_count
       ImpactCounter.download.with_user(self).count(:group =>"content_id")
    end

    def donate_impact_count
      ImpactCounter.donate.with_user(self).count
    end

    def invite_impact_count
      ImpactCounter.invite.with_user(self).count
    end
    
    def download_impact_on_content_counter(content_item)
      ImpactCounter.download.with_user(self).for_content(content_item).count
    end

    def donate_impact_on_content_counter(content_item)
      ImpactCounter.donate.with_user(self).for_content(content_item).count
    end

    def invite_impact_on_content_counter(content_item)
      ImpactCounter.invite.with_user(self).for_content(content_item).count
    end

    #should help validation pass (to be able to just .save!)
    def password_required?
      return false
    end

  end
end

