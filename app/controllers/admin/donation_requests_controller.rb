class Admin::DonationRequestsController < Admin::BaseController
  
  def index
    params[:type] ||= 'any'
    conditions = {}
    case params[:type].to_sym
    when :any
    when :processing, :unverified, :verified, :rejected, :removed
      conditions = {:state => params[:type]}
    end
    unless params[:login].blank?
      conditions.merge!('users.login' => params[:login])
    end
    @accounts = MonetaryProcessorAccount.paginate_with_users(:order => "users.login ASC", :conditions => conditions, :page => params[:page], :per_page => setpagesize)
  end
  
  def reject
    @acc = MonetaryProcessorAccount.find_by_id(params[:id])
    @acc.reject!
    if @acc.rejected?
      flash[:notice] = "Account has been rejected".t
    else
      flash[:error] = "Unable to transition to rejected from current state.".t
    end
    redirect_to :action => :index
  end
  
  def verify
    @acc = MonetaryProcessorAccount.find_by_id(params[:id])
    @acc.verify!
    if @acc.verified?
      flash[:notice] = "Account has been verified".t
    else
      flash[:error] = "Unable to transition to verified from current state.".t
    end
    redirect_to :action => :index
  end
  
  # 
  # def verify_paypal
  #   if request.put?
  #     ac = PaypalAccount.find(params[:id])
  #     ac.verify!
  #     flash[:success] = "PayPal Account (%s) has been verified." / [ac.account_identifier]
  #   end
  #   respond_to do |wants|
  #     wants.html { redirect_to({:controller => 'admin/donation_requests', :action => :index, :type => 'all_paypal'}) }
  #     wants.js { render :text => ac.state }
  #   end
  # end
  # 
  # def reject_paypal
  #   if request.put?
  #     ac = PaypalAccount.find(params[:id])
  #     ac.skip_password_verification_on_paypal_email = true
  #     ac.reject
  #     flash[:warning] = "PayPal Account (%s) has been rejected." / [ac.account_identifier]
  #   end
  #   respond_to do |wants|
  #     wants.html { redirect_to({:controller => 'admin/donation_requests', :action => :index, :type => 'all_paypal'}) }
  #     wants.js { render :text => ac.state }
  #   end
  # end
  # 
  # def verify
  #   if request.put?
  #     flash[:success] = "Account has been verified.".t
  #     basket = AccountSetting.find(params[:id])
  #     basket.update_attribute(:verified_by_kroogi, true)
  #   end
  #   respond_to do |wants|
  #     wants.html { redirect_to :action => :index }
  #     wants.js { render :text => "User Verified!".t }
  #   end
  # end
  # 
  # def remove_verification
  #   if request.put?
  #     flash[:success] = "Account has been un-verified.".t
  #     basket = AccountSetting.find(params[:id])
  #     basket.update_attribute(:verified_by_kroogi, false)
  #   end
  #   respond_to do |wants|
  #     wants.html { redirect_to :action => :index }
  #     wants.js { render :text => "User Verification Removed!".t }
  #   end
  # end
  # 
  # 
  # def allow_yandex
  #   basket = AccountSetting.find(params[:id])
  #   basket.toggle!(:allow_yandex)
  #   respond_to do |wants|
  #     wants.html { redirect_to :action => :index }
  #     wants.js { render :text => (basket.allow_yandex? ? "Disable Yandex".t : "Allow Yandex".t) }
  #   end
  # end
  # 
  # def bulk_approve
  #   if request.put?
  #     flash[:success] = "All pending request to receive money on Kroogi has been accepted".t
  #     basket = AccountSetting.money_pending.each{|a| a.approve_donations! }
  #   end
  #   respond_to do |wants|
  #     wants.html { redirect_to :action => :index }
  #   end
  # end
  # 
  # def approve
  #   if request.put?
  #     flash[:success] = "User's request to receive money on Kroogi has been accepted".t
  #     basket = AccountSetting.find(params[:id])
  #     basket.approve_donations!
  #   end
  #   respond_to do |wants|
  #     wants.html { redirect_to :action => :index }
  #     wants.js
  #   end
  # end
  # 
  # def deny
  #   if request.put?
  #     flash[:warning] = "User's request to receive money on Kroogi has been rejected".t
  #     basket = AccountSetting.find(params[:id])
  #     basket.deny_donations!
  #   end
  #   respond_to do |wants|
  #     wants.html { redirect_to :action => :index }
  #     wants.js { render :text => "User Contributions Denied!".t }
  #   end
  # end
  # 
  # # If you'd like to let a user request money again sometime later
  # def undeny
  #   if request.put?
  #     flash[:success] = "Denied user's money status has been reset to 'not requested'".t
  #     basket = AccountSetting.find(params[:id])
  #     basket.money_not_requested!
  #   end
  #   respond_to do |wants|
  #     wants.html { redirect_to :action => :index }
  #     wants.js { render :text => "User Contributions Reset to Not Requested!".t }
  #   end
  # end

end
