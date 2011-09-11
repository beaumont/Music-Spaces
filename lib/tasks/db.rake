ScriptDir = "db/"
Version_pattern  = Regexp.new("#{ScriptDir}([0-9]*)-.*.sql$")
require 'erb'

# task
desc "Creation of the tests database."
namespace "db" do
  namespace :test do
    task :create do
      db_create "test"
    end
  end
end

desc "Creation of the specified database. default is development. Specify test environment using ENV=test"
namespace "db" do
  task :create do
    env_name = (ENV["ENV"] != nil ? ENV["ENV"] : 'development') 
    db_create env_name
  end
end


# task
desc "Deinstallation of the specified database. default is development. Specify test environment using ENV=test"
namespace "db" do
  task :clobber do
    env_name = (ENV["ENV"] != nil ? ENV["ENV"] : 'development') 
    db_clobber env_name
  end
end

# task
desc "Deinstallation of the test database."
namespace "db" do
  namespace :test do
    task :clobber do
      db_clobber "test"
    end
end
end




# -------------------- 
# Implementation details
# -------------------- 

def db_create env_name
  task_info "Started install task on environment #{env_name}"

  Dir.mkdir 'log' unless File.exist? 'log'
  config =  database_configuration[env_name]
  puts
  if config == nil
    puts "Task Failure! Uknown environment #{env_name}. Unable to proceed"
  else
    puts "Creating database #{config['database']} ....."
    create_db(config)
  end
  task_info "Finished install task on environment #{env_name}"
end

def db_clobber env_name
  task_info "Started clobber task on environment #{env_name}"

  config =  database_configuration[env_name]
  if config == nil
    puts "Task Failure! Uknown environment #{env_name}. Unable to proceed"
  else
    puts "Dropping database #{config['database']} ....."
    drop_db(config)
  end

  task_info "Finished clobber task on environment #{env_name}"
end


# make db function
def task_info(msg)
  puts
  puts ' ------------------------------------------------------' 
  puts " ---- #{msg} --"
  puts ' ------------------------------------------------------' 
  puts
end

# -------------------- 
# Mysql binary calls
# -------------------- 

def drop_db(conf)
  IO.popen(mysql(conf, false), 'w') do |io|
    io << "drop database #{conf['database']}"
  end
end


def drop_tables(conf)
  tablelist = []
  IO.popen(mysql(conf, true), 'w+') do |io|
    io.puts "show tables;;"
    io.close_write
    io.each do |line|
      line = line.chomp
      next if line.empty?
      tablelist.push(line)
    end
  end
  puts "Dopping tables:"
  tablelist.each do |tablename|
    puts "drop table #{tablename};"
  end
  IO.popen(mysql(conf, true), 'w') do |io|
    tablelist.each do |tablename|
      io.puts "drop table #{tablename};"
    end
  end
  puts "Tables are dropped sucessfully"
end

def create_db(conf)
  IO.popen(mysql(conf, false), 'w') do |io|
    io << "create database #{conf['database']}"
  end
end


def mysql(conf, use_db)
  mysql = ['mysql']
  mysql << "-u#{conf['username']}"
  mysql << "-p#{conf['password']}" if conf['password']
  mysql << "-h#{conf['host']}" if conf['host']
  mysql << "-B"
  mysql << "--skip-column-names"
  mysql << "--line-numbers"
  #mysql << "--disable-pager"
  mysql << "--force"
  #mysql << "--tee=log/mysqlout.log"
  mysql << conf['database'] if use_db
  return mysql.join(' ')
end


def database_configuration
  YAML::load(ERB.new(IO.read(File.join(File.dirname("../"), 'config', 'database.yml'))).result)
end

require 'find'
namespace :db do  
  desc "Backup the database to a file. Options: DIR=base_dir RAILS_ENV=production MAX=5"
  task :backup => [:environment] do
    datestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
    base_path = ENV["DIR"] || "db" 
    backup_base = File.join(base_path, 'local_backups')
    backup_folder = File.join(backup_base, datestamp)
    backup_file = File.join(backup_folder, "#{RAILS_ENV}_dump.sql.gz")
    File.send :makedirs, backup_folder
    db_config = ActiveRecord::Base.configurations[RAILS_ENV]
    sh "mysqldump -u #{db_config['username']}#{" -p#{db_config['password']}" unless db_config['password'].blank?} -Q --add-drop-table -O add-locks=FALSE -O lock-tables=FALSE #{db_config['database']} | gzip -c > #{backup_file}"
    dir = Dir.new(backup_base)
    all_backups = dir.entries[2..-1].sort.reverse
    puts "Created backup: #{backup_file}"
    max_backups = ENV["MAX"] ? ENV["MAX"].to_i : 5
    unwanted_backups = all_backups[max_backups..-1] || []
    puts "#{unwanted_backups.size} unwanted"
    unwanted_backups.each do |unwanted_backup|
      FileUtils.rm_rf(File.join(backup_base, unwanted_backup))
      puts "deleted #{unwanted_backup}" 
    end
    puts "Deleted #{unwanted_backups.length} backups, #{all_backups.length - unwanted_backups.length} backups available" 
  end
end