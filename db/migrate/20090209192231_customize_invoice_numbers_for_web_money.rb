class CustomizeInvoiceNumbersForWebMoney < ActiveRecord::Migration
  def self.up
    # change current increment based on environment
    offset = case RAILS_ENV
      when 'development':
        50_000
      when 'staging':
        100_000
      when 'rc':
        250_000
      when 'production':
        5_000_000
      else raise NotImplemented      
    end
    WebMoneyInvoice.connection.execute("ALTER TABLE web_money_invoices AUTO_INCREMENT = #{offset}")
  end

  def self.down
    raise IrreversibleMigration
  end
end
