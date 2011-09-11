class AddInvitationtoMonetaryTransactions < ActiveRecord::Migration
  def self.up
    add_column :monetary_transactions, :invite_id, :integer
    add_column :monetary_transactions, :sms_payload_id, :integer
    add_column :monetary_transactions, :conversion_rate, :decimal,  :precision => 11, :scale => 6
    add_column :monetary_transactions, :sender_email, :string
    add_column :monetary_transactions, :item_name, :string
    add_column :monetary_transactions, :params, :text
    add_column :monetary_transactions, :user_kroog_id, :integer
  end

  def self.down
    remove_column :monetary_transactions, :user_kroog_id
    remove_column :monetary_transactions, :params
    remove_column :monetary_transactions, :item_name
    remove_column :monetary_transactions, :sender_email
    remove_column :monetary_transactions, :conversion_rate
    remove_column :monetary_transactions, :sms_payload_id
    remove_column :monetary_transactions, :invite_id
  end
end
