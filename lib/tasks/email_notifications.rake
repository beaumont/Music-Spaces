namespace :notifications do
  desc "Send Notification Emails"
  task :send_emails => :environment do
    UserChangeNotificationToRealtime.active.paginated_each(:per_page => 1000) do |notifier|
      UserNotifier.async_deliver_email_notifications_settings_changed(notifier.id)
      print "."
    end
  end

  desc "Change Notification Method"
  task :change => :environment do
    UserChangeNotificationToRealtime.active.paginated_each(:per_page => 1000, :include => :user) do |notifier|
      notifier.user.preference.update_attribute(:email_notifications, Preference::EMAIL[:realtime])
      print "."
    end
  end

  desc "Add users"
  task :add_users => :environment do
    User.paginated_each(:per_page => 1000, :conditions => ['type IN (?)', ['AdvancedUser', 'BasicUser']], :include => :preference) do |user|
      next unless user.preference.email_digest?
      UserChangeNotificationToRealtime.create(:user_id => user.id, :login => user.login)
      print "\e[3#{[2,3,4,5].rand}m.\e[0m"
    end
    puts "\e[32mDONE\e[0m"
  end
end