# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = true
config.cache_store = :mem_cache_store, 'localhost:11211', {:namespace => "kroogi-selenium", :compression => true, :debug => true, :memory => 128}

# Tell ActionMailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test
config.action_mailer.perform_deliveries = true

#don't log deprecation errors to console - there are so many of them at the
#  moment that CC cuts the build log when showing it!
ActiveSupport::Deprecation.behavior = Proc.new { |message, callstack|
   logger.warn message
   logger.debug callstack.join("\n  ") if ActiveSupport::Deprecation.debug
}

APP_CONFIG = Configurer.new({
   :ru_host => 'kroogi.ru:3335',
   :hostname => 'kroogi.com:3335',
   :force_single_domain => true,
   :remixes => {},
})

ExceptionNotifier.exception_recipients = %w(engineering@your-net-works.com)
ExceptionNotifier.sender_address = %("Selenium Error" <noreply@your-net-works.com>)
ExceptionNotifier.email_prefix = "[Selenium ERROR] "

config.threadsafe!
