class AddTicketsToWebMoney < ActiveRecord::Migration
  def self.up
    add_column :web_money_transfers, :web_money_ticket_id, :integer
    add_column :web_money_invoices,  :web_money_ticket_id, :integer
    
    10.times{ WebMoneyTicket.create } # to get past where our previous requests were

  end

  def self.down
    remove_column :web_money_transfers, :web_money_ticket_id
    remove_column :web_money_invoices, :web_money_ticket_id
  end
end
