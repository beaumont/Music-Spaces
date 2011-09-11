class FixingDonationAndVerificationStatuses < ActiveRecord::Migration
  def self.up
    AccountSetting.transaction do
      # Splitting verification out from money requests
      add_column :account_settings, :verified_by_kroogi, :boolean, :default => false
      AccountSetting.update_all ['verified_by_kroogi=?, request_status=?', true, 'approved'], 'request_status = "verified"'

      # Make the money part of the status explicit (as opposed to e.g. paypal, yandex, webmoney statuses, etc.)
      puts "Cycling through all AccountSettings - this may take a bit"
      all_recs = AccountSetting.find(:all, :conditions => 'request_status IS NOT NULL AND request_status <> "" and request_status NOT LIKE "money%"')
      puts "(there are #{all_recs.size} records)"
      all_recs.each_with_index do |acct, idx|
        puts "Now #{idx} of #{all_recs.size}" if idx % 500 == 0
        acct.update_attribute(:request_status, "money_#{acct.request_status}")
      end
      
      # Make column name reflect what it really is now
      rename_column :account_settings, :request_status, :money_status
    end
  end

  def self.down
    AccountSetting.transaction do
      rename_column :account_settings, :money_status, :request_status
      
      puts "Cycling through all AccountSettings - this may take a bit"
      AccountSetting.find(:all, :conditions => 'request_status IS NOT NULL AND request_status <> ""').each do |acct|
        acct.update_attribute(:request_status, acct.request_status.gsub(/money_/, ''))
      end
      
      AccountSetting.update_all 'request_status = "verified"', ['verified_by_kroogi=? and request_status=?', true, 'approved']
      remove_column :account_settings, :verified_by_kroogi
    end
  end
end