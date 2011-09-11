require 'web_money'
require 'yaml'

WEBMONEY_CONFIG = YAML.load(ERB.new(File.read(File.join(RAILS_ROOT, 'config', 'webmoney.yml'))).result(binding))[RAILS_ENV].symbolize_keys
WebMoney::Ext::Client.config = WebMoney::Ext::Config.new( WEBMONEY_CONFIG )
