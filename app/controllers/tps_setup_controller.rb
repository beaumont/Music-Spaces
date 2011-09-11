class TpsSetupController < ApplicationController
  STEPS = %w(intro for_profile for_page for_goodies_page overview last_step)

  before_filter :allowed?
  before_filter :load_artist
  before_filter :content, :only => [:edit, :update, :destroy]
  before_filter :tsp_owner_only, :only => [:edit, :update, :destroy]
  before_filter :owner_only
  before_filter :tips
  before_filter :fix_dateformat, :only => [:update, :create]

  def new
    @tps_content = Tps::Content.new(:user_id => current_actor.id, :is_in_gallery => false, :is_in_startpage => false)
    redirect_to(:action => :edit, :id => @tps_content.id) and return unless @tps_content.new_record?
  end

  def create
    uploaded_data = params[:tps_content].delete(:uploaded_data)

    @tps_content = Tps::Content.new(params[:tps_content].merge(:user_id => current_actor.id, :is_in_gallery => false))
    if @tps_content.save
      upload_images(uploaded_data)
      @tps_content.assign_to_album(params[:content].delete(:album_id))
      flash[:success] = 'FundBox successfully created.'.t + ' ' + flash[:success].to_s
      redirect_to :action => :edit, :id => @tps_content.id
    else
      render :action => :new
    end
  end

  def edit
    @images = @tps_content.images
  end

  def update
    uploaded_data = params[:tps_content].delete(:uploaded_data)

    if @tps_content.update_attributes(params[:tps_content].merge(:user_id => current_actor.id, :is_in_gallery => false))
      upload_images(uploaded_data)
      @tps_content.assign_to_album(params[:content].delete(:album_id))
      flash[:success] = 'FundBox successfully updated.'.t + ' ' + flash[:success].to_s
      redirect_to :action => :edit, :id => @tps_content.id
    else
      edit
      render :action => :edit
    end
  end
  
  protected

  def allowed?
    raise Kroogi::NotPermitted unless current_actor.tps_setup_enabled?
  end

  def render_layout
    render :template => 'tps_setup/setup'
  end
  
  def load_artist
    @user = current_actor # User.find_by_login(user_subdomain) || 
  end

  def content
    raise Kroogi::NotPermitted if params[:id].blank?
    @tps_content = Tps::Content.find_by_id(params[:id])
  end

  def tsp_owner_only
    raise Kroogi::NotPermitted unless current_user.is_self_or_owner?(@tps_content.user)
  end

  def owner_only
    raise Kroogi::NotPermitted unless current_user.is_self_or_owner?(@user)
  end

  def tips
    action_tips = YAML.load_file(File.join(Rails.root, "config", "tps_setup_tips.yml"))[:tips][:tps_setup][action_name.to_sym]
    @tips = action_tips ? action_tips[I18n.locale.to_sym] : ''
  end

  def upload_images(uploaded_data)
    params = {:for_album => @tps_content.id, :ownership => 'me', :content => {:user_id => @tps_content.user_id, :owner => nil}}

    return if uploaded_data.blank?
    uploaded_data = uploaded_data.is_a?(Hash) ? uploaded_data.values : [uploaded_data]

    @uploaded = []
    upload_errors = []
    uploaded_data.each do |data|
      next if (data && data.size.zero?) and uploaded_data.size > 1
      begin
        return unless upload_image(data, params) == :continue
      rescue Errno::ETIMEDOUT, Errno::ECONNRESET
        upload_errors << amazon_timeout_message
      rescue ActiveRecord::RecordInvalid
        upload_errors << @image.errors.full_messages.join("<br/>")
      end
    end

    flash[:error] = upload_errors.join("<br/>") unless upload_errors.empty?
    unless @uploaded.empty?
      flash[:success] = "%d %s successfully uploaded" / [@uploaded.size, 'Images'.downcase.t]
    end
  end

  def upload_image(data, params)
    # Empty tempfile (only one file field has to be populated during multiple upload, so 0 size uploads are valid, but skipped)
    @image = Tps::Image.new(params[:content])
    @image.just_uploaded = true
    @image.uploaded_data = data
    @image.set_ownership_from_params(params[:ownership], params[:content][:owner])
    @image.is_in_gallery = false
    @image.is_in_startpage = false
    Content.transaction do
      @image.title ||= @image.filename
      @image.albums << @tps_content
      @image.relationshiptype_id = @tps_content.relationshiptype_id
      @image.save!
      @uploaded << @image
    end
    return :continue
  end

  def fix_dateformat
    end_date = params[:tps_content][:end_date]
    begin
      params[:tps_content][:end_date] = Date.strptime(end_date, I18n.t('date.formats.birthday')).to_s(:db) unless end_date.blank?
    rescue => e
      logger.debug("Problem with date format: #{e}")
    end
  end

end
