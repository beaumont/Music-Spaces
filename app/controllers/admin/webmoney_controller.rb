class Admin::WebmoneyController < Admin::BaseController
  
  def index
    @accounts = AccountSetting.money_approved.paginate(:all, 
                  :conditions => ["monetary_processor_accounts.monetary_processor_id = 2"],
                  :include => [:user, :monetary_processor_accounts],
                  :order => "users.login ASC",
                  :page => params[:page],
                  :per_page => params[:per_page] || 50)
  end
  
end