class AddTokenToMonetaryTransactions < ActiveRecord::Migration
  def self.up
    add_column :monetary_transactions, :token, :string
  end

  def self.down
    remove_column :monetary_transactions, :token
  end
end
