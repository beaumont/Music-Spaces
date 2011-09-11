# == Schema Information
# Schema version: 20081028193108
#
# Table name: activity_mails
#
#  id          :integer(11)     not null, primary key
#  activity_id :integer(11)
#  user_id     :integer(11)
#  created_at  :datetime
#  updated_at  :datetime
#  payload     :string(255)
#

class ActivityMail < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity

  # Note: Using 7 day interval in case we want to switch to weekly digest later.

  DATE_CONDITION = 'created_at > DATE_SUB(NOW() , INTERVAL 7 DAY)'
  def self.send_pending_by_user(user_or_id = nil)
    if user_or_id
      user = user_or_id.is_a?(User) ? user_or_id : User.active.find( user_or_id.to_i )
      send_for_user( user )
    else # Send for all, chunked to use less memory


      max_users = ActivityMail.count(:conditions => DATE_CONDITION)
      
      # Take them 100 users at a time. num_cycles is number of cycles assuming worst case of 1:1 activity:user ratio
      num_cycles = max_users / 100 
      
      # At most max_cycles
      (0..num_cycles).each do |cycle|
        recipients = User.find_by_sql(%Q{select users.*, count(am.user_id) as cnt from activity_mails as am
          INNER JOIN users ON users.id = am.user_id
          where am.#{DATE_CONDITION} group by am.user_id limit #{100} offset #{100*cycle}})
        break if recipients.empty?

        recipients.each do |recipient|
          send_for_user(recipient)
        end
        #log.error seems not too natural for this, and log.info is just ignored on Prod
        puts "Digest emails sending: done page %s of %s" % [cycle + 1, num_cycles+1]
      end
    end

  end

  private

  def self.maybe_flush(recipient, pending_activity_digest, options = {})
    min_batch = 10
    done = []
    pending_activity_digest.each do |project, messages|
      begin
        if (messages.size >= min_batch) || options[:force]
          ActivityNotifier.async_deliver_alert_digest(recipient.id, project.id, messages.map {|m| m.id})
          done << project
        end
      rescue => e
        raise "Error sending digest for #{recipient.login}'s #{project.login}: #{e.inspect}"
      end
    end
    done.each {|p| pending_activity_digest.delete(p)}
  end

  def self.send_for_user(recipient)
    return unless recipient && recipient.active?
    
    begin
      pending_activity_digest = {}
      activities_count = 0
      ActivityMail.transaction do
        while true do
          pending_activity_mails = ActivityMail.find(:all,
            :conditions => ["user_id = ? and #{DATE_CONDITION}", recipient.id],
            :order => 'created_at asc',
            :limit => 100
          )

          break if pending_activity_mails.empty?
          logger.error "Sending pending emails summary to #{recipient.login}, activity count (max 100) is: #{pending_activity_mails.count}"
          pending_activity_mails.each do |pending|
            next if pending.activity.nil? # Skip it if there's nothing attached
            next unless pending.activity.unread? # Don't send alerts about already-read messages
            pending_activity_digest[pending.activity.user] ||= []
            pending_activity_digest[pending.activity.user] << pending.activity
            activities_count += 1
          end
          maybe_flush(recipient, pending_activity_digest)
          if activities_count > 20 && recipient.preference.email_digest? && APP_CONFIG[:save_users_with_digest]
            UserChangeNotificationToRealtime.delete_all(:user_id => recipient.id)
          end
          ActivityMail.delete_all({:id => pending_activity_mails.map(&:id)})
        end
        maybe_flush(recipient, pending_activity_digest, :force => true)
      end
    rescue => exception
      msg = "Error sending email digest to #{recipient.login}: #{exception.inspect}"
      AdminNotifier.async_deliver_admin_alert msg
      logger.error msg
    end

  end

end
