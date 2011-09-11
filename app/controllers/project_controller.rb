class ProjectController < ApplicationController
  before_filter :login_required
  before_filter :load_project, :except => [:overview, :create]

  def overview
    unless params[:id].blank?
      if current_user.projects.detect { |project| project.id.to_s == params[:id] }
        current_user.update_attribute(:on_behalf_id, params[:id].to_i)
      end
    end
    @user = current_user
    @tab_title = current_actor.project? ? 'Project Overview'.t : 'My Projects'.t
  end

  def create
    @tab_title = 'Create Kroogi Project'.t
    if current_actor.project?
      flash[:warning] = 'Sorry, projects cannot create other projects'.t
      redirect_to userpage_path(current_actor) and return
    end

    if params[:user_type] == 'collection' && !current_user.admin?
      flash[:warning] = 'Collection projects can only be created by Administrators'.t
      redirect_to userpage_path(current_actor) and return
    end

    params[:profile_name_ids] = params[:profile_name_ids].nil? ? Array.new : params[:profile_name_ids].collect{|p| p.to_i}
    @project = (params[:user_type] == 'collection' ? CollectionProject : Project).new(params[:project])
    @project.account_setting = AccountSetting.new(params[:account_setting])
    return unless (request.post? && params[:project])

    @project.init_on_creation(current_user, params)
    flash[:success] = "Your project has been created.".t

    redirect_to :controller => 'wizard', :action => 'basic_info_project'
    
  rescue ActiveRecord::RecordInvalid 
    flash[:error] = "Failed to create the project".t
    logger.info "Something happened [#{$!.class.name}] #{$1.to_s}"
  end
  
  def wizard_circles
    unless request.post?
      # TODO: set custom circle names here?
      @kroogs = case @type
      when 'supporting'
        @project.all_circles.each do |x|
          x.name = 'Honorary Members'.t if x.circle_id == Relationshiptype::TYPES[:family]
        end
      else
        @project.all_circles.each {|x| x.update_attribute(:is_paid, 0) if x.is_paid?}
      end
    else
      do_save_kroogi_settings

      flash[:success] = "Circle settings saved".t
      redirect_to userpage_path(@project)
    end
  end
  
  protected

  def do_save_account_settings
    # TODO:security ENSURE PROJECT CAN'T BYPASS KROOGI ACCEPANCE by modifying e.g. a state field
    @account_setting.attributes = params[:account_setting]
    @account_setting.password_validated = true
    @account_setting.request_donations! unless ( @account_setting.paypal_email == "" &&
                                                 @account_setting.webmoney_wmz == "" &&
                                                 @account_setting.webmoney_wme == "" &&
                                                 @account_setting.webmoney_wmr == "" )
     @account_setting.save
  end
    
  def load_project
    @user = Project.find(params[:id])
    @project = @user
    unless @project.project?
      redirect_to(:controller => 'wizard', :action => 'add_avatar') and return
    end
    @type = params[:type] || params[:user_type]
    @type = 'none' unless %w(creating organizing supporting providing collection).include?(@type)
    raise Kroogi::NotPermitted unless @user && current_user.is_self_or_owner?(@user)
  end
end
