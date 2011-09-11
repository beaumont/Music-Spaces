module Admin
  class MonitorController < BaseController

    with_options(:if => proc{ |controller| controller.send(:use_cache?) }, :layout => false) do |c|
      c.caches_action :index, :expires_in => 10.minutes,   :cache_path => proc{|c| c.cache_key_with_locale}
    end

    def index
      today = Date.today
      user_types = (params[:query] == 'facebook' ? [Facebook::User] : [BasicUser, AdvancedUser])

      aggregated_data     = MonitorReportQuery.new(:user_types => user_types)
      @users_total        = aggregated_data.query_total_users
      @projects_total     = aggregated_data.query_total_projects
      @music_albums_total = aggregated_data.query_total_musicalbums

      @monitoring_stats = []
      1.upto(30) do |n|
        parameters = {}
        parameters[:start_date] = today - (n-1).days
        parameters[:user_types]  = user_types
        data = MonitorReportQuery.new(parameters)

        data.users            = data.query_users
        data.logged_in_users  = data.query_logged_in_users
        data.projects         = data.query_projects
        data.contents         = data.query_music_albums
        data.downloads        = data.query_downloads
        data.contributions    = data.query_donations
        data.comments         = data.query_comments

        @monitoring_stats << [parameters[:start_date], data]
      end

      respond_to do |format|
        format.html do
          do_html(user_types, @monitoring_stats)
        end
        format.csv do
          do_csv(@monitoring_stats)
        end
      end

    end

    def do_html(user_types, monitoring_stats)
      if user_types == [Facebook::User]
        render :action => :facebook_report, :monitoring_stats => monitoring_stats
      else
        render :action => :index
      end
    end

    def do_csv(monitoring_stats)
      timestamp = Time.now.strftime('%y%m%d_%H%M%S')
      lines = []
      lines << ['Date'.t, 'User_New'.t, 'User_Visitor', 'Projects'.t, 'MA'.t,
        'Downloads_Total'.t, 'Downloads_MA'.t, 'Downloads_TX'.t, 'Downloads_Folder'.t,
        'Contributions_total_num'.t, 'Contributions_total_USD'.t, 'Contributions_total_USD'.t, 'Contributions_total_AVG'.t, 'Contributions_total_Fee'.t, 'Contributions_for_MA'.t,
        'Contributions_for_Trx'.t, 'Contributions_for_Fd'.t, 'Contributions_for_Img'.t, 'Contributions_for_Txt'.t, 'Contributions_for_Vid'.t,
        'Comments'.t]
      @result = []
      monitoring_stats.each do |day, data|
        @result << data
        line = []
        line << day.to_s(:db)
        line << data.users
        line << data.logged_in_users.count
        line << data.projects
        line << data.contents

        line << data.downloads.count
        line << data.downloads.select{|c| c.ctype == 'MusicAlbum'}.count
        line << data.downloads.select{|c| c.ctype == 'Tracks'}.count
        line << data.downloads.select{|c| c.ctype == 'FolderWithDownloadables'}.count

        line << (data.contributions[0] ? data.contributions.count : "$0.00")
        line << (data.contributions[0] ? data.contributions_total[0].gross_amount_usd : "$0.00")
        line << (data.contributions[0] ? data.contributions_total[0].avg_gross_amount_usd : "$0.00")
        line << (data.contributions[0] ? data.contributions_total[0].handling_fee_usd : "$0.00")

        line << data.contributions.select{|c| c.ctype == 'MusicAlbum'}.count
        line << data.contributions.select{|c| c.ctype == 'Tracks'}.count
        line << data.contributions.select{|c| c.ctype == 'FolderWithDownloadables'}.count
        line << data.contributions.select{|c| c.ctype == 'Image'}.count
        line << data.contributions.select{|c| c.ctype == 'Textentry'}.count
        line << data.contributions.select{|c| c.ctype == 'Video'}.count
        line << data.comments
        lines << line
      end

      send_data lines.map {|line | line.join("\t")}.join("\n"),
                :filename => "monitor_%s.csv" % timestamp
      
    end

    # Copy this code to the console
    def since_launch
      t_start = Time.parse("November 1, 2008")
      t_current = t_start
      t_end = Time.today
      stats = []
      while (t_current < t_end) do
        puts "Getting stats for #{t_current.to_s(:date_only)}"
        stats << "#{t_current.strftime('%m/%d/%Y')}, #{User.count(:conditions => ['activated_at >= ? and activated_at < ?', t_current, t_current + 1.day])}"
        t_current += 1.day
      end
      puts stats
    end
  end
end
