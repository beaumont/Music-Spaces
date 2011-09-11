# This controller handles validation of webmoney accounts,
# acceptance of donations, and purse activation.
class Donate::WebmoneyController < Donate::BaseController

  # Allow creation of donation in session before login (for redirect-back support)
  before_filter :load_donation
  before_filter :update_donation_from_widget_params
  before_filter :login_required, :except => [:donate]
  
  # Filter order is important here...
  before_filter :set_context_user
          
  include WmErrorsHandler

  # The origin for handling all donation requests and processing direct payments.
  def donate

    @context_user = @receiver.user
    
    # Test that the transfer money between the two people is a viable option
    rec_acc = @receiver.monetary_processor_account
    pay_acc = @sender.monetary_processor_account
    
    rec_usid = rec_acc.account_identifier
    pay_usid = pay_acc.account_identifier
    
    @donation.update_attributes do |d|
      d.receiver_wmid = rec_acc
      d.sender_wmid = pay_acc
    end
    store_donation
    
    res = WebMoney::Ext::Client.get_max_transaction_amount(pay_usid, rec_usid, @donation.purse_type[0].to_i)
  
    # Verify maximum transaction possible
    @max_amount = res.maxAmount
    if @max_amount < @amount.to_f
      @amount = @max_amount
      if @amount.to_i != -1
        flash.now[:warning] = "The maximum that you can contribute is %s." / "#{@amount}"
      end
    end
    
    # We are confirmed, lets do it!
    if params[:confirm]
      
      # confirm their password
      @account_setting = current_user.account_setting
      unless @account_setting.validate_password(current_user,params[:password])
        flash.now[:error] = "Invalid Password".t
        return
      end
          
      # want to see the result logged for debugging?
      # WebMoney::Ext::Client.config.merge!({:debug => true, :wiredump => true})
      transfer = WebMoneyTransfer.create(
        :source_wmid => @sender.webmoney_account,
        :destination_wmid => @receiver.webmoney_account,
        :purse_type => @donation.purse_type[0].to_i,
        :amount => @donation.amount)
    
      res = WebMoney::Ext::Client.send_funds(
        pay_usid,
        rec_usid,
        transfer.request_number,
        @donation.purse_type[0].to_i,
        @donation.amount,
        @donation.item_name)
    
      if res.errordesc == 'Success'
        MonetaryDonation.from_webmoney_donation(@donation).save
        
        transfer.update_attribute(:success, true)
        flash[:success] = "You have successfully transfered %s" / [@donation.amount]
        clear_donation
        redirect_back_or_default '/'
      else
        transfer.update_attributes(:success => false, :response => res.errordesc)
        flash.now[:error] = res.errordesc.t
      end
    end
  end
      
  protected

  # The params from the donation widget are generally for passing to WM directly.
  # This cleans them up and puts them in the donation object for simple reading and handling.
  def update_donation_from_widget_params
    @donation.update_attributes do |d|
      d.account_setting_id = params[:as_id] if params[:as_id]
      d.sender_wmid        = params[:donation][:sender_wmid] if params[:donation] && params[:donation][:sender_wmid]
      d.receiver_wmid      = AccountSetting.find_by_id(params[:as_id]).webmoney_account if params[:as_id]
      d.content_id         = params[:content_id] if params[:content_id]
      d.item_name          = params[:item_name] if params[:item_name]
      d.user_id            = current_user.id #params[:user_id] if params[:user_id]
      d.amount             = params[:LMI_PAYMENT_AMOUNT] if params[:LMI_PAYMENT_AMOUNT]
      d.amount             = params[:donation][:amount] if params[:donation] && params[:donation][:amount]
      d.purse_type         = params[:LMI_PAYEE_PURSE][0].chr if params[:LMI_PAYEE_PURSE]
      d.invoice_confirmed ||= false
      d.days               = 7 # 1 week for invoice by default
    end
    store_donation

    @skip_invoice   = @donation.account_setting_id.blank? # display invoice option button?
    @sender         = current_user.account_setting # sender is always the user logged in as.
    @receiver       = AccountSetting.find_by_id(@donation.account_setting_id)
    @receiving_user = @receiver.user if @receiver
  end  
end
