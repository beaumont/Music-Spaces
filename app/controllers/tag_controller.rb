class TagController < ApplicationController

  include AntiDdos

  skip_before_filter :verify_authenticity_token
  # TODO: OPEN SYSTEM requires slight action here
  before_filter :allow_for_guests?

  #until NewRelic fixes their request parameters encoding handling
  before_filter :add_newrelic_custom_query_param, :only => :index

  # Mainly just to prettify the URL from /search to /search/thing/query
  def route_search
    if params[:q]
      redirect_to search_results_url(params[:q], 'users')
    else
      redirect_to explore_path
    end
  end

  def index
    # raise Kroogi::NotFound # disable to stop errors flud that are killing servers
    @query = query = params[:q] || ''
    @type = ['users', 'content'].include?(params[:type]) ? params[:type] : 'users'
    if query.blank?
      flash[:warning] = "Search query shouldn't be empty".t
      redirect_to(explore_path) and return
    end
    unless query =~ /[^%]/ #not only wildcards please
      flash[:warning] = "Search query shouldn't consist of just wildcards".t
      redirect_to(explore_path) and return
    end

    content_search = (@type == 'content')
    @title = content_search ? 'Search for content: {{query}}' / query : 'Search for users: {{query}}' / query
    @content_html_headers = true
    @force_not_contributed = true #let's cache it with Donate buttons for logged in users
    unless read_fragment(search_cache_key)
      if content_search
        @results = Content.active.search(query, :page => (params['page'] || 1),
                                              :per_page => setpagesize,
                                              :retry_stale => true)
        @content_count = @results.total_entries
        @user_count = User.search(query).total_entries
      else
        @results = User.search(query, :page => (params['page'] || 1),
                                    :per_page => setpagesize,
                                    :retry_stale => true)

        # Boring stats
        @user_count = @results.total_entries
        @content_count = Content.active.search(query).total_entries
      end

      # this is dumb...because our such page sucks.
      all_zero = (@content_count || 0).zero? && (@user_count || 0).zero?
      if @type == "content" && (@content_count || 0).zero?
        redirect_to search_results_url(query, 'users') unless all_zero
      elsif @type == "users" && (@user_count || 0).zero?
        redirect_to search_results_url(query, 'content') unless all_zero
      end
    end
  rescue Riddle::ResponseError => e
    if e.message['offset out of bounds']
      flash[:warning] = "So you like big page numbers?".t
      redirect_to explore_path
    else
      raise e
    end
  end

  private

  helper_method :search_cache_key
  def search_cache_key
    cache_key_with_locale(current_user.guest?, params[:type], params[:q], params[:page] || 1, setpagesize)
  end
  
  def add_newrelic_custom_query_param
    NewRelic::Agent.add_custom_parameters(:q => params[:q])
  end

  def allow_for_guests?
    if APP_CONFIG[:search_for_guests] && APP_CONFIG[:search_for_guests][:enabled] == true
      count_requests
    else
      login_required
    end
  end

end
