class Facebook::TabController < Facebook::ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :ensure_authenticated_to_facebook, :only => [:tab]

  verify :only => [:search, :confirm_form, :link_artist_to_profile, :remove],
         :xhr  => true,
         :redirect_to => :index

  def tab
    @user = Facebook::Page.find_by_fb_page(params[:fb_sig_page_id])

    if @user and @user.is_linked_to_artist? #Page Admin has linked a Kroogi Artist
      load_artist_content
      @partial = "contents"
      render :action => "tab/promote/index", :layout => 'facebook/tab_for_pages'
    else
      if viewer_is_page_admin?
        render :partial => 'facebook/tab/promote/search_form', :layout => 'facebook/tab_for_pages'
      else
        render :text => "Sorry, Page Admin did not attached any Kroogi Artist yet.", :layout=>false
      end
    end
   
  end

  def search
    if request.xhr?
      term = params[:display_name]
      if term.blank?
        render :partial => 'facebook/tab/promote/search_error', :layout=>false, :locals => {:text => 'Please enter an Artist name'}
        return
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

      unless projects_result.empty?
        render :partial => 'facebook/tab/promote/search_result', :layout=>false
      else
        render :partial => 'facebook/tab/promote/search_error', :layout=>false, :locals => {:text => 'user not found'}
      end
    end
  end

  def confirm_form
    @user = User.find_by_id(params[:id])
    render :partial => 'facebook/tab/promote/confirm_form', :layout=>false
  end

  def link_artist_to_profile
    @artist = User.find_by_id(params[:id])
    if params[:fb_sig_page_id]
      @user = Facebook::Page.find_or_create(params[:fb_sig_page_id], nil)
    else
      @user = Facebook::User.find_or_create(params[:fb_sig_user], nil)
    end
    @user.details.update_attribute(:linked_artist_id, @artist.id)
    @user.details.update_attribute(:header_text, params[:header_text])

    @profile = @artist.profile
    @contents = @artist.contents.music_albums.select{|ma| ma.qualify_for_fb}
    @partial = "contents"
    render :partial => 'facebook/tab/promote/contents', :layout=>false
  end

  def remove
    if params[:fb_sig_page_id]
      user = Facebook::Page.find_or_create(params[:fb_sig_page_id], nil)
    else
      user = Facebook::User.find_or_create(params[:fb_sig_user], nil)
    end
    if user
      user.details.update_attribute(:linked_artist_id, nil)
      user.details.update_attribute(:header_text, nil)
    end
    render :partial => 'facebook/tab/promote/search_form', :layout => false
  end

  private
  def load_artist_content
    @artist = User.find_by_id(@user.linked_artist_id)
    @profile = @artist.profile
    @contents = @artist.contents.music_albums.select{|ma| ma.qualify_for_fb}
  end

end