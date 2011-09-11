require 'web_money'
require 'lib/fetch_email_invitation_requests_job'
require 'action_mailer/ar_sendmail'
require 'base_worker'

class DailyWorker < BaseWorker
  set_worker_name :daily_worker
  
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
    logger.info("[DRB] DailyWorker has started.")
  end
  
  # Apply money to accounts that are ready to receive it
  def apply_available_donations
    MonetaryDonation.apply_available_donations!
  end
  
  # Check for invoices and update their donation and In Rainbow stats
  # when they are successfully paid.
  #
  # days_ago is how far to look back when updating invoices.
  # def update_paid_invoices
  #   logger.info("[DRB #{Time.now.strftime('%m/%d/%Y at %H:%M')}] update_paid_invoices")
  #   WebMoneyInvoice.pending_payments(days_ago=7).each do |invoice|
  #     begin
  #       invoice.paid! if invoice.was_paid?
  #     rescue StandardError => e
  #       logger.info "Unable to process WM Invoice #{invoice.id}!"
  #       logger.info e
  #       logger.info e.backtrace.join("\n")
  #     end
  #   end
  # end  

  def expire_relationships
    logger.info("[DRB #{Time.now.strftime('%m/%d/%Y at %H:%M')}] expire_relationships")
    # expiring_relationships = Relationship.find(:all, :conditions => { :expires_at => 3.days.ago..3.days.from_now })
    # expiring_relationships.each do |rel|
    #   if rel.last_notified_of_expiration && rel.last_notified_of_expiration > 2.days.ago.to_date
    #     Activity.send_message(rel,rel.user,:circle_membership_expiring)
    #   end
    # end
    # Relationship.update_all("`relationships`.`last_notified_of_expiration` = '#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}'", %Q{`relationships`.`expires_at` BETWEEN "#{3.days.ago.strftime('%Y-%m-%d %H:%M:%S')}" AND "#{3.days.from_now.strftime('%Y-%m-%d %H:%M:%S')}"})
  end
  
  def clean_stats_table
    logger.info("[DRB #{Time.now.strftime('%m/%d/%Y at %H:%M')}] clean_stats_table")
    Stat.clear_old!
  end
    
  def send_out_activity_digest_emails
    capture_exception('send_out_activity_digest_emails') do
      ActivityMail.send_pending_by_user
    end
  end
  
  # temp removal for attachment_fu error
  def update_livejournal_entries
    logger.info("[DRB #{Time.now.strftime('%m/%d/%Y at %H:%M')}] update_livejournal_entries")
    updatable_accounts = Account.find(:all, :conditions => ["last_sync IS NULL OR last_sync < ?", 2.hours.ago])
    updatable_accounts.each do |uac|
      curr_user = uac.user.project? ? uac.user.founders.first : uac.user
      next unless curr_user
      next unless curr_user.active? 
      capture_exception('update_livejournal_entries', :log_hello => false) do
        logger.debug("Current user while updating: '#{curr_user.login if curr_user}'")
        begin
          Thread.current['user'] = curr_user
          uac.update_cache if curr_user
        ensure
          Thread.current['user'] = nil
        end  
      end
      sleep(0.4)
    end
  end
    
  # Movable data contains conversions of currency, so it needs to be kept up to date... but we won't want to hammer their servers on each request
  def update_movable_sms_data
    capture_exception('update_movable_sms_data', :mail => true) do
      Movable::Country.update_data_from_movable!
    end
  end

  def update_smscoin_sms_data
    capture_exception('update_smscoin_sms_data', :mail => true) do
      Smscoin::Version.check_remote
      Smscoin::Version.remove_old_cost_options
    end
  end
  
  def update_content_popularity
    Content.update_popularity
  end

  def update_user_popularity
    User.update_popularity
  end

  def truncate_new_contents
    stale = true
    #paginated removal, to keep the concurrent queries healthy
    while stale
      stale = NewContent.truncate(10000, :batch_size => 100)
      sleep(1) if stale
    end
  end

  def fetch_email_invitation_requests
    capture_exception('fetch_email_invitation_requests') do
      FetchEmailInvitationRequestsJob.new(logger).run
    end
  end

  def email_invitation_requests_inbox_cleanup
    capture_exception('email_invitation_requests_inbox_cleanup') do
      FetchEmailInvitationRequestsJob.new(logger).inbox_cleanup
    end
  end

  def digest_error_emails
    capture_exception('digest_error_emails') do
      ActionMailer::ARSendmail.digest_error_emails(:dump_path => APP_CONFIG.log_path,
                                                   :subj_prefix => ExceptionNotifier.email_prefix,
                                                   :smtp_settings => APP_CONFIG.server_mail)
    end
  end

  def update_related_contents
    Content.update_related_contents
  end

  def reload_currencies_cache
    capture_exception('reload_currencies_cache', :mail => true) do
      CashHandler::Base.instance.reload_cache
    end
  end

  def remove_finished_bdrb_jobs
    capture_exception('remove_finished_bdrb_jobs', :mail => true) do
      BdrbJobQueue.delete_all(['finished AND finished_at < ?', Date.today])
    end
  end

  def restore_restorable_bdrb_jobs
    #some failed BDRB jobs are safe to restore. let's do it.
    capture_exception('restore_restorable_bdrb_jobs', :mail => true) do
      BdrbJobQueue.update_all('taken = 0', ['taken = 1 AND finished = 0 AND started_at < ? AND ' +
              'worker_name = "misc_tasks_worker" AND worker_method in (?)', Time.now - 2.hours,
              %w(send_to_all_friends)])

      BdrbJobQueue.update_all('taken = 0', ['taken = 1 AND finished = 0 AND started_at < ? AND ' +
              'worker_name ="directories_feeds_worker"', Time.now - 2.hours])

      BdrbJobQueue.update_all('taken = 0', ['taken = 1 AND finished = 0 AND started_at < ? AND ' +
              'worker_name ="email_worker"', Time.now - 15.minutes])
    end
  end

  #for some reason we junk collection inclusions are created time to time. until this is investigated, let's have garbage collector
  def remove_junk_collection_inclusions
    capture_exception('remove_junk_collection_inclusions', :mail => true) do
      logger.info "#{ProjectAsContent.remove_junk.size} PACs removed"
    end
  end

  def expire_unfinished_tps_tickets
    capture_exception('expire_unfinished_tps_tickets', :mail => true) do
      expiration_time = (RAILS_ENV == 'production' ? 1.hour : 5.minutes)
      Tps::GoodieTicket.unfinished.updated_before(Time.now - expiration_time).destroy_all
    end
  end

  def remove_old_invites
    capture_exception('remove_old_invites', :mail => true) do
      #unanswered invites to existing users - the most popular category now
      Invite.delete_all(['state = ? and user_id is not null and created_at < ?', 'pending', Date.today - 3.months])
    end
  end

  def rotate_feed_entries
    capture_exception('rotate_feed_entries', :mail => true) do
      logger_proc = lambda {|msg| logger.info(msg)}
      FeedEntry.rotate(6.weeks, logger_proc)
    end
  end
end

