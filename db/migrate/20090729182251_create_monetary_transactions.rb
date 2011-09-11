class CreateMonetaryTransactions < ActiveRecord::Migration
  def self.up
    create_table :monetary_transactions do |t|
      t.integer  :receiver_id
      t.integer  :sender_id
      t.integer  :content_id
      t.integer  :receiver_account_id
      t.integer  :currency_id
      t.integer  :processor_id
      t.text     :processor_log
      t.decimal  :gross_amount,       :precision => 11, :scale => 2, :default => 0
      t.decimal  :gross_amount_usd,   :precision => 11, :scale => 2, :default => 0
      t.decimal  :processor_fee_usd,  :precision => 11, :scale => 2, :default => 0
      t.decimal  :net_amount_usd,     :precision => 11, :scale => 2, :default => 0
      t.decimal  :payable_amount_usd, :precision => 11, :scale => 2, :default => 0
      t.decimal  :handling_fee_usd,   :precision => 11, :scale => 2, :default => 0
      t.boolean  :applied_to_balance,      :default => false
      t.boolean  :suspicious,              :default => false
      t.boolean  :paid,                    :default => false
      t.string   :type
      t.datetime :available_at
      t.timestamps
    end
    add_index :monetary_transactions, [:receiver_id, :content_id], :name => "mt_r_c"
    add_index :monetary_transactions, [:type], :name => "mt_t"
  end

  def self.down
    remove_index :monetary_transactions, :name => :mt_t
    remove_index :monetary_transactions, :name => :mt_r_c
    drop_table :monetary_transactions
  end
end
