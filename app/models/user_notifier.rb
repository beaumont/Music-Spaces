class UserNotifier < LocalizedMailer
  
  # Welcome to Kroogi! Please activate your new account
  def signup_notification(user)
    setup_email(user)
    @from         = head_encode("\"Kroogi (No Reply)\"".t) + " <welcome@kroogi.com>" #make it other for AWL rule not to trigger here
    @subject    += head_encode('Kroogi registration confirmation'.t)
    @body[:kroogi_url]  = "http://#{APP_CONFIG[:hostname]}/"
    activation_url = "http://#{APP_CONFIG[:hostname]}/home/activate/#{user.activation_code}"
    unless user.created_on_event.blank?
      activation_url += '?created_on=' + user.created_on_event
    end
    @body[:activation_url] = activation_url

    @content_type = "text/plain"
    self.template = 'signup_notification.%s.text.plain.erb' % I18n.locale
  end
  
  def paypal_notification_unverified(account_setting)
    setup_email(account_setting.user)
    paypal_account = account_setting.paypal_account
    @from        = head_encode("\"Kroogi (No Reply)\"".t) + " <support@kroogi.com>"
    @subject    += head_encode('Kroogi PayPal - Unverified'.t)
    @body[:email]  = paypal_account.account_identifier
    @body[:username] = account_setting.user.login
    
    @content_type = "text/plain"
    self.template = 'paypal_notification_unverified.%s.text.plain.erb' % I18n.locale
  end
  
  def paypal_notification_denied(account_setting)
    setup_email(account_setting.user)
    paypal_account = account_setting.paypal_account
    @from        = head_encode("\"Kroogi (No Reply)\"".t) + " <support@kroogi.com>"
    @subject    += head_encode('Kroogi PayPal - Denied'.t)
    @body[:email]  = paypal_account.account_identifier
    @body[:username] = account_setting.user.login
    
    @content_type = "text/plain"
    self.template = 'paypal_notification_denied.%s.text.plain.erb' % I18n.locale
  end

  def paypal_notification_approved(account_setting)
    setup_email(account_setting.user)
    paypal_account = account_setting.paypal_account
    @from        = head_encode("\"Kroogi (No Reply)\"".t) + " <support@kroogi.com>"
    @subject    += head_encode('Kroogi PayPal - Approved'.t)
    @body[:email]  = paypal_account.account_identifier
    @body[:username] = account_setting.user.login
    
    @content_type = "text/plain"
    self.template = 'paypal_notification_approved.%s.text.plain.erb' % I18n.locale
  end
  
  # Admins can send message to every active user, if they really really want to
  # Sending one language preference at a time to correctly determine the email locale
  def admin_broadcast(desired_locale, emails_as_string, subject, body)
    ActionMailer::Base.smtp_settings = APP_CONFIG[:admin_mail]
    set_locale( desired_locale )

    @content_type = "text/html"
    @recipients   = "noreply@kroogi.com"
    @bcc          = emails_as_string
    @from         = head_encode("\"Kroogi (No Reply)\"".t) + " <noreply@kroogi.com>"
    @subject      = head_encode("[Kroogi] " + subject)
    @sent_on      = Time.now
    @body[:url]  = "http://#{APP_CONFIG[:hostname]}/"
    @body[:body] = body
  end
  
  # Password reset notification
  def reset(user, password)
    setup_email(user)
    @subject    += head_encode('Your password has been reset!'.t)
    @body[:password]  = password
  end
    
  # Your account has been deleted from Kroogi (irrevocable)
  def account_deleted(user)
    setup_email(user)
    @subject         += head_encode("%s's account was deleted" / user.login)
    @body[:user]      =  user
  end  

  # Your project has been deleted from Kroogi (irrevocable)
  def project_deleted(user, project)
    setup_email(user)
    @subject         += head_encode(project.login + " was deleted".t)
    @body[:user]      = user
    @body[:project]   = project
  end  

  # Sent to notify a user when that user, or that user's project, has been blocked
  def account_blocked(user, project = nil)
    setup_email(user)
    @subject         += head_encode((project ? project.login : 'Your account'.t) + " has been banned from the Kroogi Network".t)
    @body[:user]      = user
    @body[:project]   = project
  end
  
  # Sent to notify a user when that user, or that user's project, has been unblocked (restored from blocked... can't be restored from deletion)
  def account_restored(user, project = nil)
    setup_email(user)
    @subject         += head_encode((project ? project.login : 'Your account'.t) + " has been restored to the Kroogi Network".t)
    @body[:user]      = user
    @body[:project]   = project
  end

  # Hey, admins, can you enable donations for me, please?
  def donations_requested(user)
    setup_email_admin(user)
    @recipients         = "feedback@your-net-works.com"
    @from               = head_encode('"Kroogi Contributions Request (system)"'.t) + " <admin.alert@kroogi.com>"
    @subject            += head_encode("Contributions requested by %s" / user.login)
    @content_type       = "text/html"     
    @body[:url]         =  "http://#{APP_CONFIG[:hostname]}/admin/donation_requests"
    @body[:user] = user
  end

  # The admins have enabled your donation basket (you can set up payment systems now)
  def donations_approved(user, project=nil)
    setup_email(user)
    @subject          += head_encode(project ? ("Contributions for %s have been activated" / project.login) : 'Your contributions request has been approved'.t)
    @body[:project]   =  project
    @body[:url]       =  "http://#{APP_CONFIG[:hostname]}/money"
  end

  # Just testing that mail's working properly
  def test_mailsystem(switcher = :junk)
    logger.info "Settings before: #{ActionMailer::Base.smtp_settings.inspect}"
    
    user = User.find(3)
    case switcher
    when :junk
      setup_email_admin(user)
      @from         = head_encode("\"Kroogi (No Reply)\"".t) + " <welcome@kroogi.com>"
      ActionMailer::Base.smtp_settings = APP_CONFIG[:junk_mail]
    when :important
      setup_email(user)
    when :admin
      setup_email_admin(user)
    when :server
      setup_email_admin(user)
      @from         = "Message from Server <engineering@your-net-works.com>"
      ActionMailer::Base.smtp_settings = APP_CONFIG[:server_mail]
    end
    @recipients         = "engineering@your-net-works.com"
    @subject            += head_encode("Email test".t)
    @body[:info]  = ActionMailer::Base.smtp_settings[:user_name]
    
    logger.info "Settings after: #{ActionMailer::Base.smtp_settings.inspect}"
    
  end

  def email_notifications_settings_changed(notification_id)
    notification = UserChangeNotificationToRealtime.find_by_id(notification_id)
    user = notification.user
    @body[:notification]  = notification
    setup_email(user) if user
  end
  
  protected
  def setup_email(user)
    #TODO: change it back
    #Fails to deliver
    #ActionMailer::Base.smtp_settings = APP_CONFIG[:important_mail]
    ActionMailer::Base.smtp_settings = APP_CONFIG[:junk_mail]
    set_locale(user.preference.email_locale || 'en')

    @content_type = "text/html"
    unless user.display_name.blank?
      @recipients   = "#{user.display_name} <#{user.email}>"
    else  
      @recipients   = "#{user.email}"
    end
    @from         = head_encode("\"Kroogi (No Reply)\"".t) + " <noreply@kroogi.com>"
    @subject      = head_encode("[Kroogi] ")
    @sent_on      = Time.now
    @body[:user]  = user
  end
  
  def setup_email_admin(user)
    ActionMailer::Base.smtp_settings = APP_CONFIG[:admin_mail]
    set_locale(user.preference.email_locale || 'en')

    @content_type = "text/html"
    @recipients   = "#{user.email}"
    @from         = head_encode("\"Kroogi (No Reply)\"".t) + " <admin.alert@kroogi.com>"
    @subject      = head_encode("[Kroogi] ")
    @sent_on      = Time.now
    @body[:user]  = user
  end
  
end
