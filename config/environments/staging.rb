config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true  # i want verbose errors on staging, sorry
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = true
config.log_level = :debug
config.cache_store = :mem_cache_store, 'web03:11211', {:namespace => "kroogi-staging", :compression => true, :debug => true, :memory => 128}

# Enable delivery errors, let's see if smth wrong there
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :notls

APP_CONFIG = Configurer.new({
    :ru_host => 'brainmaggot.org',
    :hostname => 'brainmaggot.org',
    :ssl_host => 'www.brainmaggot.org',
    :log_path => '/mnt/krugi/kroogi/thisenv/shared/log',
    :music_contest_default_cover => 9883,
    :remixes => {:miro => 10750, :anya => 10750},
    :smscoin => {:purse_id => 8288, :secret => 'fdgdsgas'},
    :fb_like_enabled_contents => ['15393', '14645','14655','13245','7635','14654', '14279', '12345', '10720'],
    :vk_api_id => {'brainmaggot.org' => '2046951'},
    :instance_caching_for_currency_rates => false,
    :search_for_guests => {:enabled => true, :interval => 5.seconds, :requests => 10},
})

ExceptionNotifier.exception_recipients = %w(engineering@your-net-works.com)
ExceptionNotifier.sender_address = %("Staging Application Error" <noreply.stage@your-net-works.com>)
ExceptionNotifier.email_prefix = "[STAGING ERROR] "
ExceptionNotifier.delivery_method = :activerecord

# Enable serving of images, stylesheets, and javascripts from an asset server
config.action_controller.asset_host = "http://assets%d.brainmaggot.org"
config.threadsafe!
