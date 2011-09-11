desc 'Facade task to be run by CruiseControl for checking the build'
namespace :test do
  task	:cc => ['db:migrate', 'test', 'spec'] do
  end  
end
	
