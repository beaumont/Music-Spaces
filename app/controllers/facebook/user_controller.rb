class Facebook::UserController < Facebook::ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :ensure_authenticated_to_facebook, :only => [:tab]

  def index
    if request.xhr?
      @page = params[:page].empty? ? 1 : params[:page].to_i
      @page += 1
      @activities = current_fb_user.fb_activities(:page => @page, :per_page => 10, :cumulative => true)
      render :partial => 'user_activities', :layout=>false
    else
      @activities = current_fb_user.fb_activities(:per_page => 10)
    end
    if @activities.empty?
      flash[:notice] = 'Sorry no matches.'
    end
  end
  
  def received
    if request.xhr?
      @page = params[:page].empty? ? 1 : params[:page].to_i
      @page += 1
      @activities = current_fb_user.content_invites_receveived(:page => @page, :per_page => 10, :cumulative => true)
      render :partial => 'sent_by_friends', :layout=>false
    else
      @activities = current_fb_user.content_invites_receveived(:per_page => 10)
    end
    if @activities.empty?
      flash[:notice] = 'Sorry no matches.'
    end
  end

  def friend_albums_list
    @friend = Facebook::User.find_by_fb_user(params[:id])
    @activities = []
    
    unless @friend.nil?
      if request.xhr?
        @page = params[:page].empty? ? 1 : params[:page].to_i
        @page += 1
        @activities = Facebook::User.fb_friend_activities(:friend => @friend,:page => @page, :per_page => 10, :cumulative => true)
        render :partial => 'friend_activities', :layout=>false
      else
        @activities = Facebook::User.fb_friend_activities(:friend => @friend,:per_page => 10)
      end
    end
    
    if @activities.empty?
      flash[:notice] = 'Sorry no matches.'
    end
  end

end