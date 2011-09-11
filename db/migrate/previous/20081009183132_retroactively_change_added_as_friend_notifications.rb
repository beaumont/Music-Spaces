class RetroactivelyChangeAddedAsFriendNotifications < ActiveRecord::Migration
  def self.up
    # Before, activity.user == activity.content. Now, activity.content should be the circle the user is/was joining. 
    # For past events, we'll just pretend that's whatever circle they're in now
    Activity.only(:added_as_friend).each do |a|
      if a.user == a.from_user
        puts "wtf user and from user the same (#{a.user.login}) - removing"
        a.destroy
      end
      
      next unless a.content && a.content.is_a?(User)
      
      Thread.current['user'] = a.user # le sigh -- stupid user_monitor requires this in the case where user's circle doesn't exist yet...
      if kroog = a.user.find_circle_with(a.from_user)
        puts "#{a.from_user.login} is currently in #{a.user.login}'s #{kroog.name} circle - pretending that's what they joined, updating activity"
        a.update_attributes(:content_type => 'UserKroog', :content_id => kroog.id)
      else
        # User isn't in your circles anymore anyway, why bother keeping it around?
        puts "#{a.from_user.login} is no longer in #{a.user.login}'s circles - removing activity message"
        a.destroy
      end
      Thread.current['user'] = nil
    end
  end

  def self.down
  end
end
