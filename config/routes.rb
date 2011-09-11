ActionController::Routing::Routes.draw do |map|
  map.resources :user_address_book_items

  
  map.resource :account_setting,
               :member => {
                 :general => :get,
                 :donation_basket => :get,
                 :livejournal => :get,
                 :remove_box_from_profile => :put
               }

  # Karma point handling
  map.share "/share/:content_id/:referrer_id", :controller => 'karma', :action => 'referral', :referrer_id => nil

  # deprecated?
  map.webmoney "/webmoney/:action/:id", :controller => 'webmoney'
    
  map.thanks "/user/:id/donate/thank_you", :controller => "donate", :action => "thank_you"
  
  # deprecated?
  map.ipn_postback "/donate/instant_payment_notification/:invite_code", :controller => "donate", :action => "instant_payment_notification"
  # deprecated?
  map.webmoney_postback "/donate/webmoney_postback/:invite_code", :controller => "donate", :action => "webmoney_postback"
  # deprecated?
  map.yandex_postback "/donate/yandex_postback", :controller => "donate", :action => "yandex_postback"

  # other mappings (non-user)
  map.search_with_type '/search/:type',     :controller => 'tag',     :action => 'index'
  map.search '/search',     :controller => 'tag',     :action => 'route_search'
  map.sitemap '/smap.xml',     :controller => 'sitemap',     :action => 'projects'

  map.connect '/activity/all/:type', :controller => "activity", :action => "all", :requirements => {:type => /[A-Za-z]+/}
  
  map.with_options :controller => 'account_settings' do |m|
    m.donation_basket '/account_setting/donation_basket/:id', :action => 'donation_basket'
  end
  
  map.basic_content '/:locale/content/:id.:format', :controller => "content", :action => "show"
  map.downloadable_content '/:locale/download/:id.:format', :controller => "content", :action => "show"
  map.old_player_content_link '/:locale/content/:id.:format/:old_player_id', :controller => "content", :action => "show"
  map.old_player_downloadable_content_link '/:locale/download/:id.:format/:old_player_id', :controller => "content", :action => "show"

  map.with_options :controller => 'content' do |m|
    m.content_download '/content/download/:id', :action => 'download'
    m.content_comments '/content/comments/:id', :action => 'comments'
    m.download_bundle '/content/download_bundle/:id', :action => 'download_bundle'
  end
  
  map.namespace :admin do |admin|
    admin.donation_requests '/donation_requests', :controller => 'donation_requests'

    admin.resources :site_activity_logs, :collection => {:browsers => :get, :platforms => :get, :robots => :get, :search_terms => :get}
    admin.resources :notifications, :collection => {:deleted => :get, :unsubscribe => :get}, :member => {:restore => :get}
  end

  map.unsubscribe_change_notifications '/unsubscribe_change_notifications/:user_id/:token',
    :controller => "admin/notifications", :action => "unsubscribe"

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # keep homepage to /explore url for internal links, to prevent bots from getting stuck in a loop
  map.connect   '/explore',        :controller => 'user', :action => 'explore'
  map.user_feed '/user/feed/:id',  :controller => 'user',       :action => 'feed'
  map.user_announcements_feed '/user/announcements_feed/:id/:locale', :controller => 'user', :action => 'announcements_feed'
  map.user_all_activity '/user/activity/:id', :controller => 'user', :action => 'activity'
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # user mappings.
  map.root :controller => 'user'
  
  map.blog '/blog', :controller => 'blog'

  map.with_options :controller => '/user' do |m|
    m.connect '/showcase',                    :action => 'gallery'
    m.connect '/gallery',                     :action => 'gallery'
    m.connect '/favorites',                   :action => 'favorites'

    m.connect '/founders',                    :action => 'founders'
    m.connect '/pending_founders',            :action => 'pending_founders'
    m.connect '/founders_display_options',            :action => 'founders_display_options'
    m.connect '/founder_order',                       :action => 'founder_order'
    m.connect '/edit_founder/:founder_id',            :action => 'edit_founder'

    m.connect '/tags',                   :action => 'tags'
    m.connect '/announcements',               :action => 'announcements'
    m.connect '/comments',                    :action => 'comments'
    m.connect '/following',                   :action => 'following'

    m.connect '/about',                       :action => 'about'
  end

