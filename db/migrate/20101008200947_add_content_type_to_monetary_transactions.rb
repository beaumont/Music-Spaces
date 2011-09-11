class AddContentTypeToMonetaryTransactions < ActiveRecord::Migration
  def self.up
    add_column :monetary_transactions, :content_type, :string
    MonetaryTransaction.update_all(['content_type = ?', 'Content'], 'content_id is not null')
  end

  def self.down
  end
end
