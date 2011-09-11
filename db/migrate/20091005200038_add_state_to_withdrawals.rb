class AddStateToWithdrawals < ActiveRecord::Migration
  def self.up
    add_column :monetary_transactions, :state, :string
  end

  def self.down
    remove_column :monetary_transactions, :state
  end
end
