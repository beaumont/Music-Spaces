class SetDefaultStateForWebMoneyInvoice < ActiveRecord::Migration
  def self.up
    WebMoneyInvoice.update_all("state = 'sent'")
  end

  def self.down
    WebMoneyInvoice.update_all("state = NULL")
  end
end
