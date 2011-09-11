# This module is included in the MonetaryDonation model to support paypal
module DonationProcessors
  module Paypal
    include Base
    include LegacyIdHash
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      # create a record from paypal parameters passed by IPN
      def from_paypal_params(params)
        params = params.with_indifferent_access
        returning (find_by_token_and_monetary_processor_id(params[:txn_id], MonetaryProcessor.paypal.id) || self.new) do |d|
          d.params = params
          if d.new_record?
            d.receiver_account_setting_id, d.content_id, sender_user_id, d.karma_point_id, is_goodie = LegacyIdHash.decode(params[:custom])
            d.content_type = Tps::GoodieTicket.name if is_goodie == 1
            begin
              d.sender_account_setting_id = (sender_user_id ? User.find(sender_user_id).account_setting.id : -1)
            rescue Exception => e
              raise Kroogi::Error(e.inspect)
            end
          end
          d.gross_amount = BigDecimal.new(params[:payment_gross].to_s)
          d.monetary_processor_fee = BigDecimal.new(params[:payment_fee].to_s)
          d.currency = params[:mc_currency] || 'USD'
          d.item_name = params[:item_name]
          d.monetary_processor = MonetaryProcessor.paypal
          d.token ||= params[:txn_id]
          d.sender_email = params[:sender_email]
          d.valid? # trigger calculations
        end
      end
    end 

    module Activation
      
      def self.from_paypal_params(params)
        
        # Is this a paypal activation IPN?
        if valid_paypal_activation?(params)
          # update paypal id
          email = params[:payer_email]
          PaypalAccount.update_all(['account_type = ?', params[:payer_id]], {:account_identifier => email})
          paypal_accounts = PaypalAccount.unverified.find_all_by_account_identifier(email)
          logger.warn("[PAYPAL] No pending accounts match mail address #{email}. Stopping") and return if paypal_accounts.blank?
        
          case params[:payer_status]
          when 'verified'
            masspay = ::Paypal::Request::MassPay.new(self.paypal_account) do |r|
              r.emailsubject = 'Kroogi - PayPal Verification'
              r.currencycode = 'USD'
              r.receivertype = 'UserID'
            end
            rec = ::Paypal::Request::MassPayRecipient.new(
              :receiverid => params[:payer_id],
              :amt => params[:payment_gross],
              :note => 'Thank you. Your PayPal account is now active.'
            )
            masspay.recipients << rec
            masspay_response = masspay.response
            if masspay_response.ack == 'Success'
              paypal_accounts.each{|a| a.processing! }
            else
              AdminNotifier.async_deliver_admin_alert("[PAYPAL IPN] Failed sending #{params[:payment_gross]} to #{params[:sender_id]} (#{email})")
            end
          else
            logger.warn("[PAYPAL] Unverified paypal account - #{email} - rejecting")
            paypal_accounts.each do |paypal_account|
              UserNotifier.async_deliver_paypal_notification_unverified(paypal_account.account_setting)
              paypal_account.update_attribute(:reason, 'Unverified Paypal Account')
              paypal_account.reject!
            end
          end
        
        # Is this an masspay IPN for verification?
        elsif valid_masspay_response?(params)
          case params[:status_1]
          when 'Completed'
            logger.info("[PAYPAL] Got a valid masspay response...")
            r = ::Paypal::Request::GetTransactionDetails.new(self.paypal_account)
            r.transactionid = params[:masspay_txn_id_1]
            response = r.response
            logger.error "No such transaction j00 Hax0r! #{params[:masspay_txn_id_1]}" and return unless response.respond_to?(:receiveremail)
            email = response.receiveremail
            logger.debug response.inspect
            logger.info("[PAYPAL] Looking for accounts for #{email} to activate")
            PaypalAccount.processing.find_all_by_account_identifier(email).each do |paypal_account|
              logger.info("[PAYPAL] Activating paypal account for #{email}...")
              user_account = paypal_account.account_setting
              paypal_account.verify!
              Activity.send_message(user_account, user_account.user, :paypal_account_verified)
              UserNotifier.async_deliver_paypal_notification_approved(user_account)
              logger.info("[PAYPAL] Activated Paypal account for #{email}!")
            end
          when 'Failed'
            receiver_id = params[:receiver_id_1]
            logger.info("[PAYPAL] Failed sending $ to #{receiver_id}")
            PaypalAccount.processing.find_all_by_account_type(receiver_id).each do |paypal_account|
              user_account = paypal_account.account_setting
              paypal_account.update_attribute(:reason, 'Unable to receive money')
              paypal_account.reject!
              Activity.send_message(user_account, user_account.user, :paypal_account_rejected)
              logger.info("[PAYPAL] Rejected account for #{paypal_account.account_identifier} becuase they cant receive money")
              UserNotifier.async_deliver_paypal_notification_denied(user_account)
            end
          else
            AdminNotifier.async_deliver_admin_alert "[PAYPAL IPN] Unkown paypal payment status provided: #{params[:payment_status]}. All params: #{params.inspect}"
          end
        else
          logger.info '[PAYPAL] Unknown Paypal IPN Response'
        end      
      end      
      
      def self.valid_masspay_response?(params)
        {
         :txn_type => 'masspay',
         :payment_status => 'Processed',
         :payment_gross_1 => '0.02',
         :payer_email => PAYPAL_CONFIG[:email]
        }.with_indifferent_access.all?{|p| params.entries.include?(p)}
      end            
      
      def self.valid_paypal_activation?(params)
        {
         :payment_gross  => '0.02',
         :txn_type       => 'web_accept',
         :business       => PAYPAL_CONFIG[:email],
         :payment_status => 'Completed'
        }.with_indifferent_access.all?{|p| params.entries.include?(p)}
      end
      
      def self.paypal_account
        ::Paypal::Account.new( PAYPAL_CONFIG[:username], PAYPAL_CONFIG[:password], PAYPAL_CONFIG[:signature])
      end
      
    end
  end
end
