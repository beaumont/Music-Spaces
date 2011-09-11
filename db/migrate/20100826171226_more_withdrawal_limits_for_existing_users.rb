class MoreWithdrawalLimitsForExistingUsers < ActiveRecord::Migration
  def self.up
    #set the limit to 0 for existing users who only have verified WM with level <= Initial
    updated = 0
    all_wm = WebMoneyAccount.verified.all(:include => :account_setting, :conditions => ['account_level <= ?', WebMoneyAccount::DEFAULT_MIN_LEVEL])
    all_wm.each do |wm_account|
      updated += AccountSetting.update_all('withdrawal_limit = 0', ['id = ?', wm_account.account_setting.id])
    end
    puts "Went through #{all_wm.count} WM account records, set limit to 0 for #{updated} users"    
  end

  def self.down
  end
end
