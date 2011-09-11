class CreateWebMoneyTickets < ActiveRecord::Migration
  def self.up
    create_table :web_money_tickets do |t|
      t.timestamps
    end

    offset = case RAILS_ENV
      when 'development':
        5_000_000
      when 'staging':
        10_000_000
      when 'rc':
        20_000_000
      when 'production':
        100_000_000
      else raise NotImplemented      
    end
    WebMoneyTicket.connection.execute("ALTER TABLE web_money_tickets AUTO_INCREMENT = #{offset}")

  end

  def self.down
    drop_table :web_money_tickets
  end
end
