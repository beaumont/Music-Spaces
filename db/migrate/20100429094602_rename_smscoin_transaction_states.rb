class RenameSmscoinTransactionStates < ActiveRecord::Migration
  def self.up
    Smscoin::Transaction.update_all(['state = ?', 'user_didnt_comeback'], ['state = ?', 'pending'])
    Smscoin::Transaction.update_all(['state = ?', 'cameback_with_success'], ['state = ?', 'succeeded'])
    Smscoin::Transaction.update_all(['state = ?', 'cameback_with_failure'], ['state = ?', 'cancelled'])
  end

  def self.down
  end
end
