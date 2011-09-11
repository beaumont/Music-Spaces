class MonetaryWithdrawal < MonetaryTransaction
  
  validates_presence_of :receiver, :monetary_processor
  belongs_to :monetary_processor_account # withdrawal account

  named_scope :paid, :conditions => {:paid => true}
    
  def validate
    errors.add(:receiver, 'does not have enough funds available'.t) unless enough_funds_available?
  end

  # make the processor send the money to the user
  def process_transaction!
    processor_error = nil
    err_prefix = "Error processing withdrawal of #{self.receiver.user.login}."
    MonetaryWithdrawal.transaction do
      self.save(false) if self.new_record? # we need the ID for reference, thus save + transaction
      if !applied_to_balance?
        begin
          if self.valid?
            if !self.paid?
              monetary_processor_account.process_withdrawal(self)
              self.update_attribute(:paid, true)
            end
          else
            raise StandardError, self.errors.collect.join(' ')
          end
          negate_receiver_balance(self)
        rescue Kroogi::Money::ProcessorInternalError => e
          self.update_attribute(:paid, true)
          negate_receiver_balance(self)
          e.prefix = err_prefix
          e.suggestion = "Please make sure the transfer really happened (but give processor several minutes) - we don't want the author to be unhappy."
          processor_error = e
        rescue Kroogi::Money::WithdrawalFailed => e
          self.update_attribute(:paid, false)
          e.prefix = err_prefix
          e.suggestion = "Please make sure the transfer really didn't happen (but give processor several minutes) - we don't want to loose money."
          processor_error = e
        end
      end
    end
    raise processor_error if processor_error
  end
    
  protected
  
  def negate_receiver_balance(trans)
    receiver.decrement!(:balance_usd, trans.payable_amount_usd)
    self.update_attribute(:applied_to_balance, true)
  end

  def enough_funds_available?
    receiver.balance_usd >= self.gross_amount_usd
  end
  
end
