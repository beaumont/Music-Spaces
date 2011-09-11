require 'base_worker'

class EmailWorker < BaseWorker
  # Background worker to send async email for "realtime" deliver option. For periodic digest sending, see daily_worker#send_out_activity_digest_emails

  set_worker_name :email_worker
  #reload_on_schedule true
  def create(args = nil)
    logger.info "email worker started"
    # this method is called, when worker is loaded for the first time
  end
  
  def deliver_email(params)
    capture_exception('deliver_email', :args => params, :mail => true) do
      mailer, meth, mail_args = params
      mailer.classify.constantize.send("deliver_#{meth}", *mail_args)
      persistent_job.finish!
    end
  end
end

