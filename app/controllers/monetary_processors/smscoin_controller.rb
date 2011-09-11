class MonetaryProcessors::SmscoinController < MonetaryProcessors::BaseController
  verify :method => :post

  before_filter :check_sign_on_status_page, :only => [:success_page, :failure_page]

  def success_page
    @transaction.succeed! unless @transaction.cameback_with_success?
    redirect_to @transaction.return_url
  end

  def failure_page
    @transaction.cancel! if @transaction.user_didnt_comeback? #if it already succeeded, let it remain
    redirect_to @transaction.return_url.gsub('?payment_status=Completed', '').gsub('&payment_status=Completed', '').gsub('payment_status=Completed', '')
  end

  def result
    to_sign = ([APP_CONFIG.smscoin[:secret]] + %w(s_purse s_order_id s_amount s_clear_amount s_inv s_phone).
            map {|key| params[key]}).join('::')
    if Digest::MD5.hexdigest(to_sign) != params[:s_sign_v2]
      AdminNotifier.async_deliver_admin_alert("Invalid sign in SmsCoin postback! Params are #{params.inspect}, env is #{request.env.inspect}")
      render :text => 'bad sign' and return
    end
    
    if params[:s_purse].to_i != APP_CONFIG.smscoin[:purse_id]
      AdminNotifier.async_deliver_admin_alert("Postback from SmsCoin with wrong purse_id: #{params[:s_purse]}. Please check Smscoin control panel.")
      render :text => 'ok' and return
    end

    Smscoin::Transaction.transaction do
      transaction = Smscoin::Transaction.find_by_id(params[:s_order_id], :lock => true)
      
      unless transaction
        AdminNotifier.async_deliver_admin_alert("Postback from SmsCoin with nonexistent transaction: #{params[:s_order_id]}. Params are #{params.inspect}, env is #{request.env.inspect}")
        render :text => 'ok' and return
      end

      unless params[:s_clear_amount] == '1'
        AdminNotifier.async_deliver_admin_alert("Smscoin sent us gross! Please investigate. Params are #{params.inspect}, env is #{request.env.inspect}")
      end

      transaction.create_monetary_donation!(params[:s_amount], self)
    end

    render :text => 'ok'

  end
  
  private
  
  def check_sign_on_status_page
    signed_params = %w(s_purse s_order_id s_amount s_clear_amount s_status)
    to_sign = ([APP_CONFIG.smscoin[:secret]] + signed_params.map {|key| params[key]}).join('::')

    result = false
    if Digest::MD5.hexdigest(to_sign) != params[:s_sign]
      msg = 'Bad parameters - did you want to cheat?'.t
      hint = 'Bad sign.'
    elsif params[:s_purse].to_i != APP_CONFIG.smscoin[:purse_id]
      msg = 'Wrong environment!'
      admin_alert = "Success/failure redirection from SmsCoin with wrong purse_id: #{params[:s_purse]}. Please check Smscoin control panel."
    elsif (@transaction = Smscoin::Transaction.find_by_id(params[:s_order_id]); !@transaction)
      msg = 'Bad parameters - did you want to cheat?'.t
      hint = 'Nonexistent transaction.'
    else
      result = true      
    end

    unless result
      flash[:warning] = msg
      unless admin_alert
        admin_alert = "Somebody tried to cheat Smscoin success/failure redirection? #{hint ? hint + ' ' : ''}Params are #{params.inspect}; current user is #{current_user.login}; env is #{request.env.inspect}"
      end
      AdminNotifier.async_deliver_admin_alert(admin_alert)
      redirect_to explore_path
    end
  end

end
