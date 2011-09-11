namespace :kroogi do

  def notify_in_language(opts)
    require 'lib/maintenance_utils'
    include MaintenanceUtils

    err_logger = Logger.new('email_out')
    staging = (RAILS_ENV != 'production')
    comment_id, locale, debug_mode = opts[:id], opts[:locale], opts[:debug_mode]  

    comment = Comment.find(comment_id)
    #forum = comment.commentable
    #to_alert = [[forum] + forum.closer_circles].flatten.map(&:members).flatten - already
    to_alert = User.active.all(:conditions => ["type in (?) and activation_code is null", [BasicUser, AdvancedUser].map(&:name)], :order => 'login asc')
    if debug_mode
      puts "would notify %s ppl if not in debug mode" % to_alert.size
      to_alert = staging ? %w(artem psylence your-net-works) : %w(thirstydog ilyaster testuser kto-to psylence idiosincrazy anya) # m16) 
      to_alert = to_alert.map {|l| User.find_by_login(l)}.uniq - [nil]
    end

    old_size = to_alert.size
    to_alert = to_alert.select {|u| u.preference.email_locale == locale}
    puts "removed %d users from list - they don't speak %s" % [old_size - to_alert.size, locale]
    sender = comment.user
    message_type = Activity::ACTIVITIES[:alert_forum_post]
    optional_data = {}

    i = 0
    t0 = Time.now
    puts "gonna notify %s users in %s" % [to_alert.count, locale]
    
    progress_bucket = 100
    to_alert.each do |u|
      begin
        Activity.create_for(u, sender, comment, message_type[:id], optional_data)
        if !u.preference.email?
          msg = "user %s refuses email - activity created only" % u.title_long
        elsif !u.preference.email_realtime?
          if debug_mode
            msg = "forcing sending digest to user %s" % u.title_long
            ActivityMail.send_for_user(u)
          else
            msg = "user %s will receive it with digest" % u.title_long 
          end
        else
          msg = "sent immediate email to user %s" % u.title_long
        end
        msg = msg + '. locale = %s' % locale
        puts msg if debug_mode 
        err_logger.debug(msg)
      rescue => e
        puts "failed to send email to user %s: %s" % [u.login, e.inspect]
        err_logger.debug("failed sending to %s" %u.id)
      end
      i += 1
      t0 = Time.now if log_progress(i, t0, :description => ("%s out of %s" % [i, to_alert.size]), :each => progress_bucket)
    end
    log_progress(i, t0, :description => ("%s out of %s" % [i, to_alert.size]), :force => true) if i % progress_bucket != 0
  end

  task :notify_about_forum_msg => :environment do
    if RAILS_ENV == 'staging'
      en_id = 582; ru_id = 583
    elsif RAILS_ENV == 'rc'
      en_id = 0; ru_id = 0
    elsif RAILS_ENV == 'production'
      en_id = 0; ru_id = 0
    end
    notify_in_language :id => en_id, :locale => 'en', :debug_mode => true
    notify_in_language :id => ru_id, :locale => 'ru', :debug_mode => true
  end

  OLD_DB = {:adapter => 'mysql',
     :database => 'krugi_production',
     :host => '10.210.185.188',
     :username => 'root',
     :password => 'passw0rd',
     :encoding => 'utf8'}

  task :correct_pvtmessages_from2 => :environment do
    class OldActivity < ActiveRecord::Base
      set_table_name "activities"

      establish_connection OLD_DB
    end

    class OldComment < ActiveRecord::Base
      set_table_name "comments"

      establish_connection OLD_DB
    end

    count = Pvtmessage.count
    processed = 0
    page_size = 100
    i = 0
    Pvtmessage.paginated_each(:order => 'id', :per_page => page_size) do |msg|
      puts "Processed #{i} messages out of #{count}. Corrected #{processed} messages" if i % page_size == 0
      i += 1

      conditions = {:content_type => "Content", :content_id => msg.id}
      activity = Activity.first(:all, :conditions => conditions)

      old_activity = OldActivity.find_by_id(activity.id)
      next unless old_activity && old_activity.content_type == 'Comment'
      old_comment = OldComment.find_by_id(old_activity.content_id)
      next unless old_comment && old_comment.user_id == msg.foruser_id #for some messages from and to are swapped for some reason  

      was_from = msg.user
      was_to = msg.recipient
      from, to = [was_from, was_to].reverse

      Pvtmessage.update_all(['user_id = ?, foruser_id = ?', from.id, to.id], ['id = ?', msg.id])
      Activity.update_all(['from_user_id = ?, from_username = ?', from.id, from.login],
                          ['content_id = ? AND content_type = ?', msg.id, 'Content'])
      puts "corrected message #{msg.id}: was from #{was_from.login} to #{was_to.login}, became from #{from.login} to #{to.login}"
      processed += 1
    end
    puts "Corrected #{processed} messages"
  end

  task :convert_announcements => :environment do
    conditions = {}
    count = User.count(conditions)
    processed = 0
    page_size = 100
    user_idx = 0
    User.paginated_each(conditions.merge(:order => 'id', :per_page => page_size)) do |user|
      puts "Processed #{user_idx} users out of #{count}." if user_idx % page_size == 0
      user_idx += 1

      announcements = Board.announcements_of(user) + Board.usernotes_of(user)
      next if announcements.empty?
      ann_idx = 0
      ac_count = 0
      an_count = 0
      c_count = 0
      Announcement.transaction do
        announcements.each do |a|
          Thread.current['user'] = a.updated_by

          c = 0
          post_en, post_ru = a._post, a.post_ru
          title_en, title_ru = a._title, a.title_ru
          [['en', 'post_db_store', [title_en, title_ru], [post_en, post_ru]],
           ['ru', 'post_db_store_ru', [title_ru, title_en], [post_ru, post_en]]].each do |loc, post_method, titles, posts|
            post = posts[0]
            post = posts[1] if post.blank?
            title = titles[0]
            title = titles[1] if title.blank?
            unless title.blank?
              I18n.with_locale(loc) do
                a.post = ["<b>#{title}</b>", post].join("\n")
                if a.send(post_method) && a.send(post_method).changed.include?('content')
                  a.send(post_method).save!
                  c = 1
                end
              end
            end
          end
          an_count += c

          unless a.sticky?
            ac_count += Activity.update_all(['activity_type_id = ?', Activity::ACTIVITIES[:published_usernote][:id]],
                                            ['content_type = ? AND content_id = ? AND activity_type_id = ?',
                                             'Content', a.id, Activity::ACTIVITIES[:published_announcement][:id]])
          end

          c_count += Comment.update_all('parent_id = null', ['commentable_type = ? AND commentable_id = ?', 'Board', a.id])
          ann_idx += 1
        end
      end
      puts "Processed #{ann_idx} announcements for #{user.login}. Updated #{an_count} announcements, #{ac_count} activities, #{c_count} comments"
      processed += 1
    end
    puts "Processed #{user_idx} users"
  end

  task :convert_announcements_comments_activities => :environment do
    conditions = {:conditions => {:commentable_type => 'Board'}}
    count = Comment.count(conditions)
    processed = 0
    page_size = 100
    comment_idx = 0
    ac_count = 0
    Comment.paginated_each(conditions.merge(:order => 'id', :per_page => page_size)) do |comment|
      puts "Processed #{comment_idx} comments out of #{count}." if comment_idx % page_size == 0
      comment_idx += 1

      ac_count += Activity.update_all(['activity_type_id = ?', Activity::ACTIVITIES[:comment_made][:id]],
                                      ['content_type = ? AND content_id = ? AND activity_type_id = ?',
                                       'Comment', comment.id, Activity::ACTIVITIES[:comment_replied_to][:id]])

      processed += 1
    end
    puts "Updated #{ac_count} activities"
    puts "Processed #{comment_idx} comments"
  end

  namespace :bdrb do
    task :check => :environment do
      begin
        puts "all workers info: %s" % MiddleMan.all_worker_info.inspect
        drb_tracker = MiddleMan.worker(:stats_worker)
        drb_tracker.worker_info
        puts "Backgroundrb is available"
      rescue => e
        puts 'Backgroundrb is not available: %s' % e.inspect
        Process.exit(5)
      end
    end

    task :stop do
      require File.join(File.dirname(__FILE__), '..', 'maintenance_utils')
      include MaintenanceUtils
      kill_cmd = 'kill -9'
      main_processes_pids = get_pids 'backgroundrb', ['\bsu\b|\bsh\b', :inverse]
      main_processes_pids.each {|pid| `#{kill_cmd} #{pid}`}
      sleep(2) #let (amenable) children be killed automatically
      worker_pids = get_pids 'ruby', ['mongrel', :inverse], 'load_worker_env'
      worker_pids.each {|pid| `#{kill_cmd} #{pid}`}
    end
  end

  namespace :stage do
    task :disable_emailing_to_all_but_some => :environment do
      (puts "not allowed on Prod!"; return) if RAILS_ENV == 'production'
      count = 0
      Preference.all(:include => :user, :order => 'users.login').each do |pref|
        next unless pref.user #lost preference records
        next if %w(artem psylence your-net-works).include?(pref.user.login)
        if pref.email_notifications > 0
          count += 1;
          pref.update_attribute(:email_notifications, 0);
          puts "disabled email for %s" % pref.user.title_long
        end
      end
      puts "disabled email for %s users" % count      
    end
  end

  task :change_dirurls => :environment do
    renames = [['art-designcollection', 'artdesign-directory'], ['photocollection', 'photo-directory'], ['literature', 'literature-directory']]
    renames.each do |from, to|
      raise "Project doesn't exist: #{from}" unless fromp = User.find_by_login(from)
      raise "Project already exists: #{to}" if User.find_by_login(to)
      fromp.update_attributes(:login => to)
    end
  end

  task :restore_lost_activities => :environment do
    log = Logger.new('log/restore_lost_activities.log')
    conditions = {:conditions => ['id <= 494237 and cat_id not in (?) and type in (?)', Content.categories_rejected_from_public_stream,
                                  Content.public_stream_classes + ['Board']]}
    count = Content.count(conditions)
    page_size = 100
    idx = 0
    processed = 0
    created_activities = 0
    created_feed_entries = 0
    last_month = nil
    content = nil
    begin
      Content.paginated_each(conditions.merge(:include => :user, :order => 'id desc', :per_page => page_size)) do |content|
        curr_month = content.created_at.localize("%Y%m")
        if !last_month || curr_month.to_i < last_month.to_i
          puts curr_month; log.debug curr_month
        end
        last_month = curr_month
        if idx % page_size == 0
          msg = "Went through #{idx} content items out of #{count}. Last content tried is #{content.id}. Restored #{created_activities} activities, #{created_feed_entries} feed entries."
          puts msg; log.debug msg
        end
        idx += 1
        activities_conditions = {:activity_type_id => [:published_album, :published_image, :published_track,
                                                       :published_writing, :published_announcement, :published_usernote,
                                                       :published_video, :published_inbox, :published_music_album].
                map {|key| Activity.mapid(key)}, :content_id => content.id, :content_type => [content.class.name, 'Content']}

        next if Activity.find(:first, :conditions => activities_conditions)
        next unless content.user

        activity = Activity.find(restore_activity_for_content(content, content.user, false))
        created_activities += 1
        if false
          Relationship.find_followers_paginated(content.user, Activity.levels_can_see(content)) do | user |
            Activity.transaction do
              FeedEntry.create_for(user.id, activity)
              created_feed_entries += 1
            end
          end
        end
        processed += 1
      end
    ensure
      msg = "last tried content was #{content.id}"; puts msg; log.debug msg 
      msg = "Went through #{idx} content items, processed #{processed}, resulting in #{created_activities} activities and #{created_feed_entries} feed entries"
      puts msg; log.debug msg
    end
  end

  def restore_activity_for_content(content, to_user, friendcast)
    id = Activity.connection.insert(%Q{
      insert into activities(user_id, activity_type_id, from_user_id, from_username, content_id, content_type, created_at, updated_at, friendcast)
                        values(#{to_user.id},
                               #{Activity.content_publishing_type_id(content)},
                               #{content.user_id},
                               '#{content.user.login}',
                               #{content.id},
                               'Content',
                               '#{content.created_at.to_s(:db)}',
                               '#{content.created_at.to_s(:db)}',
                               #{friendcast ? 1 : 0})
    }, "Activity Create", 'id', nil, nil)
    id
  end

  task :set_to_user_id_for_old_feed_entry_activities => :environment do
    bucket_size = 100
    start_id = 0
    while start_id < FeedEntryActivity.last.id
      end_id = start_id + bucket_size - 1
      FeedEntryActivity.set_to_user_id("where fea.id >= #{start_id} and fea.id <= #{end_id}")
      print "."
      start_id = end_id + 1
    end
  end

  task :categorize_feed_entries => :environment do
    raise 'specify LOG_PATH!' unless log_path = ENV['LOG_PATH']
    FeedEntry.categorize_feed_entries(log_path)
  end

  task :compress_feed_entries => :environment do
    conditions = {:conditions => ['id <= 1055469']}
    count = Content.count(conditions)
    processed = 0
    page_size = 100
    deleted_entries = 0
    deleted_entry_activities = 0
    puts "gonna process #{count} albums"
    progress_log = Logger.new('/home/sasha/compress_feed_entries.log')
    Content.paginated_each(conditions.merge(:order => 'id desc', :per_page => page_size)) do |content|
      if true || processed % page_size == 0
        msg = "Processed #{processed} content out of #{count}. Last processed is of #{content.created_at} (#{content.id}). Deleted #{deleted_entries} entries, #{deleted_entry_activities} entry activities" 
        puts msg
        progress_log.debug msg
      end
      processed += 1
      next unless content.public? && content.active?
      album = content.container_album
      next if !album
      next if album.is_a?(Inbox)
      contents = (album.tracks + album.images).sort_by {|x| x.created_at}.reverse #latest first
      next if contents.blank? 
      FeedEntryActivity.from_user(content.user).for_content(contents.first).paginated_each(:per_page => page_size) do |fea|
        #update group entries for last image/track
        if fea.activity
          if FeedEntry.find_or_create_container_entry(fea.to_user_id, fea.activity)
            #do the same as if the last track was just created: raise the album feed entry up to top
            FeedEntry.create_for(fea.to_user_id, fea.activity, :from_collection => fea.feed_entry.from_collections)
          end
        else
          #edge case: we have feed entry activity without Activity. this is data error, let's delete invalids
          FeedEntry.delete_by_id_pairs([[fea.feed_entry_id, fea.id]])
        end
      end
      contents.each do |content|
        entry_activities = [1]
        while !entry_activities.empty?
          entry_activities = FeedEntryActivity.from_user(content.user).for_content(content).find(:all, :limit => page_size)
          dfe, dfea = FeedEntry.delete_by_id_pairs(entry_activities.map {|fea| [fea.feed_entry_id, fea.id]})
          deleted_entries += dfe
          deleted_entry_activities += dfea          
        end
      end
    end
    msg = "Processed #{processed} albums out of #{count}, deleted #{deleted_entries} entries, #{deleted_entry_activities} entry activities" 
    puts msg
    progress_log.debug msg
  end
  
  task :correct_feed_population_entries => :environment do
    bucket_size = 100
    end_id = FeedEntry.last.id
    last_id = end_id
    progress_log = Logger.new('/home/sasha/correct_feed_population_entries.log')
    i = 0
    updated = 0
    while end_id > 0
      i += 1
      start_id = end_id - bucket_size + 1
      if i % 1000 == 0
        msg = "Processed #{i*bucket_size} entries out of #{last_id}. Current range is #{start_id}, #{end_id}. Updated #{updated} feed entries."
        puts msg
        progress_log.debug msg
      end
      updated += FeedEntry.connection.update("update feed_entries set updated_at = created_at where id >= #{start_id} and id <= #{end_id}")
      print "."
      end_id = start_id - 1
    end
    msg = "Processed #{i*bucket_size} entries out of #{last_id}. Updated #{updated} feed entries."
    puts msg
    progress_log.debug msg

  end

  def log_msg(msg, log)
    puts msg
    log.debug msg
  end

  task :rotate_feed_entries => :environment do
    log = Logger.new('log/rotate_feed_entries.log')
    logger = lambda {|msg| log_msg(msg, log)}
    FeedEntry.rotate(6.weeks, logger)
  end

end

