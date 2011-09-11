class FixMisconfiguredWebMoneyAccounts < ActiveRecord::Migration
  def self.up
    AccountSetting.update_all(" webmoney_account=NULL, 
                                webmoney_account_verified = NULL,
                                webmoney_wmz_attached = NULL,
                                webmoney_wmr_attached = NULL,
                                webmoney_wme_attached = NULL",
                                # condition
                                "webmoney_account IS NULL")
  end

  def self.down
  end
end
