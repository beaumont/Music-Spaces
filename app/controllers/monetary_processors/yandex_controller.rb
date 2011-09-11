require 'httpclient'

class MonetaryProcessors::YandexController < MonetaryProcessors::BaseController

  ERROR_CODES = {:success => 0, :auth_error => 1, :bad_request => 200, :tech_error => 1000}

  before_filter :forward_to_env, :only => [:result, :check_order] 
  before_filter :check_postback_validity, :except => [:failure_page]
  before_filter :check_sign, :only => [:result, :check_order]

  def check_order
    log.error "not forwarded, returning success.."
    respond_to_postback_with_success
  rescue => e
    AdminNotifier.async_deliver_admin_alert("Error processing Yandex order check. Error: #{e.inspect}. Params were: \n#{params.inspect}")
    respond_to_postback_with_code(ERROR_CODES[:tech_error])
  end

  def result
    @mon_contrib = MonetaryDonation.from_yandex_params(params)
    @mon_contrib.save!

    respond_to_postback_with_success
  rescue => e
    AdminNotifier.async_deliver_admin_alert("Error processing Yandex payment result. Error: #{e.inspect}. Params were: \n#{params.inspect}")
    respond_to_postback_with_code(ERROR_CODES[:tech_error])
  end

  def success_page
    redirect_to params[:return_url]
  end

  def failure_page
    redirect_to params[:return_url].gsub('?payment_status=Completed', '').gsub('payment_status=Completed', '')
  end
  
  def self.build_customer_id(params)
    result = params[:donor_login] || ''
    result = Kroogi.environmental(result)
    result
  end

  private

  def forward_to_env
    customer_number = params[:customerNumber]
    if RAILS_ENV == 'production' && customer_number && customer_number[Kroogi::ENV_SEPARATOR]
      env_id = customer_number.split(Kroogi::ENV_SEPARATOR)[0]
      uri = APP_CONFIG.kroogi_hosts[env_id.to_sym]
      uri += request.path
      clnt = HTTPClient.new
      res = clnt.post(uri, params)
      render :layout => false, :xml => res.content
      log.error "successfully forwarded to #{uri}"
    else
      return if !customer_number
      if customer_number[Kroogi::ENV_SEPARATOR]
        if customer_number.split(Kroogi::ENV_SEPARATOR)[0] != APP_CONFIG.env_id
          raise "Received postback forward for wrong host! Params are #{params.inspect}, env is #{request.env.inspect}"
        end
        params[:customer_number] = customer_number.split(Kroogi::ENV_SEPARATOR)[1]
      else
        params[:customer_number] = customer_number
      end
    end
  end

  def respond_to_postback_with_success
    respond_to_postback_with_code(ERROR_CODES[:success])
  end
  
  def respond_to_postback_with_code(code)
    response.content_type = "application/xml"
    response.charset = "windows-1251"
    xml_response = %{
      <?xml version="1.0" encoding="windows-1251"?>
      <response performedDatetime="#{Time.now.xmlschema}">
        <result code="#{code}" action="#{yandex_action_name}" shopId="#{yandex_config[:ShopId]}" invoiceId="#{params[:invoiceId]}"/>
      </response>
    }.strip

    log.error "xml_response: \n#{xml_response}"
    render :layout => false, :xml => xml_response
  end

  def check_postback_validity
    log.error "check_postback_validity reached. Params are: \n#{params.inspect}"
    #success and failure pages have shopID param instead of shopId 
    unless (params[:shopId] || params[:shopID]) == yandex_config[:ShopId].to_s
      AdminNotifier.async_deliver_admin_alert("Error processing Yandex postback. ShopId is incorrect. Params are #{params.inspect}, env is #{request.env.inspect}")
      respond_to_postback_with_code(ERROR_CODES[:bad_request])
    end
  end

  #Yandex sends it in its 'action' parameter but it's overwritten by Rails
  def yandex_action_name
    {'check_order' => 'Check', 'result' => 'PaymentSuccess'}[params[:action]]
  end

  def check_sign
    to_sign = ((%w(orderIsPaid orderSumAmount orderSumCurrencyPaycash orderSumBankPaycash shopId invoiceId customerNumber).
            map {|key| params[key].to_s}) + [yandex_config[:shopPassword]]).join(';')
    sign = Digest::MD5.hexdigest(to_sign).upcase
    log.debug "expected md5 is #{sign} based on string #{to_sign}"
    unless sign == params[:md5]
      AdminNotifier.async_deliver_admin_alert("Error processing Yandex postback. md5 is incorrect. Params are #{params.inspect}, env is #{request.env.inspect}")
      respond_to_postback_with_code(ERROR_CODES[:auth_error])
    end
  end
end
