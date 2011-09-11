# == Schema Information
# Schema version: 20081006211752
#
# Table name: configurations
#
#  id          :integer(11)     not null, primary key
#  config_key  :string(255)
#  description :text
#  value       :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Configuration < ActiveRecord::Base
  validates_uniqueness_of :config_key, :message => "must be unique"
  validates_presence_of :config_key, :value
  @@defaults  = (defined?(DefaultConfig) ? DefaultConfig::DEFAULTS : {}).with_indifferent_access
  
  #get the value field, YAML decoded
  def value
    YAML::load(self[:value])
  end

  #set the value field, YAML encoded
  def value=(new_value)
    self[:value] = new_value.to_yaml
  end
  
  # custom error class
  class ConfigNotFound < RuntimeError; end
  
  class << self
    
    def config_value(name, default)
      cattr_accessor name
      self.send("#{name}=", default)
    end
        
    #get or set a variable with the variable as the called method
    def method_missing(method, *args)
      method_name = method.to_s
      super(method, *args)
    
    rescue NoMethodError
      if method_name[-1..-1] == '='
        #set a value for a variable
        var_name = method_name.gsub('=', '')
        value = args.first
        self[var_name] = value
      else
        #retrieve a value
        self[method_name]
      end
    end
    
    #destroy the specified settings record
    def destroy(var_name)
      var_name = var_name.to_s
      if self[var_name]
        object(var_name).destroy
        true
      else
        raise ConfigNotFound, "Setting config key \"#{var_name}\" not found"
      end
    end
  
    #retrieve all settings as a hash
    def all
      vars = find(:all, :select => 'config_key, value')
    
      result = {}
      vars.each do |record|
        result[record.var] = record.value
      end
      result.with_indifferent_access
    end
    
    #retrieve a setting value by [] notation
    def [](var_name)
      #retrieve a setting
      var_name = var_name.to_s
    
      if config = object(var_name)
        config.value
      elsif config = class_variable_get("@@#{var_name}") 
        config
      else
        nil
      end
    rescue NameError
      nil
    end
  
    #set a setting value by [] notation
    def []=(var_name, value)
      var_name = var_name.to_s
    
      record = object(var_name) || self.new(:config_key => var_name)
      record.value = value
      record.save
    end
  
    #retrieve the actual Setting record
    def object(var_name)
      find_by_config_key(var_name.to_s)
    end
    
    def reload # :nodoc:
      self
    end
  end
    
  config_value "default_donation_message", %{All the content you see on this Kroogi was created by %s. If you like it and would like to support the artist, your contribution will be appreciated.}
  
  config_value "default_language_options", {1819 => 'en-US', 5556 => 'ru-RU', 1930 => 'fr-FR'}
end
