# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false
# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false  #turn it on to play with caching
config.cache_store = :mem_cache_store, 'localhost:11211', {:namespace => "kroogi-development", :compression => true, :debug => true}

# config.action_controller.session = {
#   :cookie_only => false,
#   :session_key => '_krugi_dev_session',
#   :secret      => 'e1d652d4f0a8c734c3ec1d96ed308fc7b96985b8a198c1431fd5d509f9f1a3943a26b4f5c604d6e8d907afb4bcdc311a3ff5a2f230607058a480fd5f10cf37d4'
# }
# 
# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
config.action_mailer.delivery_method = 'test'
# log = Logger.new($stdout)
# log.level = Logger::WARN
# ActiveRecord::Base.logger = log

begin
  # fixes problem with ruby-debug logging
  SCRIPT_LINES__ = {}   
  require "ruby-debug"
rescue LoadError
  puts "install ruby-debug if you want to debug shit."
end

config.log_level = :debug

APP_CONFIG = Configurer.new({
   :ru_host => 'soxos-inc.com:5322',
   :hostname => 'soxos-inc.com:5322',
   #:avoid_s3 => true,
   :log_path => 'log',
   :force_single_domain => false,
   :music_contest_default_cover => 9092,
   :disable_top_search_autocomplete => true,
   :disable_bdrb => true,
   :remixes => {:tatu => 9259},
   :multiple_uploader_enabled => true,
   :fb_like_enabled_contents => ['10857', '15393', '14645','14655','13245','7635','14654', '14279', '12345', '10720'],
   :vk_api_id => {'kroogi.pb' => '2052881'},
   :fb_like_enabled_contents => ['10857'],
   :enable_activity_log => true,
})

ActiveRecord::Base.colorize_logging = true
#config.threadsafe! #this also enables classes caching which hurts in dev mode

config.time_zone = 'Kyev'
