# This module is included in the MonetaryDonation model to support MovableBroker
module DonationProcessors
  module MovableBroker
    include LegacyIdHash
    include Base

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def sms_checksum_for(string)
        Digest::MD5.hexdigest(string + SmsPayload::SMS_SECRET)
      end

      def figure_out_sender_account_setting_id(sms)
        return -1 unless sms.from_user_id
        return -1 unless user = User.find_by_id(sms.from_user_id)
        (log.error "Missing account_setting in DonationProcessors::MovableBroker: user_id = #{user.id.to_s}"; return -1) unless user.account_setting
        user.account_setting.id
      end

      # Create a record from sms params
      def create_from_movable_broker_params(params, request)
        sms = retrieve_sms_from_postback(params, request)
        # OK, we've got our record, now make the contribution with appropriate money fields (Movable passed cents, make to dollars)
        md = returning(find_by_token_and_monetary_processor_id(params[:message_id], MonetaryProcessor.movable_broker.id) || self.new) do |d| 
          d.params                      = params
          d.receiver = sms.to_account_setting
          d.content_id                  = sms.payment_for.is_a?(Content) ? sms.payment_for.id : nil
          d.sender_account_setting_id   = figure_out_sender_account_setting_id(sms)
          d.gross_amount                = BigDecimal.new(params[:ref_cost].to_s) / 100.0
          net = BigDecimal.new(params[:cost].to_s) / 100.0 
          d.monetary_processor_fee  = d.gross_amount - net
          d.currency                    = parse_currency(params[:lcurrency])
          set_default_currency_maybe(d)
          d.monetary_processor_id       = MonetaryProcessor.find_by_short_name('movable_broker').id
          d.token ||= params[:message_id]
          d.sms_payload                 = sms
          d.valid?
        end
        # Good to go -- save, record success, and return
        md.save!
        #doesn't seem to be needed
        #Activity.send_message(md, User.find_by_id(sms.from_user_id), :sms_payment_success)
        md
      end

      # Handle logic checking and returning the proper smms payload for a given postback
      def retrieve_sms_from_postback(params, request)
        # MD5 of ((unescaped (querystring - cs param)) concat secret key)
        our_hash = sms_checksum_for( request.query_string.gsub(/&cs=#{params[:cs]}/, '') )
          raise Kroogi::MovableBroker::InvalidChecksum, "Ours: #{our_hash}\nTheirs: #{params[:cs]}\nraw: #{request.query_string}\ndecoded: #{CGI::unescape(request.query_string)}" unless our_hash == params[:cs]

        # OK, digests match, good to go
        # raise Kroogi::MovableBroker::UnsupportedEnvironment, "SMS Postbacks can only be accepted on stage or in production. Current environment is #{RAILS_ENV}." unless RAILS_ENV == 'production' || RAILS_ENV == 'staging'
        payload =  params[:text].gsub(/.*?#{SmsPayload::SMS_MEMBER_NUMBER} /,'')
        sms = SmsPayload.retrieve(payload)
        sms = SmsPayload.retrieve(payload.downcase) unless sms 
        raise Kroogi::MovableBroker::NoMatchingPayload, "Received valid postback with non-existent payload #{payload}" unless sms

        # Mark it received, or create a new one if it's already been handled
        return sms.handle_postback
      end


      def parse_currency(param)
        return 'RUR' if param == 'RUB' # Parses the currency. We only handle RUR, passed as RUB. String thanks... *quack*
        param
      end

      def set_default_currency_maybe(donation)
        if !donation.currency
          default_currency = 'USD'
          #AdminNotifier.async_deliver_alert("SMS postback without currency! Defaulting to %s. Params are: %s" % [default_currency, params])
          donation.currency = default_currency
        end
      end

    end
  end
end
