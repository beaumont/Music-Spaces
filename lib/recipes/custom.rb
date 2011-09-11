Capistrano::Configuration.instance(true).load do

  require File.join(File.dirname(__FILE__), '..', 'translation_tasks_mixin.rb')
  
  # pre-requisites for any sucessfull deployment
  after "deploy", "deploy:cleanup"
  after "deploy:migrations", "deploy:cleanup"

  # disable for now, and see if emails get too annoying
  #  IMPORTANT calling deploy:monitor immideately after restart confuses monit alot. it needs a wait
  #  of 20 seconds or more for restart signal to go through, but lets try running it without monitor/unmonotor 
  # to cut on deployment time
  #before "deploy", "deploy:unmonitor"
  #before "deploy:migrations", "deploy:unmonitor"
  #after "deploy", "deploy:monitor"
  #after "deploy:migrations", "deploy:monitor" 


  namespace :kroogi do
    desc <<-DESC
    help with var debug. multistage evaluates lazily, with stage variable not defined until very late
    DESC
    task :show_vars do 
      # debugging - good to have
      %w(application rails_env stage repository deploy_to).each do |k| 
        puts "#{k} => #{fetch(k.to_sym)}" 
      end 
      (variables.keys.select { |k| /path/ =~ k.to_s }).each do |k| 
        puts "#{k} => #{fetch(k.to_sym)}" 
      end
    end
  end
  before "deploy", "kroogi:show_vars"
  before "deploy:migrations", "translations:load_remote"
  before "deploy:migrations", "kroogi:show_vars"
  before "deploy:setup", "kroogi:show_vars"

  desc "Generate a maintenance.html to disable requests to the application."
  deploy.web.task :disable, :roles => :web do
    put_maintenance_template
  end

  desc "Re-enable the web server by deleting any maintenance file."
  deploy.web.task :enable, :roles => :web do
    run("rm #{shared_path}/system/maintenance.html") rescue nil
  end

  desc 'show "currently updating" page (effective hides the application)'
  deploy.web.task :updating, :roles => :web do
    put_maintenance_template('Site Updating', "We'll be back momentarily")
  end
  before 'deploy:update_code', 'deploy:web:updating'
  after 'deploy:cleanup', 'deploy:web:enable'

  desc 'just an ls to kickstart the filesystem somehow... ask Sasha :)'
  deploy.web.task :kickstart, :roles => :app do
    run "cat #{current_path}/REVISION"
  end
  after 'deploy:cleanup', 'deploy:web:kickstart'

  namespace :translations do

    desc "loads the env's most recent translations from svn"
    task :load_remote, :roles => :db, :only => { :primary => true } do
      puts "Loading translations from remote #{current_path}/db/translations directory in #{rails_env} environment"
      begin
        run "cd #{current_path} && svn up -q --force db/translations && RAILS_ENV=#{rails_env} rake db:trans:load RELOAD=false"
      rescue Exception => e
        puts "Error loading latest translations (ignoring): %s" % e.inspect
      end
    end

    desc 'pushes most recent trunk translations to the specified environment'
    task :load_latest, :roles => :db, :only =>  {:primary => true} do
      run "cd #{current_path} && svn up -q --force db/translations && RAILS_ENV=#{ENV['TARGET']} rake db:trans:load RELOAD=false"
    end

  end
  
  def put_maintenance_template(given_title = nil, given_body = nil)
    return if ENV['KEEP_ALIVE'] && ENV['KEEP_ALIVE'] != '0' 
    remote_path = "#{shared_path}/system/maintenance.html"
    on_rollback { run "rm #{remote_path}" }
    disable_template = File.join('.', 'app', 'views', 'errors', 'generic.rhtml')
    template = File.read(disable_template)
    title = ENV['TITLE'] || given_title || 'Down for maintenance'
    msg = ENV['BODY'] || given_body || "We'll be back soon"
    maintenance = ERB.new(template).result(binding)
    put maintenance, "#{remote_path}", :mode => 0644
  end

  namespace :drb do
    desc "start backgroundrb"
    task :start, :roles => :app do
      puts " Starting BackgrounDRB ******"
      run "cd #{current_path} && nohup nice script/backgroundrb start -e #{rails_env} > /dev/null"
    end
    
    task :stop, :roles => :app do
      puts " Stopping BackgrounDRB ******"
      run "cd #{current_path} && script/backgroundrb stop -e #{rails_env}"
    end
  end

  before "deploy:cleanup", "sphinx:rebuild"
  namespace :sphinx do
    desc "rebuilds Sphinx index"
    task :rebuild, :roles => :sphinx do
      if ENV['REBUILD_SPHINX']
        puts "Rebuilding Sphinx index"
        run "cd #{current_path} && RAILS_ENV=#{rails_env} rake ts:rebuild"
      else
        puts "NOT rebuilding Sphinx index - REBUILD_SPHINX flag is not set"
      end
    end
  end

  before "deploy:cleanup", "memcache:bounce"
  namespace :memcache do
    desc "restarts memcache"
    task :bounce, :roles => :app do
      begin
        puts "Restarting Memcached"
        sudo "/etc/init.d/memcached restart"
      rescue Exception => e
        puts "got %s trying to restart memcached: %s" % [e.class.name, e.message]
      end if rails_env == 'staging' && false
    end
  end
end


# Wrapper to encapsulate the pattern of capturing output from remote commands
def get_output(cmd)
  output = ''
  run "#{cmd}" do |channel, stream, data|
    output = data
  end
  return output.chomp#.join("\n").chomp
end

# NOT DONE, obviously. eventually we'll want this for WM validations, but ended up having to do it by hand b/c miro was on phone w/ manager and needed it asap. leaving as a base for future work.
# kroogi.task :push_public_file, :roles => :web do
#   raise "requires FILE=fname, rooted in public/ dir" unless ENV['FILE']
#   file = 
#   raise "file #{ENV['FILE']} doesn't exist" unless file
#   puts "Uploading #{file} to #{rails_env}"
#   upload file
# end

