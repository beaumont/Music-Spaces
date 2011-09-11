desc "Automates all tasks setting up the db from scratch"
namespace "db" do
    task :initialize => ['db:create', 'globalize:setup'] do
      # This is a little strange, yes, but for some reason migrating the first time fails, but the second succeeds
      # (failure: undefined method `name_context' for #<Preference id: 1, user_id: 1, email_notifications: true> in migration 93)
      puts "\n\n* Ignore the first undefined method `name_context' error -- script will automatically recover\n\n"
      puts `RAILS_ENV=#{RAILS_ENV} rake db:migrate || RAILS_ENV=#{RAILS_ENV} rake db:migrate`
      puts "\n\nDatabase initialized\n\n"
    end
end

namespace :test do
  namespace :fresh do
    desc 'Explicitly clear the test db, and THEN run acceptance tests'
    task :acceptance do
      puts "[ Resetting database ]"
      puts "\t- emptying"
      Rake::Task['db:test:purge'].invoke
      puts "\t- cloning structure"
      Rake::Task['db:test:clone_structure'].invoke
      puts "\t- loading fixtures"
      RAILS_ENV='test'
      Rake::Task['db:fixtures:load'].invoke
    
      puts "[ OK, now running tests ]"
      puts "(don't forget you can do this manually by firing up a server in test env and going to localhost:3001/selenium)"
      Rake::Task['test:acceptance'].invoke
    end
  end
end