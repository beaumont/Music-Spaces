# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'
Rake.application.options.trace = true

namespace :kroogi do
  desc "app version"
  task :version => [:environment] do
    # require File.join(File.dirname(__FILE__), *%w[lib kroogi])
    puts "Application Version: " + Kroogi.version
  end
  
  desc "translations version"
  task :translation_version => [:environment] do
    # require File.join(File.dirname(__FILE__), *%w[lib kroogi])
    puts "Translations Version: " + Kroogi.translation_version
  end
  
end

namespace :passenger do  
  desc 'Restart Passenger'  
  task :restart do  
    system("touch tmp/restart.txt")  
  end  
end