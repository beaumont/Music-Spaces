class Admin::UsersController < Admin::BaseController
    
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update, :activate ],
         :redirect_to => { :action => :list }

  def list
    select, joins, conditions = fill_conditions

    @users = User.paginate({
      :joins => joins,
      :select => select,
      :order => 'users.id desc',
      :per_page => setpagesize, :page => params[:page]}.merge(conditions))

    @questions_kits = YAML.load_file(File.join(Rails.root, "config", "public_questions.yml")).select {|k| k[:enabled]}

    set_paging_header(@users, :entity_name => 'user')
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def new
    prepare_edit
    @user = BasicUser.new
    @user.role_ids = [Role::USER]
  end

  def create
    @user = BasicUser.new(params[:user])
    @user.profile = Profile.new
    @user.preference = Preference.new
    if @user.save
      flash[:success] = 'User was successfully created.'.t
      redirect_to :action => 'list'
    else
    prepare_edit
      render :action => 'new'
    end
  end

  def edit
    logger.info "Locale:" + Locale.inspect
    @user = User.find(params[:id])
    prepare_edit
    logger.info "All Roles:" + @all_roles.inspect
  end

  def update
    @user = User.find(params[:id], :include => :account_setting)
    @account_setting = @user.account_setting
    user_params = params[:user]
    password_changed = !user_params[:password].blank? || !user_params[:crypted_password].blank?
    if user_params[:crypted_password].blank?
      user_params.delete(:crypted_password)
    else
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end
    hash = @user.crypted_password
    @account_setting.update_attribute(:webmoney_passport_minimum, params[:wm_passport])
    @account_setting.update_attributes(params[:account_setting])
    @user.skip_password_check = true
    @user.update_question_interval_settings(params[:rare_settings][:questions_interval], params[:rare_settings][:questions_interval_random_delta]) if params[:rare_settings]
    if @user.update_attributes(user_params)
      @user.profile.update_attributes(params[:profile])
      @user.update_questions_kit(params[:rare_settings][:questions_kit_id]) if params[:rare_settings] && params[:rare_settings][:questions_kit_id]
      if password_changed
        flash[:notice] =
          "User's password was changed. Please remember old crypted password (%s) if you consider reverting it back later." / hash
      end
      @user.invalidate_roles_cache #TODO: need to spec this
      flash[:success] = 'User was successfully updated.'.t
      redirect_to :action => 'show', :id => @user
    else
      prepare_edit
      render :action => 'edit'
    end
  end
  
  def destroy
    user = User.find(params[:id])
    flash[:success] = "Deleted #{user.login}"
    user.delete!
    redirect_to :action => 'list'
  end

  def activate
    @user = User.find(params[:id])    
    render :status => :precondition_failed if !@user.activate
  end
  
  def allow_donations
    @user = User.find(params[:id])
    @account = DummyMonetaryAccount.create(:account_setting => @user.account_setting)
    @account.destroy
    flash[:notice] = "Account is now able to receive donations".t
    redirect_to :action => :edit, :id => @user.id
  end

  def remove_verification
    as = AccountSetting.find(params[:id])
    log.debug "as.verified_by_kroogi = %s" % as.verified_by_kroogi
    as.verified_by_kroogi = false
    as.save!
    render :text => 'ok', :layout => false
  end

  def verify
    as = AccountSetting.find(params[:id])
    log.debug "as.verified_by_kroogi = %s" % as.verified_by_kroogi
    as.verified_by_kroogi = true
    as.save!
    render :text => 'ok', :layout => false
  end
  
  def karma
    @user = User.find_by_id(params[:id]) #optional user id
    conditions = @user ? {:conditions => {:referrer_id => @user.id}} : {}
    
    @karma_points = KarmaPoint.paginate({
                      :include  => [:referrer, :content, :monetary_donation],
                      :order    => 'karma_points.created_at DESC',
                      :per_page => setpagesize, 
                      :page     => params[:page]}.merge(conditions))

  end

  def toggle_questions
    u = User.find(params[:id])
    u.toggle_rare_setting!(:questions_enabled)
    render :text => (u.questions_enabled? ? "Disable Q&A".t : "Enable Q&A".t)
  end

  def toggle_guest_commenting
    u = User.find(params[:id])
    u.toggle_rare_setting!(:allows_guest_comments)
    render :text => toggle_guest_commenting_caption(u)
  end

  def toggle_fwd_tos_allowed
    u = User.find(params[:id])
    u.toggle_rare_setting!(:fwd_tos_allowed)
    render :text => toggle_fwd_tos_allowed_caption(u)
  end

  def tps_setup_toggle
    user = User.find_by_id params[:id]
    user.toggle_rare_setting!(:tps_setup_enabled)
    render :text => user.tps_setup_enabled? ? "Disable" : "Enable"
  end

  protected

  def toggle_guest_commenting_caption(user)
    (user.allows_guest_comments? ? "Disallow guest comments".t : "Allow guest comments".t)
  end
  helper_method :toggle_guest_commenting_caption

  def toggle_fwd_tos_allowed_caption(user)
    (user.fwd_tos_allowed? ? "Disallow specifying Terms of Service".t : "Allow specifying Terms of Service".t)
  end
  helper_method :toggle_fwd_tos_allowed_caption

  def find_all_roles
    return Role.find(:all, :conditions => "status = 1", :limit => 100)
  end
  
  def prepare_edit
    @all_roles = find_all_roles
    @account_setting ||= @user.account_setting if @user
    @questions_kits = YAML.load_file(File.join(Rails.root, "config", "public_questions.yml")).select {|k| k[:enabled]}
  end

  def fill_conditions
    conditions = {}
    query_parts = []
    values = []
    unless params[:name].blank?
      query_parts << '(login like ? or display_name like ? or email like ?)'
      like = ("%#{params[:name]}%")
      values += [like, like, like]
    end
    unless params[:role].blank?
      query_parts << 'ru.role_id = ?'
      @role_filter = params[:role].to_i
      values << @role_filter
    end
    unless params[:verified_by_kroogi].blank?
      query_parts << 'account_setting.verified_by_kroogi=?'
      values << (params[:verified_by_kroogi] == 'no' ? false : true)
    end
    unless params[:with_questions_kit].blank?
      query_parts << 'rus.questions_kit_id is NOT NULL'
    end
    unless params[:tps_setup_enabled].blank?
      query_parts << 'rus.tps_setup_enabled = ?'
      values << true
    end
    unless query_parts.blank?
      conditions = {:conditions => [query_parts.join(' AND ')] + values}
    end

    joins = ""
    joins += "left join roles_users ru on users.id = ru.user_id " unless params[:role].blank?
    joins += "left join account_settings account_setting on users.id = account_setting.user_id" unless params[:verified_by_kroogi].blank?
    joins += "left join rare_user_settings AS rus on users.id = rus.user_id" unless params[:with_questions_kit].blank? && params[:tps_setup_enabled].blank?


    select = joins.blank? ? 'users.*' : 'distinct users.*'

    return select, joins, conditions
  end

end
