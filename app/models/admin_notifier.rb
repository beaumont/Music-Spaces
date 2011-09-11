class AdminNotifier < LocalizedMailer
  self.delivery_method = :activerecord unless ['development', 'test', 'selenium'].include?(RAILS_ENV)
  
  ADMIN_EMAIL = 'engineering@your-net-works.com'
    
  def drb_exception(exception, worker, task)
    @content_type = "text/plain"
    @recipients   = ADMIN_EMAIL
    @from         = "\"Kroogi\" <admin.alert@kroogi.com>"
    @subject      = "[DRB Status] #{worker}##{task}"
    @sent_on      = Time.now
    @body[:exception]   = exception
    @body[:backtrace]   = sanitize_backtrace(exception.backtrace)
    @body[:task]        = task
    @body[:worker]      = worker
  end
  
  def alert(msg)
    @recipients   = ADMIN_EMAIL
    @from         = "\"Kroogi\" <admin.alert@kroogi.com>"
    @subject      = "[Kroogi Admin - %s] Admin Alert Received" % RAILS_ENV
    @sent_on      = Time.now
    @body[:msg]   = msg
    self.template = 'alert.text.plain.erb'
  end
  alias :admin_alert :alert

  def kroogi_admin_alert(msg)
    @recipients   = 'copyrights@your-net-works.com'
    @from         = "\"Kroogi\" <admin.alert@kroogi.com>"
    @subject      = "Moderation Event Notification".t
    @subject      = "[#{RAILS_ENV}] " + @subject unless RAILS_ENV == 'production'  
    @sent_on      = Time.now
    @body[:msg]   = msg
    self.template = 'kroogi_admin_alert.text.plain.erb'
  end
  
  def paypal_requires_admin_attention(acct)
    setup_email_admin
    @subject += "PayPal Verification Required"
    @body[:acct] = acct
  end

protected
  
  def sanitize_backtrace(trace)
    re = Regexp.new(/^#{Regexp.escape(RAILS_ROOT)}/)
    trace.map { |line| Pathname.new(line.gsub(re, "[RAILS_ROOT]")).cleanpath.to_s }
  end
  
  def setup_email_admin
    ActionMailer::Base.smtp_settings = APP_CONFIG[:admin_mail]

    @content_type = "text/html"
    @recipients   = ADMIN_EMAIL
    @from         = "\"Kroogi\" <admin.alert@kroogi.com>"
    @subject      = "[Kroogi Admin] "
    @sent_on      = Time.now
  end
  

end
