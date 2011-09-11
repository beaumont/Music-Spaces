require 'yaml'

YANDEX_CONFIG = YAML.load_file(RAILS_ROOT + '/config/yandex.yml')[RAILS_ENV].symbolize_keys
YANDEX_TEST_PROD_CONFIG = YAML.load_file(RAILS_ROOT + '/config/yandex_test_prod.yml')[RAILS_ENV].symbolize_keys 
