namespace :kroogi do
  namespace :mail do
    desc "Send the mailing out"
    task :send_summary => :environment do
      ActivityMail.send_pending_by_user
    end
  end
end