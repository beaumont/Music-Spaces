RC_PATH = 'branches/rc'
RC_FULL_PATH = "https://kroogi/svn/krugi/#{RC_PATH}"

Capistrano::Configuration.instance(true).load do |configuration|
  namespace :kroogi do
    desc <<-DESC
    tag the production release
    DESC
    task :tag_release, :roles => :web do
      rev, rev_app, today, now = get_info(RC_PATH)

      puts `svn copy #{RC_FULL_PATH} https://kroogi/svn/krugi/tags/rel-#{today}-#{rev}-#{rev_app}  -m 'auto release from RC rev #{rev} (app rev #{rev_app}) on #{now} DO NOT MODIFY'`
      puts `svn rm https://kroogi/svn/krugi/tags/RELEASE -m 'Remove current release'`
      puts `svn copy #{RC_FULL_PATH} https://kroogi/svn/krugi/tags/RELEASE  -m 'auto release from RC rev #{rev} (app rev #{rev_app}) on #{now} DO NOT MODIFY'`
    end

    desc <<-DESC
    tag the trunk for RC deployment
    usage: cap rc_from_trunk
    DESC
    task :rc_from_trunk, :roles => :web  do
      rev, rev_app, today, now = get_info('trunk/src/main/krugi')
  
      puts `svn rm #{RC_FULL_PATH} -m 'Remove current release candidate'`
      puts `svn copy https://kroogi/svn/krugi/trunk/src/main/krugi #{RC_FULL_PATH}  -m 'RC from rev #{rev} (app rev #{rev_app}) on #{now}'`
    end
    
  

    desc <<-DESC
    copy the existing tag for patching and RC deployment
    usage:  cap rc_from_tag -s tag=rel-2008-06-04-2278-2249
    DESC
    task :rc_from_tag, :roles => :web  do
      raise 'Need -s tag=bla parameter' unless configuration[:tag]
      # puts `svn info https://kroogi/svn/krugi/tags/#{tag}`
      #       raise 'foo'
      rev, rev_app, today, now = get_info("tags/#{tag}")
  
      puts `svn rm #{RC_FULL_PATH} -m 'Remove current release candidate'`
      puts `svn copy https://kroogi/svn/krugi/tags/#{tag} #{RC_FULL_PATH}  -m 'RC from tag #{tag} rev #{rev} (app rev #{rev_app}) on #{now}'`
    end

    desc <<-DESC
    copy the existing branch for deployment to RC
    usage:  cap rc_from_branch -s branch=experimental_branch
    DESC
    task :rc_from_branch, :roles => :web  do
      raise 'Need -s branch=bla parameter' unless configuration[:branch]
      # puts `svn info https://kroogi/svn/krugi/tags/#{tag}`
      #       raise 'foo'
      rev, rev_app, today, now = get_info("branches/#{branch}")

      puts `svn rm #{RC_FULL_PATH} -m 'Remove current release candidate'`
      puts `svn copy https://kroogi/svn/krugi/branches/#{branch} #{RC_FULL_PATH}  -m 'RC from branch #{branch} rev #{rev} (app rev #{rev_app}) on #{now}'`
    end
  end
end

def get_info(path)
  rev = `svn info https://kroogi/svn/krugi/#{path}`.match(/Last Changed Rev: (.*)/)
  if rev.nil?
    raise "Tag not found at https://kroogi/svn/krugi/#{path}"
  end
  rev_app = `svn info https://kroogi/svn/krugi/#{path}/app`.match(/Last Changed Rev: (.*)/)[1]
  today = Time.now.strftime("%Y-%m-%d")
  now = Time.now.strftime("%Y-%m-%d %H:%M")
  return rev[1], rev_app, today, now
end
    
