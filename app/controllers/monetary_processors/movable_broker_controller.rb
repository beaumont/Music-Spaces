class MonetaryProcessors::MovableBrokerController < MonetaryProcessors::BaseController
  before_filter :check_invitation

  def movable_broker_postback
    logger.info "[POSTBACK] Running MovableBroker's SMS postback"
    md = nil
    begin
      md = MonetaryDonation.create_from_movable_broker_params(params, request)
    rescue ActiveRecord::RecordInvalid => e
      raise "Trying to save MonetaryDonation failed!. Errors: %s.\n\nMC: %s\n\nSMS (%s): %s\n\nAC (%s): %s\n\n Trace: %s" %
              [md.errors.full_messages, md.inspect, md.sms_payload.id, md.sms_payload.attributes.to_yaml,
               md.account_setting.id, md.account_setting.attributes.to_yaml, e.inspect]
    end
    
    headers["Content-Type"] = "text/plain; charset=utf-8"
    # PaymentType is hardcoded to 2.  Not sure of the point of PaymentType
    render(:text=>"DestWMid=#{ CGI::escape(WEBMONEY_CONFIG[:purse_usd])}&PaymentType=2&Answer=#{ CGI::escape("Thank you! #{md.receiver.user.login} appreciates your generosity.")}")
  end
  
end
