class MonetaryTransactionObserver < ActiveRecord::Observer
  def self.disable
    @@disabled = true
  end

  def after_create(trans)
    @@disabled ||= false
    return if @@disabled
    
    case trans
    when MonetaryDonation
      apply_to_receiver_total(trans)      if trans.receiver
      apply_to_content_total(trans)       if trans.content
      flag_suspicious(trans)

      invite_guest_user(trans)            if trans.anonymous?
      invite_to_circle(trans)             if !trans.invite.blank?
      notify_of_donation_received(trans)  if trans.notifiable_donation_received?
      notify_of_album_donation(trans)     if trans.album_donation?
    end
  end
  
  protected
  
  def apply_to_receiver_total(trans)
    trans.receiver.increment!(:collected_usd, trans.payable_amount_usd)
  end
  
  def apply_to_content_total(trans)
    trans.content.increment!(:collected_usd, trans.payable_amount_usd)
  end
  
  def flag_suspicious(trans)
    trans.suspect! if 
      [ trans.content_type != Tps::GoodieTicket.name && trans.gross_amount_usd > 500.00,
        # Add any more suspicious checks here. Perhaps number of donations or such
      ].any?
  end
  
  
  def invite_guest_user(trans)
    if trans.invitable_as_anonymous_donor?
      InviteNotifier.async_deliver_invite_from_donation(trans.sender_email, (trans.receiver.user.preference.email_locale || 'en'), trans.receiver.user)
    end
  rescue Exception => e
    AdminNotifier.async_deliver_alert("Error sending guest contributor an invitation: #{e} - #{e.inspect}")
    logger.warn  "[#invite_guest_user]"
    logger.warn e
  end
  
  def notify_of_donation_received(trans)
    Activity.send_message(trans, trans.sender.try(:user), :donation_received)
  end
  
  def notify_of_album_donation(trans)
    Activity.send_message(trans.content, trans.sender.try(:user), :content_purchased, {}, :monetary_transaction_id => trans.id)
  end

  # This is a bit involved and only for albums, based on lots of stuff around the attic.
  def invite_to_circle(trans)
    # where are we getting our requiement defaults from?
    owner   = trans.receiver.owner
    default = (trans.content || trans.receiver)
    # require that we have an actual user and not a guest and we need to invite them.
    if trans.sender && default.invite_to_circle_after_donation?
      all_clear = returning [] do |checks|
        # circle exists?
        checks << owner.has_circle?(default.circle_to_invite_to)
        # minimum amount paid?
        checks << ((default.send("amount_required_for_circle_invite_#{trans.currency.downcase}") || 0) <= trans.gross_amount) if trans.currency
        # already in circle?
        checks << !trans.sender.in_circle?(owner.circle(default.circle_to_invite_to))
        # already invited?
        checks << !trans.sender.invited_to?(owner.circle(@price_validation_object.circle_to_invite_to))
      end
      # all checks pass?
      if all_clear.compact.all?{|check| !!check == true }
        return if trans.invite
        Thread.current['user'] = trans.sender.owner
        msg = (default.message_to_donors == 'Please contribute...'.t) ? "Thank you for your contribution!".t : default.message_to_donors        
        invite = Invite.create!(
          :user_id    => trans.sender.owner.id,
          :circle_id  => default.circle_to_invite_to,
          :inviter_id => owner.id,
          :invitation => msg,
          :free       => true
        ).save!
        trans.update_attribute(:invite_id, invite.id)
      end
    end
    
  end
  
end
