class WmInitialLevelIsInitialNow < ActiveRecord::Migration
  def self.up
    change_column(:account_settings, :webmoney_passport_minimum, :integer, :default => nil)
    AccountSetting.update_all(['webmoney_passport_minimum = ?', WebMoneyAccount::DEFAULT_MIN_LEVEL], ['webmoney_passport_minimum = 130'])
  end

  def self.down
  end
end
