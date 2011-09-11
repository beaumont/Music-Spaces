module Kroogi
  ENV_SEPARATOR = '/' #by default separator will be symbol not allowed in logins
  KROOGI_ACCOUNT = 'kroogi'
  
  def self.environmental(string, options = {})
    options.reverse_merge!(:separator => ENV_SEPARATOR)
    result = string
    unless RAILS_ENV == 'production'
      result = APP_CONFIG.env_id + options[:separator] + result
    end
    result
  end
end