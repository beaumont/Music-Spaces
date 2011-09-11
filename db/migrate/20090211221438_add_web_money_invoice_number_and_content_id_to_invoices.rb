class AddWebMoneyInvoiceNumberAndContentIdToInvoices < ActiveRecord::Migration
  def self.up
    add_column :web_money_invoices, :invoice_number, :string
    add_column :web_money_invoices, :content_id, :integer
    add_column :web_money_invoices, :log, :text
  end

  def self.down
    remove_column :web_money_invoices, :log
    remove_column :web_money_invoice, :content_id
    remove_column :web_money_invoice, :invoice_number
  end
end
