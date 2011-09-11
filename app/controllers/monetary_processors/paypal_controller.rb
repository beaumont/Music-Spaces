class MonetaryProcessors::PaypalController < MonetaryProcessors::BaseController
  verify :method => :post

  # Only used to receive notification from PayPal after transactions
  def instant_payment_notification
    begin
      if valid_withdrawal_response?(params)
        MonetaryWithdrawal.find_by_id(params[:unique_id_1]).update_attribute(:paid, true)
      elsif DonationProcessors::Paypal::Activation.valid_masspay_response?(params) || DonationProcessors::Paypal::Activation.valid_paypal_activation?(params)
        DonationProcessors::Paypal::Activation.from_paypal_params(params)
      else
        @donation = MonetaryDonation.from_paypal_params(params)
        @donation.add_to_kroogi_circle(@invite_kroogi)
        @donation.invite = @invite
        @donation.save(false)
      end
    rescue Kroogi::Error => e
      AdminNotifier.async_deliver_admin_alert("Error receiving payment notification from PayPal: #{e.inspect}. Params:\n#{params.inspect}")
    end
    render :nothing => true
  end
  
  protected
  
  def valid_withdrawal_response?(params)
    {
     :txn_type => 'masspay',
     :payment_status => 'Processed',
     :payer_email => PAYPAL_CONFIG[:email]
    }.with_indifferent_access.all?{|p| params.entries.include?(p)} && !params[:unique_id_1].blank? &&
        has_pending_withdrawal?(params[:unique_id_1])
  end
  
  def has_pending_withdrawal?(id)
    w = MonetaryWithdrawal.find_by_id(params[:unique_id_1])
    return false unless w
    !w.paid?
  end
    
end
