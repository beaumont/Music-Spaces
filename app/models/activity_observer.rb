class ActivityObserver < ActiveRecord::Observer

  # Handle sending email alerts from activity stream
  def after_create(activity)
    debug = false
    puts "activity.skip_emails? == %s" % !!activity.skip_emails? if debug
    return true if activity.skip_emails?

    user = activity.user

    # These are the ones that result in mail being sent.
    # IMPORTANT - do not allow any others through (summary may be blank then if they dont have a matching partial)
    case activity.keyname
      when :invite_sent
      when :invite_reinvited
      when :invite_accepted
      when :added_as_friend
      when :sent_pvtmsg
      when :removed_from_circle
      when :sent_getcloser
      when :getcloser_granted
      # when :moved_to_down_circle #4701: don't notify when user go down in circles
      # when :donation_account_added
      # when :donation_account_changed
      # when :donation_account_removed
      when :user_featured
      when :content_featured
      when :comment_replied_to
      when :comment_made
      when :alert_forum_post
      when :inbox_submission_received
      when :inbox_submission_accepted
      # when :paypal_account_verified
      # when :paypal_account_rejected
      when :content_item_adopted
      when :author_commented_an_answer
      when :tps_participant_info_request_sent
      #when :tps_participant_info_request_answered
      when :tps_participant_was_questioned
      #when :tps_participant_answered
      when :added_as_favorite # friendcast is true here, but only send notice to content owner
        return true unless activity.content.respond_to?(:user) && activity.content.user == user
      else
        return true
    end

    # Project emails get sent to various members, not to project itself
    people_to_contact = if user.project?
      ids = user.people_tracking_me.email_delivery.map(&:tracking_user_id).uniq
      User.active.all(:conditions => {:id => ids}, :include => :preference)
    else
      [user]
    end

    puts "activity.user == activity.from_user: %s" % [user == activity.from_user] if debug
    # If there are any cases where you need to be alerted for activities you've taken, change this
    # WAS a case where owners should be alerted for actions taken by project, but killed that in favor of
    # making sure all projects content shows up in owners' followed feeds
    return if user == activity.from_user
    
    puts "people_to_contact: %s" % people_to_contact.map(&:login) if debug
    people_to_contact.each do |recipient|
      next unless recipient.active? && recipient.preference && recipient.preference.email?
      next if recipient == activity.from_user
      next unless user_need_this_activity?(activity, recipient.preference)

      if recipient.preference.email_realtime?
        ActivityNotifier.async_deliver_alert_digest(recipient.id, user.id, [activity.id])
      else
        ActivityMail.create(:activity_id => activity.id, :user_id => recipient.id)
      end
    end
    
  end

  def user_need_this_activity?(activity, preference)
    return true unless [:invite_sent, :invite_reinvited, :added_as_friend,
      :sent_pvtmsg, :removed_from_circle, :sent_getcloser, :invite_accepted, :getcloser_granted].include?(activity.keyname)
    
    case activity.keyname
      when :invite_sent
        return true if preference.notify_invitations_and_requests?
      when :invite_reinvited
        return true if preference.notify_invitations_and_requests?
      when :added_as_friend
        return true if preference.notify_joins_interested_circle?
      when :sent_pvtmsg
        return true if preference.notify_private_messages?
      when :removed_from_circle
        return true if preference.notify_leaves_interested_circle?
      when :sent_getcloser
        return true if preference.notify_invitations_and_requests?
      when :invite_accepted
        return true if preference.notify_invitations_and_requests?
      when :getcloser_granted
        return true if preference.notify_invitations_and_requests?
    else
      false
    end

  end

end