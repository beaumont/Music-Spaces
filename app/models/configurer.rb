class Configurer
  # TODO: move these to Configuration model and get rid of class vars
  
  def initialize(settings) 
    @@settings = settings.reverse_merge({
            :legacy_id_hash_secret => RAILS_ENV,
            :smscoin => {:purse_id => 8201, :secret => 'dfdfgzsd'},
            :env_id => RAILS_ENV, 
            :kroogi_hosts => { #this is currently used to route YM postbacks to right hosts from Prod, so the whole list is needed 
                    :artemv => 'http://212.59.110.245:3000',
                    :ksu => 'http://your-net-works.org:3001',
                    :staging => 'http://brainmaggot.org',
                    :rc => 'http://brainmaggot.net',
                    :production => 'http://kroogi.com',
                    },
            :movable_disabled => true,
            :hide_select_all_for_what_you_like_widget => true,
            :multiple_tracks_uploader_enabled => true,
            :enable_site_activity_log => true,
            :instance_caching_for_currency_rates => true,
            }
    )

    @@settings[:default_locale] = 'en'
    
    @@settings[:languages] = {
      'en-US' => 'English',
      'ru-RU' => 'Russian',
      'fr-FR' => 'French'
     }
     
     @@settings[:languages_short] = {
       'en' => 'English',
       'ru' => 'Русский',
       'fr' => 'French'
      }

    @@settings[:languageids] = {1819 => 'en-US', 5556 => 'ru-RU', 1930 => 'fr-FR'}
      
    unless RAILS_ENV == 'development' || RAILS_ENV == 'staging'
      @@settings[:languages].delete('fr-FR')
      @@settings[:languages_short].delete('fr')
      @@settings[:languageids].delete(1930)
    end
    
      
    @@settings[:language_menu] = @@settings[:languages_short].invert

  end

  def locales
    languages_short.keys
  end
  
  def method_missing(methId)
    @@settings.key?(methId.to_sym) ? @@settings[methId.to_sym] : nil
  end
  
  
  def set(variable, value=nil, &block)
   value = block if value.nil? && block_given?
   @@settings[variable.to_sym] = value
  end
  
  alias :[]= :set
  
  def [] (key) 
    @@settings.key?(key.to_sym) ? @@settings[key.to_sym] : nil
  end

  def default_locale?(locale)
    d = default_locale
    raise 'default_locale not set!' if !d
    d == locale
  end

  def external_host_address
    self.kroogi_hosts[env_id.to_sym] if self.env_id
  end

end