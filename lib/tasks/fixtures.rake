desc 'Create YAML test fixtures from data in an existing database
Defaults to development DB. Set RAILS_ENV to override.'
namespace :test do
  task	:extract_fixtures  => :environment do
  	sql = "SELECT * FROM %s"
  	skip_tables = ["schema_info", "sessions"]
  	ActiveRecord::Base.establish_connection
  	(ActiveRecord::Base.connection.tables - skip_tables).each do |table_name|
  		i = "000"
  		File.open("#{RAILS_ROOT}/test/fixtures/#{table_name}.yml", 'w') do |file|
  			data = ActiveRecord::Base.connection.select_all(sql % table_name)
  			file.write data.inject({}) {|hash, record|
  				hash["#{table_name}_#{i.succ!}"] = record
  				hash
  			}.to_yaml
  		end
  	end
  end  
end
	
