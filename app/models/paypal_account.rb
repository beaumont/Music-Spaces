class PaypalAccount < MonetaryProcessorAccount
  include AASM
  # Nice STI wrapper to mediate between what's the in DB and a more explanatory verion to display

  before_validation :set_monetary_processor

  # Allow admins to reject acounts
  attr_accessor :skip_password_verification_on_paypal_email

  def validate
    valid_email?
  end

  def valid_email?
    TMail::Address.parse(account_identifier)
  rescue
    errors.add(:email, "Must be a valid PayPal email address!")
  end

  def skip_password_validation?(attrib, value)
    return true if @skip_password_verification_on_paypal_email && attrib.to_sym == :account_identifier
    false
  end

  # Say what?
  def display_subtype
    'Paypal'
  end

  def self.paginate_with_users(options)
    conditions = options[:conditions] || {}
    conditions.merge!(:type => 'PaypalAccount')
    super(options.merge(:conditions => conditions))
  end
  
  def process_withdrawal(withdrawal)
    # masspay the user the amount
    email = self.account_identifier
    paypal_account = ::Paypal::Account.new( PAYPAL_CONFIG[:username], PAYPAL_CONFIG[:password], PAYPAL_CONFIG[:signature])
    masspay = ::Paypal::Request::MassPay.new(paypal_account) do |r|
      r.emailsubject = 'Kroogi Withdrawal'.t
      r.currencycode = 'USD'
      r.receivertype = 'EmailAddress'
    end
    rec = ::Paypal::Request::MassPayRecipient.new(
      :email => email,
      :amt => withdrawal.gross_amount_usd,
      :unique => withdrawal.id,
      :note => 'Your withdrawal has been completed.'.t
    )
    masspay.recipients << rec
    masspay_response = masspay.response
    withdrawal.update_attribute(:monetary_processor_log, masspay_response.inspect.to_s)
    if masspay_response.ack == 'Success'
      # The request was successful, so set state to processing
      log.info "[PAYPAL] #{email} requested a withdrawl for #{withdrawal.gross_amount_usd} successfully."
      return true
    else
      log.error "[PAYPAL] Failed withdrawing #{withdrawal.gross_amount_usd} to #{email}."
      raise StandardError, "Our PayPal account ran out of money? PayPal says:" + masspay_response.inspect
    end
  end

  def payment_system_type_label
    'PayPal'
  end

  private

  def set_monetary_processor
    self.monetary_processor = MonetaryProcessor.paypal if self.monetary_processor.nil?
  end
end
