class MonetaryProcessorAccounts::PaypalController < MonetaryProcessorAccounts::BaseController
  # NOTE: Account hookup is handled via IPN in monetary_processors/paypal

  before_filter :login_required
  before_filter :grab_account
  before_filter :require_invoice_agreement, :only => [:paypal]


  # this function received an e-mail address and should try to create a MonetaryProcessorAccount.
  def create_account
    if params[:edress].blank?
      render(:json => {:errors => "Please specify non-empty email".t});
      return
    end
    if !@account_setting.current_monetary_processor_account.nil?
      render(:json => {:errors => "You already has an attached account. Delete it first if you want to attach another one.".t});
      return
    end

    @account = PaypalAccount.new(:account_identifier => params[:edress], :account_setting_id => @account_setting.id,
                                     :monetary_processor => MonetaryProcessor.paypal)
    begin
      @account.save!

      render :json => {:success => true}
    rescue Exception => e
      if e.is_a?(ActiveRecord::RecordInvalid) && @account.errors.on(:email)
        render :json => {:errors => "The email address you've entered appears to be invalid. Maybe you've entered some non-latinic symbols?".t}
      else
        just_notify(e)
        render :json => {:errors => "Sorry, we encountered a problem with your request. {{errors}}" / e.message}
      end
    end
  end
  
  # display a verification screen with information on how to update account
  def verify
    processor_account = @account_setting.current_monetary_processor_account
    (flash[:error] = "Not a PayPal account" and redirect_to "/" and return) if !processor_account.class.eql?('PaypalAccount')
    @paypal_button_id = PAYPAL_CONFIG[:hosted_button_id]
    if @account_setting.paypal_verified? || @account_setting.current_monetary_processor_account.pending_admin_action?
      flash[:success] = @account_setting.paypal_verified? ? "Your account is already verified".t : "You've already sent money to Kroogi. Now waiting for admins to verify your account.".t
      redirect_to :controller => :money, :id => @account_setting.user_id and return
    end
    @account_setting.paypal_pending_user_action! unless @account_setting.paypal_pending_user_action?
    @content_kind_displayname = "Verify PayPal Account".t
  end

  protected 
  def grab_account
    # Allow passing in manually, as long as only passing current actor or a project belonging to current actor
    @user = User.find_by_id(params[:user_id])
    @user ||= current_actor
    raise Kroogi::NotPermitted unless current_user.is_self_or_owner?(@user)
    
    @account_setting = @user.account_setting
    @return_url = url_for(:controller => "money", :action => 'index', :id => @user)
  end

end
