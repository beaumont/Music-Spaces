class Admin::RolesController < Admin::BaseController
  
  def index
    list
    render :action => 'list'
  end

  def list
    @roles = Role.paginate :per_page => 10, :page => params[:page]
  end

  def show
    @role = Role.find(params[:id])
  end

end
