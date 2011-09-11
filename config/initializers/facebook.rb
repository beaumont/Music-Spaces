require 'yaml'

FACEBOOK_CONFIG   = YAML.load_file(RAILS_ROOT + '/config/facebooker.yml')[RAILS_ENV].symbolize_keys
FB_CONNECT_CONFIG = YAML.load_file(RAILS_ROOT + '/config/facebook_connect.yml')[RAILS_ENV].symbolize_keys
