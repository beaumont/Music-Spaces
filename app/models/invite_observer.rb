class InviteObserver < ActiveRecord::Observer

  # IMPORTANT: invites to normal kroogi users are sent through activity controller.
  # These observers are ONLY here to send to NOT KROOGI USERS (e.g. when user_email isn't blank)

  def after_create(invite)
    if invite.pending? && !invite.user_email.blank?
      if invite.circle_id == Invite::TYPES[:site_invite][:id] 
        InviteNotifier.async_deliver_siteinvite_notification(invite, invite.locale) unless invite.user_email.nil?
      elsif invite.inviter.project? && invite.circle_id == Invite::TYPES[:founder_circle][:id]
        InviteNotifier.async_deliver_invite_founder_notification(invite, invite.locale)
      else
        InviteNotifier.async_deliver_invite_notification(invite, invite.locale)
      end
    end
  end

  def after_save(invite)
    if invite.recently_reinvited? && !invite.user_email.blank?
      if invite.inviter.project? && invite.circle_id == Invite::TYPES[:founder_circle][:id]
        InviteNotifier.async_deliver_invite_founder_notification(invite, invite.locale)
      else
        InviteNotifier.async_deliver_invite_notification(invite, invite.locale)
      end
    end
  end

end