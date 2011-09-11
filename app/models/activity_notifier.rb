require 'base64'
class ActivityNotifier < LocalizedMailer

  def alert_digest(recipient_id, subject_project_id, activities)
    recipient = User.find(recipient_id)
    subject_project = User.find(subject_project_id)
    activities = Activity.all(:conditions => {:id => activities}).compact
    raise Kroogi::NothingToSend if activities.blank?
    setup_email(recipient)
    # Note that this is not perfect, activities could have 2 messages, only one of which is displayable...
    @body[:subject_is_user] = true if subject_project == recipient
    @body[:user_project] = subject_project
    subject_project = subject_project.display_name
    s = if (activities.count == 1)
      "Message for {{project_name}}" / subject_project
    else
      "Messages Digest for {{project_name}}" / subject_project
    end
    @subject += head_encode(s)
    @body[:activities] = activities

    @content_type = "multipart/alternative"
    @body[:subject_project] = subject_project
    part "text/html" do |p|
      p.transfer_encoding = "base64"
      p.body = render_message("alert_digest.text.html.erb", @body)
    end

  end
  
  def content_purchase
  end
  
  protected
  def setup_email(recipient)
    ActionMailer::Base.smtp_settings = APP_CONFIG[:junk_mail]
    # Set Locale for email
    email_locale = recipient.preference.email_locale
    set_locale(email_locale || 'en')
              
    @content_type     = "text/html"
    @recipients       = recipient.email
    @from             = head_encode("\"Kroogi (No Reply)\"".t) + " <noreply@kroogi.com>"
    @subject          = head_encode("[Kroogi] ")
    @sent_on          = Time.now
    @body[:url]       = "http://#{APP_CONFIG[:hostname]}"
    @body[:user]      = recipient
    @body[:recipient] = recipient

  end
end
