class Admin::NotificationsController < Admin::BaseController

  skip_before_filter :admin_required, :only => :unsubscribe

  def index
    @notifications = UserChangeNotificationToRealtime.active.by_login(params[:q]).paginate :per_page => setpagesize,
      :page => params[:page],  :include => [:user]

    set_paging_header(@notifications, :entity_name => 'users')
  end

  def deleted
    @notifications = UserChangeNotificationToRealtime.deleted.by_login(params[:q]).paginate :per_page => setpagesize,
      :page => params[:page],  :include => [:user]

    set_paging_header(@notifications, :entity_name => 'users')
    render :action => :index
  end

  def destroy
    @notification = UserChangeNotificationToRealtime.find_by_id(params[:id])
    @notification.update_attribute(:deleted, true) if @notification
    redirect_to admin_notifications_path(:q => params[:q])
  end

  def restore
    @notification = UserChangeNotificationToRealtime.find_by_id(params[:id])
    @notification.update_attribute(:deleted, false) if @notification && !@notification.token.blank?
    redirect_to deleted_admin_notifications_path(:q => params[:q])
  end

  def unsubscribe
    @notification = UserChangeNotificationToRealtime.find_by_user_id_and_token(params[:user_id], params[:token])
    raise Kroogi::NotPermitted if @notification.blank?

    @notification.update_attributes(:deleted => true, :token => nil)
    flash[:success] = "Thank you. Your email notifications settings will not be change.".t
    redirect_to url_for(:host => user_host(@notification.user), :controller => '/')
  end

end