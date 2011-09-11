PAYPAL_CONFIG = YAML.load(ERB.new(File.read(File.join(RAILS_ROOT, 'config', 'paypal.yml'))).result(binding))[RAILS_ENV].symbolize_keys!
