class AddConfigForMinimumWithdrawal < ActiveRecord::Migration
  def self.up
    add_column :account_settings, :minimum_withdrawal_amount, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :account_settings, :minimum_withdrawal_amount
  end
end
