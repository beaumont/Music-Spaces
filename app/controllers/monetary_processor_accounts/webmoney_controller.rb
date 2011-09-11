# This controller handles validation of webmoney accounts,
# acceptance of donations, and purse activation.
class MonetaryProcessorAccounts::WebmoneyController < MonetaryProcessorAccounts::BaseController
  # Filter order is important here...
  before_filter :set_context_user

  include WmErrorsHandler

  # this function received an e-mail address and should try to create a MonetaryProcessorAccount.
  def create_account
    begin
      if params[:user_id].blank? || params[:activation_code].blank?
        render(:json => {:errors => "Server error occurred.  We've been notified.".t});
        AdminNotifier.async_deliver_alert "/monetary_processor_accounts/webmoney_usd/create_account error on user_id: params = #{params.inspect}"
        return
      end
      as = @context_user.account_setting
      if !as.current_monetary_processor_account.nil?
        render(:json => {:errors => "This user already has an attached account.".t});
        return
      end

      req = WebMoney::Ext::Client.activate_purse(WebMoneyAccount.account_identifier(as), 'Z'[0], params[:activation_code])
      if req.activatePurseResult == 0 # success
        mpa = WebMoneyAccount.create(
          :monetary_processor_id => MonetaryProcessor.find_by_short_name('webmoney_usd').id,
          :account_setting_id    => as.id,
          :verified_at           => Time.now)

        unless mpa.is_permitted_to_receive_wm?
=begin
tranny hints
  'Any Passport'.t
  'Anonymous Passport'.t
  'Initial Passport'.t
  'Personal Passport'.t
  'Merchant Passport'.t
=end
          render(:json => {:errors => "This Account doesn't have a {{level}} or higher." / mpa.minimum_level_required.t})
          mpa.deleted_at = Time.now
          mpa.save(false)
          return
        end

        mpa.verify! 
        render :json => {:success => true}
      else
        render(:json => {:errors => "Sorry, we were unable to activate your account with the provided WMID and activation code.".t})
      end
    rescue WebMoney::Errors::ConversationError => e
      just_notify(e.source)
      render(:json => {:errors => "Sorry, conversation error happened when talking to Webmoney server. We're notified of the issue and will try to help.".t})
    rescue Exception => e
      just_notify(e)
      render(:json => {:errors => "Sorry, we encountered a problem with your request.".t})
    end
  end


  # Allow the user an option to attach a purse or create an invoice.
  def attach
    return unless require_invoice_agreement
    update_webmoney_accounts(@context_user)

    @account_setting = @context_user.account_setting
        
    if request.post?
      # protect against people changing account #'s and using other peoples accounts.
      @account_setting.webmoney_account = params[:donation][:sender_wmid]
      @account_setting.webmoney_account_verified = false
      if @account_setting.save
        redirect_to webmoney_path(:action => :activate, :id => @context_user) and return
      else
        @account_setting.validate_password(current_user,params[:password])
        flash.now[:error] = 'Unable to update your WebMoney account information'.t
        render :action => :attach and return
      end
    end
  end
  
  # Activate a purse
  # Activate your account if the account has been attached but not activated with the code
  # They can enter the code here or click a link at their webmoney inbox.
  # PS: Thank WM, you should provide the purse type on return url :(
  def activate
    return unless wm_account = require_attacher_has_webmoney_account(@context_user)

    update_webmoney_accounts(@context_user, wm_account)

    redirect_to webmoney_path(:action => :invoice, :id => @context_user) and return if params[:commit] == 'one_time'
    
    @link = WebMoney::Ext::Client.activation_link(wm_account.account_identifier, request.url)
    
    # Activate _their_ account by a hash provided by a WM redirect - but timing may be off for WM update.
    if valid_webmoney_activation_hash?
      current_actor.account_setting.update_existing_webmoney_activations(wm_account)
      flash.now[:success] = "Your WebMoney purse has been attached, please enter your activation code to complete the process.".t
      return
      #redirect_back_or_default "/money" and return
    end

    # Activate by code
    if activating_webmoney_account?
      req = WebMoney::Ext::Client.activate_purse(wm_account.account_identifier, params[:purse_type].to_i, params[:activation_code])
      if req.activatePurseResult == 0 # success
        flash[:success] = "Your WebMoney purse has been activated.".t
        @context_user.account_setting.update_attribute(:webmoney_account_verified, true)
        prep = params[:purse_type].to_i.chr.downcase
        @context_user.account_setting.update_attribute("webmoney_wm#{prep}_attached", true)
        @context_user.account_setting.update_existing_webmoney_activations(wm_account)
        redirect_to :controller => '/money', :action => 'index', :id => @context_user.id
      else
        flash.now[:error] = "Sorry, we were unable to activate your account with the provided activation code.".t
        render :action => 'activate' and return false        
      end
    end
    
    # Returning from clicking on attach at WM inbox.
    if params[:err] == '0'
      flash[:notice] = "Your WebMoney purse has been activated.".t
      redirect_to "/money"
    elsif params[:err] == '13'
      flash.now[:error] = "Sorry, we are unable to activate your account at this time.".t
    end
    
  end
  
  def purse_balances
    if account = @context_user.account_setting.webmoney_account
      @context_user.account_setting.update_existing_webmoney_activations(account)
      @balances = WebMoney::Ext::Client.get_user_purses_balance(account.account_identifier).pursesBalances
    else
      @balances = []
    end
    respond_to do |wants|
      wants.js
    end
  rescue Errno::ECONNRESET => e
    # This is javascript only, return 408 (Request Timeout) with an explanation string.
    respond_to do |wants|
      wants.js { render :text => 'Service Unavailable'.t, :status => 408 }
    end
  end
    
  protected
  
  def update_webmoney_accounts(user, wm_account = nil)
    user.account_setting.update_existing_webmoney_activations(wm_account)
  end

  def require_attacher_has_webmoney_account(user)
    as = user.account_setting
    if as.blank? || as.current_monetary_processor_account.nil? || !as.current_monetary_processor_account.is_a?(WebMoneyAccount)
      redirect_to webmoney_path(:action => :attach, :id => user) and return false
    end
    as.current_monetary_processor_account
  end

  private
  
  # generate a true hex string (byte array) from a hex representation of a string
  # used for validating webmoney hashes
  def hex16(s)
    ret_str = ''
    s.scan(/[0-9a-f]{2}/).each do |a| # split in bytes
      ret_str << a.to_i(base=16).chr
    end
    return ret_str
  end
  
  def hash_for_elements(*args)
    hex = hex16(Digest::SHA1.hexdigest(args.map(&:to_s).join).chomp).chomp
    Base64::encode64(hex).chomp
  end
  
  def activating_webmoney_account?
    params[:commit] == 'activate'
  end
  
  # check the activation response string from WM, and validate their account locally.
  
  def valid_webmoney_activation_hash?
    if params[:USID] && params[:err] && params[:hash]
      wm_cfg = WebMoney::Ext::Client.config
      hash = hash_for_elements(wm_cfg[:social_network_id],params[:USID],params[:err],wm_cfg[:secret])
      CGI.unescape(params[:hash]) == CGI.unescape(hash)
    else
      false
    end
  end
  
  def set_context_user
    if @skip_invoice
    else
      # Allow passing in manually, as long as only passing current actor or a project belonging to current actor
      @context_user = User.find_by_id(params[:user_id])
      @context_user ||= current_actor
      raise Kroogi::NotPermitted unless current_user.is_self_or_owner?(@context_user)
    end
  end
  
end
