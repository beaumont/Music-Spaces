require 'yaml'
require 'rubygems'
require 'active_support'
begin
  require 'aws/s3'
rescue LoadError
  raise Exception.new('AWS::S3 could not be loaded')
end


ENV['RAILS_ENV'] ||= 'development'

# extra configuration, may be put in conf file too?
ENV['TMPDIR'] ||= '/tmp'
ENV['LOGS'] ||= '/mnt/krugi/logs/rails_rotated'
#ENV['LOGS'] ||= '~/subversion/krugi/src/main/krugi/log'
ENV['TRAC'] ||= '/mnt/krugi/trac/krugi'
ENV['REPO'] ||= '/mnt/krugi/svn'
ENV['RESTORE'] ||= '/mnt/restore'
# used to tell it to backup mysql mysql db too (rails mat not have permissions to do so, in that case set it to nil)
ENV['DBEXTRA'] ||= 'mysql'

s3_config_path = RAILS_ROOT + '/config/amazon_s3.yml'
s3_config = YAML.load_file(s3_config_path)[ENV['RAILS_ENV']]
s3_connect = lambda do
  AWS::S3::Base.establish_connection!({
  :access_key_id     => s3_config["access_key_id"],
  :secret_access_key => s3_config["secret_access_key"],
  #:server            => s3_config["server"],
  #:port              => s3_config["port"],
  #:use_ssl           => s3_config["use_ssl"]
  })
end


