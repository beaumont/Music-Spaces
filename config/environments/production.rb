# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.cache_store = :mem_cache_store, 'web06:11211', 'web07:11211', {:namespace => "kroogi-production", :compression => true, :memory => 128}

# Less logging, please
config.log_level = :error


# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false
config.action_mailer.delivery_method = :notls

APP_CONFIG = Configurer.new({
   :ru_host => 'kroogi.com',
   :hostname => 'kroogi.com',
   :ssl_host => 'www.kroogi.com',
   :log_path => '/mnt/krugi/kroogi/thisenv/shared/log',
   :music_contest_default_cover => 569232,
   :legacy_id_hash_secret => 'c573020470b7508260d1685bf9f5f12216e6c2cb', # Don't ever change this
   :remixes => {:tatu => 653951, :lyapis => 653077, :sansara => 571075},
   :smscoin => {:purse_id => 8290, :secret => 'reershbser'},
   :vk_api_id => {'kroogi.com' => '2046120', 'kroogi.ru' => '2046956'},
   :instance_caching_for_currency_rates => false,
   :save_users_with_digest => true,
   :multiple_tracks_uploader_enabled => false,
   :search_for_guests => {:enabled => true, :interval => 1.second, :requests => 2},
})

ExceptionNotifier.exception_recipients = %w(engineering@your-net-works.com)
ExceptionNotifier.sender_address = %("Production Application Error" <noreply.prod@your-net-works.com>)
ExceptionNotifier.email_prefix = "[PRODUCTION ERROR] "
ExceptionNotifier.delivery_method = :activerecord

# Enable serving of images, stylesheets, and javascripts from an asset server
config.action_controller.asset_host = "http://assets%d.kroogi.com"
config.threadsafe!
