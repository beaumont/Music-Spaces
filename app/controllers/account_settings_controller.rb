class AccountSettingsController < ApplicationController
  helper :account
  before_filter :login_required
  before_filter :grab_account

  def index
    # this should render the page that is currently rendered by the "profile" tab
  end
 
  def invoice_agreement
    if request.post?
      if params[:invoice_agreement_accepted] == '1'
        @user.account_setting.invoice_agreement_accepted!
        flash[:success] = "Thank you!  Please attach your preferred payment system to start receiving contributions!".t
      end
      #wizard hook
      redirect_to(:controller => 'wizard',
                  :action => 'attach_money',
                  :id => @user.id) and return if params[:is_for_wizard]
                
      redirect_to :controller => 'money', :action => "index", :id => @user.id
    end
    render :layout => 'jquery_dialog' unless performed?
  end

  # Actually save changes
  def update
    @account_setting.approve_donations! unless @account_setting.money_approved?
    @account_setting.attributes = params[:account_setting]
    @account_setting.validate_password(current_user,params[:password])
    if params[:commit] && params[:commit] == 'disconnect_paypal'
      if @account_setting.clear_paypal!
        flash[:warning] = "Your PayPal account has been removed".t
        redirect_to :controller => 'money', :action => 'index', :id => @user.id and return
      else
        flash[:warning] = "Error disconnecting your PayPal account".t
      end
    end
    if @account_setting.save
      redirect_to :controller => 'money', :action => :index, :id => @account_setting.user_id
    else
      flash[:warning] = "Error updating settings".t + ": " + @account_setting.errors.full_messages.join("; ") 
      return_to = params[:return_action] || :donation_basket
      render :action => return_to, :id => params[:id]
    end
  end

  # Get account_setting/general
  def general
  end
  
  # Get account_setting/donation_basket
  def donation_basket
    @content_kind_displayname = "Contribution Settings".t
    @account_setting.set_defaults
    respond_to do |wants|
      wants.html { redirect_to :controller => :user, :id => @account_setting.user_id unless @account_setting.money_approved? }
      wants.js {}
    end
  end
  
  # Get account_setting/livejournal
  def livejournal
  end
  
      
  protected
  
  def grab_account
    # Allow passing in manually, as long as only passing current actor or a project belonging to current actor
    @user = User.find_by_id(params[:id])
    @user ||= current_actor
    raise Kroogi::NotPermitted unless current_user.is_self_or_owner?(@user)
    
    @account_setting = @user.account_setting
    @return_url = url_for(:controller => "money", :action => 'index', :id => @user)
  end
end