namespace :s3 do

    desc "Backup everything to S3"
    task :backup => [ "s3:backup:db", "s3:backup:scm", "s3:backup:logs", "s3:backup:trac", "s3:manage:clean_up", "s3:manage:list"]


    desc "Retrieve the latest revision of code, database, and scm from S3.  If  you need to specify a specific version, call the individual retrieve tasks"
    task :retrieve => [ "s3:retrieve:logs",  "s3:retrieve:db", "s3:retrieve:scm", "s3:retrieve:trac"]


    desc 'Lists buckets from current s3 config (config/amazon_s3.yml)'
    task :show_buckets do
        s3_connect.call
        puts AWS::S3::Service.buckets.map(&:name).join("\n")
    end

    desc 'Adds bucket from current s3 configuration (config/amazon_s3.yml)'
    task :create_bucket do
        s3_connect.call
        AWS::S3::Bucket.create(s3_config["bucket_name"])
    end

    desc 'Adds crossdomain.xml file to current s3 bucket'
    task :add_crossdomain do
        s3_connect.call
        AWS::S3::S3Object.store(
        'crossdomain.xml',
        open(File.join(RAILS_ROOT, 'public/crossdomain.xml')),
        s3_config["bucket_name"],
        :content_type => 'text/xml',
        :access => :public_read
        )
    end

  

    namespace :backup do
      
      desc "Backup the logs"
      task :logs  do
          msg "backing up LOGS to S3"
          s3_connect.call
          make_bucket('logs')
          archive = "#{ENV['TMPDIR']}/#{archive_name('logs')}"
          # copy it to tmp just to play it safe...
          cmd = "cp -rp #{ENV['LOGS']} #{archive}"
          msg "extracting logs directory"
          puts cmd
          result = system(cmd)      
          raise("copy of logs dir failed..  msg: #{$?}") unless result
          send_to_s3('logs', archive)
      end #end logs task

      desc "Backup the database to S3"
      task :db  do
          msg "backing up the DATABASE to S3"
          s3_connect.call
          make_bucket('db')
          archive = "#{ENV['TMPDIR']}/#{archive_name('db')}"
          Dir.mkdir(archive)
          msg "dumping db"
          mysqldump(archive)
          # dump extra db too
          puts "Shall we:#{ENV['DBEXTRA']}"
          mysqldump(archive, ENV['DBEXTRA']) unless ENV['DBEXTRA'].nil?
          send_to_s3('db', archive)
      end
      
      desc "Backup the trac"
        task :trac  do
            msg "backing up TRAC to S3"
            s3_connect.call
            make_bucket('trac')
            archive = "#{ENV['TMPDIR']}/#{archive_name('trac')}"
            # export trac
            cmd = "trac-admin #{ENV['TRAC']} hotcopy #{archive}"
            msg "extracting trac directory"
            puts cmd
            result = system(cmd)      
            raise("copy of trac dir failed..  msg: #{$?}") unless result
            send_to_s3('trac', archive)
        end #end logs task
      

      desc "Backup the scm repository to S3"
      task :scm  do
          msg "backing up the SCM repository to S3"
          s3_connect.call
          make_bucket('scm')
          archive = "#{ENV['TMPDIR']}/#{archive_name('scm')}"
          svn_info = {}
          IO.popen("svn info") do |f|
              f.each do |line|
                  line.strip!
                  next if line.empty?
                  split = line.split(':')
                  svn_info[split.shift.strip] = split.join(':').strip
              end
          end

          url_type, repo_path = svn_info['URL'].split('://')
          repo_path.gsub!(/\/+/, '/').strip!
          url_type.strip!

          use_svnadmin = true
          final_path = svn_info['URL']
          if url_type =~ /^file/
              puts "'#{svn_info['URL']} is local!"
              final_path = find_scm_dir(repo_path)
          else
              puts "'#{svn_info['URL']}' is not local!\nWe will see if we can find a local path."
              repo_path = repo_path[repo_path.index('/')...repo_path.size]
              repo_path = find_scm_dir(repo_path)
              # its not really that good in finding it, so lets just use config value
              repo_path = ENV['REPO'] unless ENV['REPO'].nil?
              if File.exists?(repo_path)
                  uuid = File.read("#{repo_path}/db/uuid").strip!
                  if uuid == svn_info['Repository UUID']
                      puts "We have found the same SVN repo at: #{repo_path} with a matching UUID of '#{uuid}'"
                      final_path = find_scm_dir(repo_path)
                  else
                      puts "We have not found the SVN repo at: #{repo_path}.  The uuid's are different."
                      use_svnadmin = false
                      final_path = svn_info['URL']
                  end
              else
                  puts "No SVN repository at #{repo_path}."
                  use_svnadmin = false
                  final_path = svn_info['URL']          
              end
          end

          #ok, now we need to do the work...
          cmd = use_svnadmin ? "svnadmin dump -q #{final_path} > #{archive}" : "svn co -q --ignore-externals --non-interactive #{final_path} #{archive}"
          msg "extracting svn repository"
          puts cmd
          result = system(cmd)
          raise "previous command failed.  msg: #{$?}" unless result
          send_to_s3('scm', archive)
      end #end scm task

  end # end backup namespace



  namespace :retrieve do
      desc "retrieve the latest code backup from S3, or optionally specify a VERSION=this_archive.tar.gz"
      task :logs  do
          s3_connect.call
          retrieve_file 'logs', ENV['VERSION']
      end

      desc "retrieve the latest db backup from S3, or optionally specify a VERSION=this_archive.tar.gz"
      task :db  do
          s3_connect.call
          retrieve_file 'db', ENV['VERSION']
      end

      desc "retrieve the latest scm backup from S3, or optionally specify a VERSION=this_archive.tar.gz"
      task :scm  do
          s3_connect.call
          retrieve_file 'scm', ENV['VERSION']
      end
      
       desc "retrieve the latest trac backup from S3, or optionally specify a VERSION=this_archive.tar.gz"
       task :trac  do
          s3_connect.call
          retrieve_file 'trac', ENV['VERSION']
       end
  end #end retrieve namespace

  namespace :manage do
      desc "Remove all but the last 10 most recent backup archive or optionally specify KEEP=5 to keep the last 5"
      task :clean_up  do
          keep_num = ENV['KEEP'] ? ENV['KEEP'].to_i : 10
          puts "keeping the last #{keep_num}"
          s3_connect.call
          cleanup_bucket('logs', keep_num)
          cleanup_bucket('db', keep_num)
          cleanup_bucket('scm', keep_num)
          cleanup_bucket('trac', keep_num)
      end

      desc "list all your backup archives"
      task :list  do
          s3_connect.call
          print_bucket 'logs'
          print_bucket 'trac'
          print_bucket 'db'
          print_bucket 'scm'
      end

  end #end manage namespace


end





