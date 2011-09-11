class AcceptingAllExistingPaypalEmailsAsVerified < ActiveRecord::Migration
  # Logic change - Anya requests that all users currently possessing a paypal_email on prod get verified

  def self.up
    AccountSetting.with_paypal.find(:all, :include => :user).each do |ac|
      puts "Approving both paypal and general money for #{ac.user.login}."

      puts "Before:\tPaypal: #{ac.display_paypal_status}\tGeneral: #{ac.money_status}"
      puts "Status saving: #{ac.set_paypal_status!('verified')}"
      ac.update_attribute(:money_status, 'money_approved')
      ac_new = AccountSetting.find(ac.id)
      puts "After:\tPaypal: #{ac_new.display_paypal_status}\tGeneral: #{ac_new.money_status}"
      puts "\n\n"
    end
  end

  def self.down
  end
end
