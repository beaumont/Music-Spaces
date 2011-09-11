class Facebook::HomeController < Facebook::ApplicationController
  protect_from_forgery :except => [:deauthorize]
  skip_before_filter :ensure_authenticated_to_facebook

  def index
    @popular_ma = MusicAlbum.facebook_albums(:page => 1, :per_page => 6)
    @newest_ma  = MusicAlbum.facebook_albums(:page => 1, :per_page => 6, :conditions=>'new')
    @projects   = find_projects
    unless current_fb_user.nil?
       @activities = current_fb_user.last_fb_activities(5)
       @friends_activities = current_fb_user.friends_activities
    end
  end

  def deauthorize
    user = Facebook::UserDetails.find_user(facebook_params[:user]) #facebook_params[:user] forces a signature verification
    user.mark_deleted! if user
    render :nothing => true
  rescue Facebooker::Session::IncorrectSignature => e
    just_notify(e)
    render :nothing => true
  end

  def artist_entrance
  end

  private
  def find_projects
    User.having_music_albums_with_bundle(:page => params[:page], :per_page => 3)
  end

end
