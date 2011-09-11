class UserCanHaveWithdrawalLimit < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :withdrawal_limit, :integer
  end

  def self.down
  end
end
