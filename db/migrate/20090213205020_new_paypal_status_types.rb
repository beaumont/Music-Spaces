class NewPaypalStatusTypes < ActiveRecord::Migration

  # OLD STATUS STYLE: verified
  # NEW STATUS STYLE: verified:user@domain.com
  def self.up
    AccountSetting.find(:all, :conditions => 'paypal_status IS NOT NULL AND paypal_status <> ""').each do |acct|
      next if acct.paypal_status.include?(':')
      acct.update_attribute(:paypal_status, "#{acct.paypal_status}:#{acct.paypal_email}")
    end    
  end

  def self.down
    AccountSetting.find(:all, :conditions => 'paypal_status IS NOT NULL AND paypal_status <> ""').each do |acct|
      status = acct.paypal_status.scan(/(.+):/).first
      next unless status && !status.first.blank?
      acct.update_attribute(:paypal_status, status.first)
    end
  end
end
