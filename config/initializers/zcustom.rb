##################################################
# These settings change the behavior of Rails 2 apps and will be defaults
# for Rails 3. You can remove this initializer when Rails 3 is released.

# Include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = true

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Use ISO 8601 format for JSON serialized times and dates.
ActiveSupport.use_standard_json_time_format = true

# Don't escape HTML entities in JSON, leave that for the #json_escape helper.
# if you're including raw json in an HTML page.
ActiveSupport.escape_html_entities_in_json = false
##################################################

# Include your application configuration below

require "object"
require "metaid"
require "auto_excerpt"
require "kroogi_format"
require 'kroogi_errors'
require "kroogi_version"
require_dependency "donation_setting_methods"
require 'sentry'
require "browser"
Sentry::SymmetricSentry.default_key = "DontChangeThis!!UnlessYouKn0wTheConsequnces"

ActiveSupport::Dependencies.log_activity = false

# Array of plugins with Application model dependencies.  
# TODO - investigate more http://www.hervalfreire.com/blog/2007/05/07/user-expected-got-user/
# http://blog.spotstory.com/2007/04/19/upgrading-to-rails-12/
# only needed for dvelopment mode
reloadable_plugins = ["acts_as_threaded", "acts_as_permitted", "acts_as_voteable", "acts_as_taggable_on_steroids"]
# Force these plugins to reload, avoiding stale object references
reloadable_plugins.each do |plugin_name|
    reloadable_path = RAILS_ROOT + "/vendor/plugins/#{plugin_name}/lib"
    ActiveSupport::Dependencies.load_once_paths.delete(reloadable_path)
end

require 'patches'
require 'hash'
require 'kroogi'
require_dependency 'user_monitor'

# Sorry, but tests require current_user too
ActiveRecord::Base.class_eval do
  include ActiveRecord::UserMonitor  #unless RAILS_ENV[/test/]
end

def logger
  RAILS_DEFAULT_LOGGER
end
def log
  RAILS_DEFAULT_LOGGER
end

def notify_about_async_error(e, what = 'do the job')
  return if RAILS_ENV =~ /development|test/
  msg = "Failed to %s asynchronously (going to retry synchronously): %s" % [what, e.inspect]
  AdminNotifier.deliver_alert(msg)
rescue
  #not much we can do here actually - who wants to read log files
end