private

  def find_scm_dir(path)
    #double check if the path is a real physical path vs a svn path
    final_path = path
    tmp_path = final_path
    len = tmp_path.split('/').size
    while !File.exists?(tmp_path) && len > 0 do
      len -= 1
      tmp_path = final_path.split('/')[0..len].join('/')
    end
    final_path = tmp_path if len > 1
    final_path
  end
  
  def mysqldump(archive, database_override = nil)
      msg "retrieving db info"
      # there must be a better way to do this...
      result = File.read "#{RAILS_ROOT}/config/database.yml"
      result.strip!
      config_file = YAML::load(ERB.new(result).result)
      db_info = [
        config_file[RAILS_ENV]['database'],
        config_file[RAILS_ENV]['username'],
        config_file[RAILS_ENV]['password']
      ]
      database, user, password = db_info
      database = database_override unless database_override.nil?
      cmd = "mysqldump --opt --skip-add-locks -u#{user} "
      puts cmd + "... [password filtered]"
      cmd += " -p'#{password}' " unless password.nil?
      cmd += " #{database} > #{archive}/#{database}.dump"
      result = system(cmd)
      raise("mysqldump failed.  msg: #{$?}") unless result 
  end

  # will save the file from S3 in the pwd.
  def retrieve_file(name, specific_file)
    msg "retrieving a #{name} backup from S3 using bucket: #{bucket_name(name)}"
    if specific_file.nil?
     objects = AWS::S3::Bucket.objects(bucket_name(name), :max_keys => 100)
     return if objects.empty?
     specific_file = objects.last.key
    end
    
    open("#{ENV['RESTORE']}/#{specific_file}", 'w') do |file|
      AWS::S3::S3Object.stream(specific_file, bucket_name(name)) do |chunk|
        file.write chunk
      end
    end
    msg "retrieved file #{ENV['RESTORE']}/#{specific_file}"
  end

  # print information about an item in a particular bucket
  def print_bucket(name)
    msg "#{bucket_name(name)} Bucket"
    make_bucket(name)
    bucket = AWS::S3::Bucket.find(bucket_name(name))
    bucket.each do |object|
       size = object.content_length.to_i
       sizestr =  (size > 1.megabyte ? "#{size/1.megabyte}MB" : "#{size/1.kilobyte}KB")
       puts "size: #{sizestr},  Name: #{object.key},  Last Modified: #{Time.parse( object.last_modified.to_s ).to_s(:short)} UTC"
    end
  end

  # go through and keep a certain number of items within a particular bucket, 
  # and remove everything else.
  def cleanup_bucket(name, keep_num, convert_name=true)
    make_bucket(name)
    msg "cleaning up the #{name} bucket"
    bucket = convert_name ? bucket_name(name) : name
    entries = AWS::S3::Bucket.objects(bucket, :max_keys => 50)
    remove = entries.size-keep_num-1
    entries[0..remove].each do |entry|
      AWS::S3::S3Object.delete entry.key, bucket
      puts "deleting #{bucket}/#{entry.key}, #{Time.parse(entry.last_modified.to_s).to_s(:short)} UTC."
    end unless remove < 0
  end

  # programatically figure out what to call the backup bucket and 
  # the archive files.  Is there another way to do this?
  def project_name
    # using Dir.pwd will return something like: 
    #   /var/www/apps/staging.sweetspot.dm/releases/20061006155448
    # instead of
    # /var/www/apps/staging.sweetspot.dm/current
    pwd = ENV['PWD'] || Dir.pwd
    #another hack..ugh.  If using standard capistrano setup, pwd will be the 'current' symlink.
    pwd = File.dirname(pwd) if File.symlink?(pwd)
    File.basename(pwd)
  end

  # create S3 bucket.  If it already exists, not a problem!
  def make_bucket(name)
    msg "using bucket: #{bucket_name(name)}"
    AWS::S3::Bucket.create(bucket_name(name))
  end

  def bucket_name(name)
    # it would be 'nicer' if could use '/' instead of '_' for bucket names...but for some reason S3 doesn't like that
    "#{token(name)}_backup"
  end

  def token(name)
    "#{project_name}_#{name}"
  end

  def archive_name(name)
    @timestamp ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
    token(name).sub('_', '.') + ".#{RAILS_ENV}.#{@timestamp}"
  end

  # put files in a zipped tar everything that goes to s3
  # send it to the appropriate backup bucket
  # then does a cleanup
  def send_to_s3(name, tmp_file)
    archive = "#{ENV['TMPDIR']}/#{archive_name(name)}.tar.gz"

    msg "archiving #{name}"
    cmd = "tar -cpzf #{archive} #{tmp_file}"
    puts cmd
    system cmd

    msg "sending archived #{name} to S3"
    # put file with default 'private' ACL
    AWS::S3::S3Object.store(
      archive.split('/').last,
      open(archive, "rb"),
      bucket_name(name),
      :content_type => 'application/x-gzip',
      :access => :private
    )
    msg "finished sending #{name} S3"

    msg "cleaning up"
    cmd = "rm -rf #{archive} #{tmp_file}"
    puts cmd
    system cmd  
  end

  def msg(text)
    puts "#{Time.now} -- msg: #{text}"
  end

