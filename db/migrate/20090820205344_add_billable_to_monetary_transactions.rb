class AddBillableToMonetaryTransactions < ActiveRecord::Migration
  def self.up
    add_column :monetary_transactions, :billable, :boolean, :default => false
  end

  def self.down
    remove_column :monetary_transactions, :billable
  end
end
