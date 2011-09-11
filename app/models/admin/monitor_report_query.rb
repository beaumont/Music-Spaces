module Admin
  class MonitorReportQuery
    attr_accessor :users, :logged_in_users, :projects, :contents, :music_albums, :downloads,
      :dwnlds_ma, :dwnlds_tracks, :dwnlds_folders, :contributions, :contributions_total, :comments, :user_types,
      :start_date, :end_date

    def initialize(params)
      return if !params
      @user_types = params[:user_types].map(&:name)
      @start_date = params[:start_date] unless params[:start_date].blank?
      @end_date   = @start_date

      @start_date = @start_date.to_time if @start_date
      @end_date = @end_date.to_time + 1.day - 1.second if @end_date
    end

    def query_total_users
      User.count(:all, :conditions => ["type in (?)", @user_types])
    end

    def query_logged_in_users
      conditions = finder_params_created_at(:table => 'activities')
      conditions = Activity.merge_conditions(conditions,
                                             ["activities.activity_type_id = 14"],
                                             ["users.type in (?)", @user_types])
       join = " LEFT JOIN users ON activities.user_id = users.id"

       facebook_report? ? "0" : Activity.count(:all,
                                               :joins => join,
                                               :conditions => conditions,
                                               :group => "activities.user_id")

    end

    def query_total_projects
      facebook_report? ? "0" : User.count(:all,
                                          :conditions => ["type = 'Project'"])
    end

    def query_total_musicalbums
      if facebook_report?
        MusicAlbum.find(:all).select{|ma| ma.qualify_for_fb}.count
      else
        MusicAlbum.count(:all)
      end
    end

    def query_users
      if facebook_report?
        User.count(:all,
                   :conditions => User.merge_conditions(finder_params_created_at, 
                                                        ["type in (?)", @user_types],
                                                        ["state = 'active'"]))
      else
        User.count(:all,
                   :conditions => User.merge_conditions(finder_params_activated_at, ["type in (?)", @user_types]))
      end
    end

    def query_projects
      if facebook_report?
        "0"
      else
        User.count(:all,
                  :conditions => User.merge_conditions(finder_params_created_at, ["type = 'Project'"]))
      end
    end

    def query_music_albums
      if facebook_report?
        MusicAlbum.find(:all, :conditions => finder_params_created_at).select{|ma| ma.qualify_for_fb}.count
      else
        MusicAlbum.count(:all, :conditions => finder_params_created_at)
      end
    end

    def query_downloads
      join =  "LEFT JOIN contents ON activities.content_id = contents.id"
      join << " LEFT JOIN users ON activities.user_id = users.id"

      conditions = finder_params_created_at(:table => 'activities')
      if facebook_report?
         conditions = Activity.merge_conditions(conditions,
                                             ["activities.activity_type_id = 319"],
                                             ["users.type in (?)", @user_types])
      else
         conditions = Activity.merge_conditions(conditions,
                                             ["activities.activity_type_id = 319"],
                                             ["users.type in (?) or users.type is NULL", @user_types])
      end


      Activity.find(:all,
                    :select => 'activities.*, contents.type ctype',
                    :joins => join,
                    :conditions => conditions,
                    :group => "activities.id")
    end

    def query_donations
      select = 'round(avg(gross_amount_usd),2) avg_gross_amount_usd,' +
               'sum(gross_amount_usd) gross_amount_usd, ' +
               'sum(payable_amount_usd) payable_amount_usd, ' +
               'ifnull(sum(handling_fee_usd), 0) handling_fee_usd, ' +
               'ifnull(sum(monetary_processor_fee_usd), 0) monetary_processor_fee_usd'

      join =  "LEFT JOIN contents ON monetary_transactions.content_id = contents.id"
      join << " LEFT JOIN account_settings ON monetary_transactions.sender_account_setting_id = account_settings.id"
      join << " LEFT JOIN users ON account_settings.user_id = users.id"

      conditions = finder_params_created_at(:table => 'monetary_transactions')
      conditions = MonetaryDonation.merge_conditions(conditions, ['gross_amount_usd > 0'])
      if facebook_report?
        conditions = MonetaryDonation.merge_conditions(conditions, ["users.type in (?)", @user_types])
      else
        conditions = MonetaryDonation.merge_conditions(conditions, ["users.type in (?) or users.type is null", @user_types])
      end

      self.contributions_total = MonetaryDonation.find(:all,
                                                       :select =>  select,
                                                       :joins => join,
                                                       :conditions => conditions)
      MonetaryDonation.find(:all,
                            :select => 'monetary_transactions.*, contents.type ctype',
                            :joins => join,
                            :conditions => conditions,
                            :group => "monetary_transactions.id")

    end

    def query_comments
      Comment.count(:conditions => finder_params_created_at)
    end

    private
    def finder_params_activated_at(options = {})
      activated_at = options[:table] ? "#{options[:table]}.activated_at" : "activated_at"
      ["#{activated_at} >= ? and #{activated_at} <= ?", @start_date, @end_date]
    end

    def finder_params_created_at(options = {})
      created_at = options[:table] ? "#{options[:table]}.created_at" : "created_at"
      ["#{created_at} >= ? and #{created_at} <= ?",  @start_date, @end_date]
    end

    def facebook_report?
      @user_types == [Facebook::User.name]
    end

  end
end