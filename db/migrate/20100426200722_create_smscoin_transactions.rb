class CreateSmscoinTransactions < ActiveRecord::Migration
  def self.up
    create_table :smscoin_transactions, :force => true do |t|
      t.integer :cost_option_id, :null => false
      t.integer :recipient_id, :null => false
      t.integer :content_id
      t.integer :donor_id
      t.integer :karma_point_id
      t.string  :state, :null => false
      t.string  :return_url, :null => false
      t.integer :monetary_donation_id
      t.timestamps
    end
  end

  def self.down
  end
end
