class Admin::SiteActivityLogsController < Admin::BaseController

  before_filter :configs, :only => [:index, :update]

  def index
    @logs = SiteActivityLog.paginate :per_page => setpagesize, :page => params[:page],
      :include => [:user, :actor, :admin_flash], :order => 'created_at DESC'
    @users = SiteActivityLogUser.all
    set_paging_header(@logs, :entity_name => 'entries')
  end
  
  def update
    @log_configs.update_attributes(params[:log_configs])
    self.log_configs = @log_configs.reload
    redirect_to admin_site_activity_logs_path
  end

  def create
    user = User.find_by_login params[:user_login]
    
    unless user.blank?
      a_user = SiteActivityLogUser.find_by_user_id user.id
      if a_user.blank?
        SiteActivityLogUser.create(:user_id => user.id, :login => user.login)
        @users = self.log_users = SiteActivityLogUser.all
        render :update do |page|
          page.replace_html "add_user_form_errors", ''
          page.replace_html "users_list", activity_log_users_list(@users)
          page.call "ActivityLog.close_dialog"
          page.call "ActivityLog.clear_form"
          page.call "ActivityLog.user_hover"
        end
      else
        render :update do |page|
          page.replace_html "add_user_form_errors", 'User already exists'.t
          page.call "ActivityLog.clear_form"
        end
      end
    else
      render :update do |page|
        page.replace_html "add_user_form_errors", 'User not found'.t
        page.call "ActivityLog.clear_form"
      end
    end
  end

  def destroy
    user = SiteActivityLogUser.find_by_id params[:id]
    user.destroy unless user.blank?
    @users = self.log_users = SiteActivityLogUser.all
    render :update do |page|
      page.replace_html "users_list", activity_log_users_list(@users)
      page.call "ActivityLog.user_hover"
    end
  end

  def browsers
    @browsers = SiteActivityLog.browsers
    @total = @browsers.sum {|b| b[:total]}
  end

  def platforms
    @platforms = SiteActivityLog.platforms
    @total = @platforms.sum {|p| p[:total]}
  end

  def robots
    @robots = SiteActivityLog.robots
    @total = @robots.sum {|p| p[:total]}
  end

  def search_terms
    @search_terms = SiteActivityLog.search_terms
    @total = @search_terms.sum {|p| p[:total]}
  end

  private

  def configs
    @log_configs = log_configs
  end

end