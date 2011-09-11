Capistrano::Configuration.instance(true).load do
    namespace :deploy do
        desc <<-DESC
        Restart all the Mongrel processes on the app server.
        DESC
        task :restart, :roles => :app do
            sudo "/usr/sbin/monit -c /etc/monit/monitrc -g mongrels restart all"
        end
        desc <<-DESC
        Start all the Mongrel processes on the app server.
        DESC
        task :start, :roles => :app do
            sudo "/usr/sbin/monit -c /etc/monit/monitrc -g mongrels start all"
        end
        desc <<-DESC
        Stop all the Mongrel processes on the app server.
        DESC
        task :stop, :roles => :app do
            sudo "/usr/sbin/monit -c /etc/monit/monitrc -g mongrels stop all"
        end
        desc <<-DESC
        Start all the Mongrel processes on the app server.
        DESC
        task :spinner, :roles => :app do
            sudo "/usr/sbin/monit -c /etc/monit/monitrc -g mongrels start all"
        end
        desc <<-DESC
        Turn the monitoring off for mongrels
        DESC
        task :unmonitor, :roles => :app do
            sudo "/usr/sbin/monit -c /etc/monit/monitrc -g mongrels unmonitor all"
        end
        desc <<-DESC
        Turn the monitoring back on for mongrels
        DESC
        task :monitor, :roles => :app do
            sudo "/usr/sbin/monit -c /etc/monit/monitrc -g mongrels monitor all"
        end
    end
end