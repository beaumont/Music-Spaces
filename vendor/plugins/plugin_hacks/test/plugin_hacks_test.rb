ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")

require File.join(File.dirname(__FILE__), *%w[.. lib xss_terminate_hack])

plugin_path = File.expand_path(File.dirname(__FILE__)+"/../")
config_location = RAILS_ROOT + "/config/database.yml"

config = YAML::load(ERB.new(IO.read(config_location)).result)
log_file = plugin_path + "/test/test.log"
FileUtils.touch(log_file) unless File.exist?(log_file)
ActiveRecord::Base.logger = Logger.new(log_file)
ActiveRecord::Base.establish_connection(config['test'])

# Test::Unit::TestCase.fixture_path = plugin_path + "/test/fixtures/"
# $LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)


class Content < ActiveRecord::Base
  xss_terminate :except => [:description, :owner]
end

class PluginHacksTest < Test::Unit::TestCase
  # Replace this with your real tests.
  def test_xss_terminate
    assert_equal([:description, :owner, :description_ru, :description_fr], Content.xss_terminate_options[:except])
  end
end
