class Facebook::ProjectController < Facebook::ApplicationController
  skip_before_filter :ensure_authenticated_to_facebook, :only => [:show]

  def show
      @user = User.find(params[:id])
      @profile = @user.profile
      @music_albums = @user.contents.music_albums.select{|ma| ma.qualify_for_fb}
  end
end
