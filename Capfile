load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

set :stages, %w(staging production rc selenium)
require 'capistrano/ext/multistage'
require 'lib/recipes/monit_mongrels'
require 'lib/recipes/svn'
require 'lib/recipes/custom'

load 'config/deploy'