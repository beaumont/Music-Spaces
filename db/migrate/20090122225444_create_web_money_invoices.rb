class CreateWebMoneyInvoices < ActiveRecord::Migration
  def self.up
    create_table :web_money_invoices do |t|
      t.integer :receiver_account_setting_id, :sender_account_setting_id
      t.integer :source_wmid, :destination_wmid
      t.integer :purse_type, :days
      t.string  :amount, :description
      t.string  :state
      t.boolean :success
      t.timestamps
    end
    add_index :web_money_invoices, :receiver_account_setting_id
  end

  def self.down
    remove_index :web_money_invoices, :receiver_account_setting_id
    drop_table :web_money_invoices
  end
end
