class AddContentTypeToSmscoinTransactions < ActiveRecord::Migration
  def self.up
    add_column :smscoin_transactions, :content_type, :string
    Smscoin::Transaction.update_all(['content_type = ?', 'Content'], 'content_id is not null')
  end

  def self.down
  end
end
