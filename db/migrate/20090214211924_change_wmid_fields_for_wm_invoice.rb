class ChangeWmidFieldsForWmInvoice < ActiveRecord::Migration
  def self.up
    change_column :web_money_invoices, :source_wmid, :string
    change_column :web_money_invoices, :destination_wmid, :string
    WebMoneyInvoice.delete_all
  end

  def self.down
    change_column :web_money_invoices, :destination_wmid, :string
    change_column :web_money_invoices, :source_wmid, :string
  end
end
