# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
Rails::Initializer.run do |config|
  # gem dependencies
  # config.gem "chronic"
  # forget this for now
  
  # Development Specific Gems
  # config.gem "rspec"
  # config.gem "ZenTest"
  # config.gem "redgreen"
  # config.gem "mocha"
  # config.gem "rcov"
  # config.gem "rspec-rails"
  # config.gem "ruby-debug"
  
  # Some gems which are required for various things
  # config.gem "aws-s3", :lib => 'aws/s3'
  # config.gem "livejournal"
  # config.gem "shared-mime-info"
  # config.gem "erubis"
  # config.gem "aws-s3"
  # config.gem "packet"
  # config.gem "mini_magick"
  # config.gem "sentry"
  # config.gem "mp3info-ruby"
  # config.gem "id3lib-ruby"
  #   Note: To install on OSX...
  #   sudo port install id3lib
  #   ARCHFLAGS="-arch i386" sudo gem install id3lib-ruby -- --build-flags --with-opt-dir=/opt/local
   
   config.gem "paypal" # custom gem, frozen
   config.gem "validatable"
   config.gem "soap4r", :lib => 'soap/rpc/driver'
   config.gem "web_money" # custom gem, frozen
   config.gem "httpclient"
   config.gem "rchardet"
   #chardet refuses freezing, so it's a plugin
   config.gem "nkallen-cache-money", :lib => 'cache_money'

   config.gem 'ya2yaml'
   config.gem "ynw-ar_mailer", :lib => 'action_mailer/ar_mailer'
   config.gem 'ruby-hmac', :lib => 'ruby_hmac'
   config.gem 'subdomain-fu'
   config.gem 'mogli'
   config.gem 'crack'
   config.gem 'hashie'
   config.gem 'httparty'
  
  config.gem 'contacts'
  config.gem 'gdata'

  config.gem 'htmldiff'
#  config.gem 'json'
  #config.gem 'yaroslav-russian', :lib => 'russian', :source => 'http://gems.github.com'

  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  
  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  
   config.plugins = [:all, :globalize2, :custom_ar_extensions, :plugin_hacks]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_krugi_session',
    :secret      => 'e1d652d4f0a8c734c3ec1d96ed308fc7b96985b8a198c1431fd5d509f9f1a3943a26b4f5c604d6e8d907afb4bcdc311a3ff5a2f230607058a480fd5f10cf37d4'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :user_observer, :invite_observer, :activity_observer,
          :monetary_transaction_observer, :new_public_content_observer, :globalize_translation_observer
   
  # html sanitize options
  config.after_initialize do 
    ActionView::Base.sanitized_allowed_attributes.delete "xml:lang"
    ActionView::Base.sanitized_allowed_tags.subtract %w(hr samp var embed div)
    ActionView::Base.sanitized_allowed_tags = 'pre','code'
  end

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  config.time_zone = 'UTC'
end
require 'soap/mapping'

SubdomainFu.tld_size = 1
SubdomainFu.mirrors = %w(www)
