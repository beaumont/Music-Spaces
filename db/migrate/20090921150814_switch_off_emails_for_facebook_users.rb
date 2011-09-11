class SwitchOffEmailsForFacebookUsers < ActiveRecord::Migration
  def self.up
    updated = ActiveRecord::Base.connection.update(%Q{update preferences, users set preferences.email_notifications = 0
      where preferences.user_id = users.id and users.type = 'Facebook::User'})
    puts "%s FB users preferences updated" % updated
    removed = 0
    ActivityMail.find(:all, :conditions => 'users.type = \'Facebook::User\'', :include => :user).each do |am|
      am.destroy
      removed += 1
    end
    puts "%s mails to FB users removed" % removed
  end

  def self.down
  end
end
