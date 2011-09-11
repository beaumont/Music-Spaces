%w(2897859 2897903 2897904 2897905 2897906 2897908 2897910 2901616 2901618 2914044 2923289 2930504 2951020 2951021).each do |token|
  md = MonetaryTransaction.find_by_token_and_monetary_processor_id(token, MonetaryProcessor.movable_broker.id)
  unless md
    puts "transaction with token %s not found" % token
    next
  end
  if md.applied_to_balance?
    puts "transaction with token %s was applied to balance. amount = %s" % [token, md.payable_amount_usd]
    md.receiver.decrement!(:balance_usd, md.payable_amount_usd)
  end
  md.applied_to_balance = false
  md.suspicious = true
  md.save_without_validation!
end
