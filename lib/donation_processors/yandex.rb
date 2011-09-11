# This module is included in the MonetaryDonation model to support WebMoney
module DonationProcessors
  module Yandex
    include Base
    include LegacyIdHash

    def self.included(base)
      base.extend(ClassMethods)
    end

    def self.config(params = {})
      return YANDEX_CONFIG if RAILS_ENV == 'production'
      result = params[:recipient_id].to_s == "2" ? YANDEX_TEST_PROD_CONFIG : YANDEX_CONFIG
      result
    end

    def self.build_payment_form_params(params)
      params = config(params).merge(params).merge(
              :shopSuccessUrl => "http://#{APP_CONFIG.hostname}/monetary_processors/yandex/success_page",
              :shopFailUrl => "http://#{APP_CONFIG.hostname}/monetary_processors/yandex/failure_page"
              ).symbolize_keys
      params.delete(:attributes)
      params[:customerNumber] = MonetaryProcessors::YandexController.build_customer_id(params)
      pass = %w(ShopId scid Sum shopSuccessUrl shopFailUrl customerNumber)
      to_sign = (pass.map {|key| params[key.to_sym].to_s} + [config(params)[:shopPassword]]).join(';')
      log.debug "to_sign = #{to_sign}"
      params.merge!(:md5 => Digest::MD5.hexdigest(to_sign).upcase)
      pass += %w(content_id content_type recipient_id karma_point_id md5 itemName return_url)
      pass.map {|key| [key, params[key.to_sym]]}
    end
    
    module ClassMethods
      # create a record from yandex parameters passed by IPN
      def from_yandex_params(params)
        mc = (find_by_token_and_monetary_processor_id(params[:invoiceId], MonetaryProcessor.yandex.id) || self.new)
        params[:itemName] = Iconv.iconv('utf-8', 'windows-1251', params[:itemName]).first
        mc.params = params
        if mc.new_record?
          mc.receiver_account_setting_id = User.find_by_id(params[:recipient_id]).account_setting.id
          mc.content_id = params[:content_id]
          mc.content_type = params[:content_type]
          mc.content_type = 'Content' if mc.content_type.blank?
          download = (params[:download] != 'false')
          mc.sender_account_setting_id = User.find_by_login(params[:customer_number]).account_setting.id unless params[:customer_number].blank? #customerNumber transformed to customer_number in preprocessor
          mc.karma_point_id = params[:karma_point_id]
        end
        if params[:orderIsPaid] == '0'
          return nil if mc.new_record?
          AdminNotifier.async_deliver_admin_alert("Yandex postback told us that donation #{mc.id} is unpaid. We aren't ready for such a case, please take care.")
          return mc
        end
        mc.gross_amount = BigDecimal(params[:orderSumAmount])
        usd_currency = DonationProcessors::Yandex.config(params)[:attributes]['usd_code'].to_s
        rur_currency = DonationProcessors::Yandex.config(params)[:attributes]['rur_code'].to_s
        gross_currency = params[:orderSumCurrencyPaycash]
        unless usd_currency == gross_currency 
          raise "Currency of YM gross is unexpected: #{gross_currency}. We expect #{usd_currency}. Please investigate."
        end
        net_currency = params[:shopSumCurrencyPaycash]
        unless [usd_currency, rur_currency].include?(net_currency)
          raise "Currency of YM net is unexpected: #{net_currency}. We expect #{usd_currency} or #{rur_currency}. Please investigate."
        end
        net = BigDecimal(params[:shopSumAmount])
        mc.currency = "USD"
        if net_currency == rur_currency
          #convert net to USD for less number of conversions and hence errors
          net = CashHandler::Base.instance.convert(net, 'RUR', 'USD')
        end
        mc.monetary_processor_fee = mc.gross_amount - net
        mc.monetary_processor_id = MonetaryProcessor.yandex.id
        mc.token ||= params[:invoiceId]
        if params[:shopSumCurrencyPaycash] != params[:orderSumCurrencyPaycash]
          AdminNotifier.async_deliver_admin_alert("Yandex postback told us that net currency is different from gross for transaction #{mc.token}. " +
                  "We aren't ready for such a case, please take care.")
        end
        mc
      end
    end
  end
end
