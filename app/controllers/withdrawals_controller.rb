class WithdrawalsController < ApplicationController
  before_filter :login_required
  before_filter :require_same_user, :only => :create
  before_filter :load_user
  
  
  # Generates a withdrawal request based on the amt and id (current_actor)
  def create
    w = current_actor.account_setting.monetary_withdrawals.new(:gross_amount => params[:amt],
                                                               :currency => 'USD',
                                                               :receiver => current_actor.account_setting,
                                                               :monetary_processor_account => current_actor.account_setting.current_monetary_processor_account,
                                                               :monetary_processor_id => params[:mp])
    if !w.valid?
      flash[:error] = "Unable to complete withdrawal. Invalid withdrawal amount".t
      redirect_to money_path(current_actor) and return
    end
    begin
      w.process_transaction!
      flash[:success] = "Your withdrawal is been processed. Please allow a few minutes for the transfer to complete.".t 
      redirect_to money_path(current_actor) and return
    rescue Kroogi::Money::ProcessorInternalError => e
      AdminNotifier.async_deliver_admin_alert("[Withdrawal] %s" % e.inspect)
      flash[:error] = e.user_explanation
      redirect_to money_path(current_actor) and return
    rescue StandardError => e
      AdminNotifier.async_deliver_admin_alert("[Withdrawal] %s" % e.inspect)
      flash[:error] = "We are unable to complete your withdrawal at this time. Please try again later, or contact us if the issue remains.".t 
      redirect_to money_path(current_actor) and return
    end
  end
  
  protected
  
  # only allow if users match
  def require_same_user
    if params[:id].to_i != current_actor.id
      flash[:error] = "Unable to complete withdrawal. Invalid user.".t
      redirect_to money_path(current_actor) and return
    end
  end
  
end
