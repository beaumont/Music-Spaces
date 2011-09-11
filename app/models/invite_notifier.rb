class InviteNotifier < LocalizedMailer

  def invite_founder_notification(invite, locale = nil)
    setup_email(invite, nil, locale)
    @subject    += head_encode('You have been invited to become a host of '.t + invite.inviter.display_name)
  end

  def invite_notification(invite, locale = nil)
    setup_email(invite, nil, locale)
    @content_type = 'text/plain'
    @subject = head_encode("You have a message from {{user}} (kroogi.com)" / invite.inviter.login)
    @body[:inviter_url] = "http://#{invite.inviter.login.downcase}.#{APP_CONFIG[:hostname]}"
    self.template = 'invite_notification.text.plain.erb'
  end

  def invite_from_donation(email, locale, donated_to_user)
    setup_email(nil, email, locale)
    @subject    += head_encode('You have been invited to join the Kroogi Network'.t)
    @body[:url_signup] = "http://#{APP_CONFIG[:hostname]}/signup"
    @body[:donated_to] = donated_to_user
  end

  def siteinvite_notification(invite, locale = 'en')
    setup_email(invite, nil, locale)
    @subject    += head_encode('You have been invited to join the Kroogi Network'.t)
    @body[:in_rainbows_album] = invite.in_rainbows_purchase? ? invite.in_rainbows_album : nil
  end

  protected
  def setup_email(invite, email = nil, locale = nil)
    ActionMailer::Base.smtp_settings = APP_CONFIG[:important_mail]

    if locale then set_locale(locale)
    else set_locale((invite.user ? invite.user.preference.email_locale : 'en') || 'en')
    end
    
    @content_type   = "text/html"
    @recipients     = email
    @recipients     ||= invite.user.nil? ? invite.user_email : invite.user.email

    from_label      = head_encode("kroogi.com invitation (no reply)".t)
    @from           = invite ? %Q{#{invite.inviter.login} - #{from_label} <noreply@kroogi.com>} : "#{from_label} <noreply@kroogi.com>"
    @subject        = head_encode("[Kroogi] ")
    @sent_on        = Time.now
    @body[:url]     = "http://#{APP_CONFIG[:hostname]}"
    @body[:invite]  = invite
    @body[:url_signup]  = "http://#{APP_CONFIG[:hostname]}/home/signup/#{invite.activation_code}" if invite
  end
end
