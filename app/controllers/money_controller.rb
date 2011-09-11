class MoneyController < ApplicationController
  before_filter :login_required
  before_filter :load_user
  before_filter :grab_account, :only => [:donations_received, :donations_made, :monetary_withdrawals]
  before_filter :grab_protected_account, :only => :index
  skip_before_filter :verify_authenticity_token, :only => :index  

  def index
    session[:wm_donation] = nil
    store_location
    @tab = :money
    @donations_received = @account_setting.donations_received.all(:limit => 15)
    @donations_made = @account_setting.donations_made.all(:limit => 15)
    @monetary_withdrawals = @account_setting.monetary_withdrawals.paid(:limit => 15)
    @returning_from_wm = !params[:hash].blank?
    @truncate_to = 20
  end
  
  def donations_received
    money_report(action_name)
    render :action => 'received'
  end

  def donations_made
    money_report(action_name)
    render :action => 'received'
  end

  def monetary_withdrawals
    money_report(action_name)
    render :action => 'received'
  end
  
  def set_movable_broker_enabled
    account_setting = AccountSetting.find(params[:id])
    account_setting.movable_broker_enabled = (params[:val].downcase == 'true')
    account_setting.save
    
    redirect_to :controller => "money", :action => "index", :id => account_setting.user.id
  end

  protected

  def money_report(what)
    @tab = :money

    conditions = {}
    if !params[:content_id].blank?
      conditions.merge!(:content_id => params[:content_id])
    end
    @monetary_donations = @account_setting.received(what,
      params[:sort_by], params[:dir], conditions).
      paginate(:page => params[:page], :per_page => setpagesize)
    @since = @content.created_at if @content
    log.debug "what: %s, conditions: %s" % [what, conditions.inspect]
    @usd_sum = received_sum(@account_setting, what, conditions)
    set_paging_header @monetary_donations, :entity_name => 'donation'
  end

  def received_sum(as, what, conditions)
    return '' if what.nil?
    "%.2f" % as.delegate_received(what).sum(:payable_amount_usd, :conditions => conditions)
  end

  def grab_protected_account
    # Allow passing in manually, as long as only passing current actor or a project belonging to current actor
    @user = User.find_by_id(params[:id])
    @user ||= current_actor
    raise Kroogi::NotPermitted unless current_user.is_self_or_owner?(@user)
    
    @account_setting = @user.account_setting
    @return_url = url_for(:controller => "money", :action => 'index', :id => @user)
  end

  def grab_account
    @content = Content.find(params[:content_id]) unless params[:content_id].blank?
    @user = @content.user if @content
    return access_denied unless can_view_donations_for?(@user) || @user.nil?
    @account_setting = @user.account_setting
  end
  
end
