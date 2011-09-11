module Admin
  class MoneyController < Admin::BaseController

    def temporarily_disabled
      flash[:warning] = 'The feature you requested is not yet complete.  It will be made available as soon as it is stable'.t
      redirect_to :controller => 'admin/monitor', :action => 'index'
    end

    def index
      query
    end
    
    # provides API results for historical data by USID (account_setting_id)
    # if the login is 'kroogi', then we do not pass the usid, as kroogi is the usid.
    def webmoney
      @show_date_select = true
      
      # range caluclations (start/end of dates)
      @start_date = DateTime.parse(params[:start_date]).to_time if !params[:start_date].blank?
      @start_date ||= 30.days.ago.beginning_of_day
      @end_date   = DateTime.parse(params[:end_date]).to_time if !params[:end_date].blank?
      @end_date   = @end_date.end_of_day if @end_date
      @end_date   ||= Time.now.end_of_day
      
      
      # which user do we want? (kroogi by default)
      @login = params[:login] || Kroogi::KROOGI_ACCOUNT
      if @login == Kroogi::KROOGI_ACCOUNT
        @usid = WebMoneyAccount.account_identifier(Kroogi::KROOGI_ACCOUNT)
      else
        @user = User.find_by_login(params[:login])
        return unless @user
        account = @user.account_setting.current_monetary_processor_account
        account ||= @user.account_setting.all_monetary_processor_accounts.webmoney.first
        return unless account
        @usid = account.account_identifier
      end

      @query = WebMoney::Ext::Client::get_history(@usid, @start_date, @end_date)
      if @query.getHistoryResult != 0
        flash.now[:error] = @query.errordesc
      else
        @transactions = @query.history
      end
    end

    def do_csv(finder_params)
      timestamp = Time.now.strftime('%y%m%d_%H%M%S')
      lines = []
      lines << ['Date/Time'.t, 'From'.t, 'To'.t, 'Purpose'.t,
        'Transaction'.t, 'Payment type'.t, 'Currency'.t,
        'Amount transferred'.t, 'Amount received'.t, 'Fee'.t]
      @contributions = []
      MonetaryDonation.paginated_each(finder_params) do |contrib|
        @contributions << contrib
        line = []
        line << contrib.created_at.to_s(:db)
        line << (contrib.sender ? contrib.sender.user.login : nil)
        line << (contrib.receiver ? contrib.receiver.user.login : nil)
        line << contrib.item_name
        line << contrib.token
        line << contrib.processor_name
        line << contrib.gross_amount_usd
        line << contrib.payable_amount_usd
        line << contrib.handling_fee_usd
        lines << line
      end

      send_data lines.map {|line | line.join("\t")}.join("\n"),
        :filename => "queried_contributions_%s.csv" % timestamp
    end

    def fill_totals(conditions)
      contribs = MonetaryDonation.find(:all,
        :select => 'sum(gross_amount_usd) gross_amount_usd, ' +
          'sum(payable_amount_usd) payable_amount_usd, ' +
          'ifnull(sum(handling_fee_usd), 0) handling_fee_usd, ' +
          'ifnull(sum(monetary_processor_fee_usd), 0) monetary_processor_fee_usd' ,
        :conditions => conditions)

      @total = contribs[0]
    end
    
    def do_html(finder_params)
      unless @query.errors.blank?
        flash[:error] = @query.errors.join(";<br/>") 
      end
      @contributions = MonetaryDonation.paginate finder_params.merge(
        :per_page => setpagesize, :page => params[:page])
      @show_date_select = true
      set_paging_header @contributions, :entity_name => 'contribution'
      fill_totals finder_params[:conditions]
      
      render :action => :index
    end

    def query
      @query = MoneyReportQuery.new(params[:query])

      finder_params = {:order => 'created_at desc, id desc',
        :conditions => @query.conditions}
      
      respond_to do |format|
        format.html do
          do_html(finder_params)
        end
        format.csv do
          do_csv(finder_params)
        end
      end
    end
    
    def balance
      @tab = :money
      @account = User.find_by_login(params[:user]).account_setting
      @pending_balance = @account.received_donations_pending_sum
      @available_balance = @account.balance_usd
      @transactions = @account.monetary_transactions.paginate(:page => params[:page], :per_page => setpagesize)
    end
    
    # Applies all donations to the users balance regardless of state or suspicion
    def force_apply_to_balance
      @account = AccountSetting.find(params[:account_id])
      @account.donations_received.pending.each{|d| d.apply_to_balance!(forced=true) }
      flash[:notice] = "All contributions have been applied to the users available balance.".t
      redirect_to :action => :balance, :user => @account.user.login
    end
    
    def update_waiting_period
      AccountSetting.default_withdrawal_waiting_period = params[:waiting_period]
      flash[:notice] = "Pending period has been changed for all pending donations with default availability.".t
      redirect_to :action => :index
    end
    
  end
end