#  map.connect '/user/:id/digital_download/:action', :controller => "digital_download"
  
  map.with_options :controller => 'kroogi' do |m|
    m.connect '/kroogi',                      :action => 'show'
    m.user_kroogs '/user/kroogi/:id',         :action => 'show'
    m.connect '/kroogi/privatewall',          :action => 'privatewall'
  end
  
  map.with_options :controller => 'money' do |m|
    m.money   '/money/index/:id', :action => 'index'
  end
  map.read_and_fwd '/activity/read_and_fwd/:id/:type', :controller => 'activity', :action => 'read_and_frwd'

  map.connect '/invite/send_invites',           :controller => 'invite',   :action => 'send_invites'

  map.with_options :controller => 'home' do |m|
    m.signup '/signup', :action => 'signup'
    m.login '/login', :action => 'login'
    m.logout '/logout', :action => 'logout'
  end

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # This is for rotating backgrounds
  map.connect '/backgrounds', :controller => 'background', :action => 'get'
  map.connect '/admin/home/change_language', :controller => "home", :action => "change_language"
  
  map.with_options :controller => 'moderate' do |m|
    m.report '/moderate/report/:type/:id', :action => 'report'
    m.block '/moderate/block/:type/:id', :action => 'block'
    m.unblock '/moderate/unblock/:type/:id', :action => 'unblock'
  end
  map.user_block '/user/block/:id', :controller => 'user', :action => 'block'
  map.user_restore '/user/restore/:id', :controller => 'user', :action => 'restore'
  
  # Backend, API controller
  map.with_options :controller => 'api' do |m|
    m.connect '/api/reload_translation_cache/:id', :action => 'reload_translation_cache'
  end

  map.with_options :controller => :tps_setup do |m|
    m.resource :tps_setup
  end
  
  # For Facebook
  map.facebook    '/facebook',              :controller => "facebook/home", :action => "index"
  map.authorize   '/facebook/authorize',    :controller => "facebook/home", :action => "authorize"
  map.deauthorize '/facebook/deauthorize',  :controller => "facebook/home", :action => "deauthorize"
  map.connect '/facebook/artist_entrance',  :controller => "facebook/home", :action => "artist_entrance"
  map.connect '/facebook/from_invite',      :controller => "facebook/search", :action => "from_invite"
  map.connect '/facebook/invite/create',    :controller => "facebook/invite", :action => "create"
  map.connect '/facebook/invite/:ma_id',    :controller => "facebook/invite", :action => "new"
  map.connect '/facebook/invite/new/:ma_id',:controller => "facebook/invite", :action => "new" #for publisher
  map.show_content  '/facebook/content/show/:id',       :controller => "facebook/content", :action => "show"
  map.connect  '/facebook/content_from_invite/:id',     :controller => "facebook/content", :action => "content_from_invite"
  map.connect '/facebook/save_as/:id',                  :controller => "facebook/content", :action => "save_as"
  map.connect '/facebook/tab',                          :controller => "facebook/tab", :action => "tab"

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action.:format'

  map.messages_dialogue 'activity/dialogue', :controller => 'activity', :action => 'dialogue'

  APP_CONFIG.remixes.each do |project, content_id|
    map.with_options :controller => 'content', :action => 'show', :id => content_id.to_s do |m|
      m.connect '/remixes', :conditions => {:subdomain => "#{project}"}
    end
  end if APP_CONFIG.remixes

  # For 404 errors
  map.connect '*anypath', :controller => 'application', :action => 'render_404' unless ::ActionController::Base.consider_all_requests_local
end
