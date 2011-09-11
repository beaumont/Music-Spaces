class Facebook::SearchController < Facebook::ApplicationController
  skip_before_filter :ensure_authenticated_to_facebook
  protect_from_forgery :except =>[:albums, :artists]

  caches_action :albums,  :expires_in => 15.minutes, :cache_path => proc{|c| c.cache_key_with_locale(c.params[:filter], c.params[:page] || 1)}
  caches_action :artists, :expires_in => 15.minutes, :cache_path => proc{|c| c.cache_key_with_locale(c.params[:filter], c.params[:page] || 1)}
  
  def index
    term = params[:term]
    @music_albums = []
    @projects = []

   unless term.blank?
      music_albums_result = MusicAlbum.search(term, :retry_stale => true)
      unless music_albums_result.nil?
        filtered_albums = music_albums_result.select{|p| p.qualify_for_fb}
        @music_albums = WillPaginate::Collection.create params[:albums_page] || 1, 10,
          filtered_albums.size do |pager|
          pager.replace(filtered_albums)
          pager.total_entries = filtered_albums.count
        end
      end

      projects_result = User.search(term, :retry_stale => true)
      unless projects_result.nil?
        filtered_projects = projects_result.select{|p| p.qualify_for_fb}
        @projects = WillPaginate::Collection.create params[:projects_page] || 1, 10,
          filtered_projects.size do |pager|
          pager.replace(filtered_projects)
          pager.total_entries = filtered_projects.count
        end
      end

    end
    render :action  => "full_text/index"
  end

  def albums
    @entry = []
    if request.xhr?
      @page = params[:page].empty? ? 1 : params[:page].to_i
      @page += 1
      @entry = find_by_albums(@page)
      render :partial => 'albums', :layout=>false
    else
      @entry = find_by_albums(1)
    end
    if @entry.empty?
      flash[:notice] = 'Sorry no matches.'
    end
  end

  def artists
    @entry = []
    if request.xhr?
      @page = params[:page].empty? ? 1 : params[:page].to_i
      @page += 1
      @entry = find_by_projects(@page)
      render :partial => "artists", :layout=>false
    else
      @entry = find_by_projects(1)
    end
    if @entry.empty?
      flash[:notice] = 'Sorry no matches.'
    end
  end

  def from_invite
    @entry = find_by_albums(1)
    @partial = 'albums'
    if @entry.empty?
      flash[:notice] = 'Sorry no matches.'
    end
    render :action => "albums"
  end

  private
  def find_by_albums(page)
    MusicAlbum.facebook_albums(:page => page,
      :per_page => 10,
      :conditions=>params[:filter],
      :cumulative => true)
  end

  def find_by_projects(page)
    User.having_music_albums_with_bundle(:page => page,
      :filter=>params[:filter],
      :cumulative => true,
      :per_page => 10)
  end
  
end
