# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = true  # i want verbose errors on rc, sorry
config.action_controller.perform_caching             = true
config.cache_store = :mem_cache_store, 'web05:11211', {:namespace => "kroogi-rc", :compression => true, :debug => true, :memory => 128}

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Enable delivery errors, let's see if smth wrong there
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :notls

APP_CONFIG = Configurer.new({
   :ru_host => 'brainmaggot.net',
   :hostname => 'brainmaggot.net',
   :ssl_host => 'www.brainmaggot.net',
   :log_path => '/mnt/krugi/kroogi/thisenv/shared/log',
   :music_contest_default_cover => 3483,
   :remixes => {},
   :smscoin => {:purse_id => 8730, :secret => 'rgergewrg'},
   :fb_like_enabled_contents => ['3315'],
   :vk_api_id => {'brainmaggot.net' => '2046955'},
   :instance_caching_for_currency_rates => false,
   :save_users_with_digest => true,
})

ExceptionNotifier.exception_recipients = %w(engineering@your-net-works.com)
ExceptionNotifier.sender_address = %("RC Application Error" <noreply.rc@your-net-works.com>)
ExceptionNotifier.email_prefix = "[RC ERROR] "
ExceptionNotifier.delivery_method = :activerecord

# Less logging, please
config.log_level = :info

# Enable serving of images, stylesheets, and javascripts from an asset server
config.action_controller.asset_host = "http://assets%d.brainmaggot.net"
config.threadsafe!
