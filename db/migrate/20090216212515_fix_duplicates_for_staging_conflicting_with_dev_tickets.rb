class FixDuplicatesForStagingConflictingWithDevTickets < ActiveRecord::Migration
  def self.up
    case RAILS_ENV
      when 'development':
        WebMoneyTicket.connection.execute("ALTER TABLE web_money_tickets AUTO_INCREMENT = #{2_000_000}")
    end
  end

  def self.down
  end
end
