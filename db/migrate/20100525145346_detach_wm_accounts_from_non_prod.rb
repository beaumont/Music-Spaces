class DetachWmAccountsFromNonProd < ActiveRecord::Migration
  def self.up
    return if RAILS_ENV == 'production'
    MonetaryProcessorAccount.webmoney.all(:conditions => "deleted_at IS NULL").each do |acc|
      next unless acc.account_setting
      puts "detaching #{acc.user.login}'s WM.."
      acc.destroy
    end
  end

  def self.down
  end
end
