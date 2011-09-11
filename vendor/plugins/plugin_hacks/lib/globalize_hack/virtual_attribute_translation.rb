module Kroogi
  # ability to set translates_virtual_attribute :explanation and call instance.explanation to get different db_store values depending on 
  # currently set locale (Globalize)
  module VirtualAttributeTranslation

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # protected
      def translates_virtual_attribute(*args)
        begin
        class_eval do
          # Explicit for each language (needed for translation)
          @@lang_cols_avail = column_names.collect{|x| x.match(/db_store_\w\w_id/) ? x.match(/db_store_(\w\w)/)[1] : nil}.compact
          options = args.last.is_a?(Hash) ? args.pop : {}
          @@globalize_facet_accessors = args
          class << self
            def globalize_facet_accessors
              @@globalize_facet_accessors
            end
          
            def lang_cols_avail
              @@lang_cols_avail
            end            
          end
          
          globalize_facet_accessors.each do |field|
            # base accessor
            belongs_to "#{field}_db_store", :class_name => 'DbStore'
            before_save "save_#{field}_db_store"
            
            lang_cols_avail.each do |lang|
              # set relationship
              belongs_to "#{field}_db_store_#{lang}", :class_name => 'DbStore'
              before_save "save_#{field}_#{lang}_db_store"
              
              define_method "#{field}_#{lang}".to_sym do
                return nil unless self.send("#{field}_db_store_#{lang}")
                self.send("#{field}_db_store_#{lang}").content
              end
          
              define_method "#{field}_#{lang}=".to_sym do |data|
                store = self.send("#{field}_db_store_#{lang}")
                if store.nil?
                  new_store = DbStore.create(:content => data)
                  write_attribute("#{field}_db_store_#{lang}_id", new_store.id)
                else
                  store.update_attribute(:content, data)
                end
              end
              
              define_method "#{field}_#{lang}_before_type_cast" do
                store = self.send("#{field}_db_store_#{lang}")
                store.try(:content)
              end
              
              define_method "save_#{field}_#{lang}_db_store" do
                self.send("#{field}_db_store_#{lang}").save if self.send("#{field}_db_store_#{lang}")
              end
              protected("save_#{field}_#{lang}_db_store")
              
            end # end lang_cols_avail.each
            
            define_method "save_#{field}_db_store" do
              self.send("#{field}_db_store").save if self.send("#{field}_db_store")
            end
            
            protected("save_#{field}_db_store")        
          
            ## Single methods to call to return differently based on locale (fill in for broken globalize)
            # This should be all the magic we need, but the admin translation console need to be able to get and set
            # across all languages explicitly. Bleck. Hence the above doublehack.
        
            # Accessor
            define_method field.to_sym do 
              if !I18n.base_locale? && self.respond_to?("#{field}_db_store_#{I18n.language_code}")
                val = self.send("#{field}_#{I18n.language_code}")
                val = self.send("_#{field}") if options[:base_as_default] && val.blank?
                val
              else
                val = self.send("_#{field}")
                val = self.send("#{field}_ru") if val.blank?
              end
              val
            end
                        
            # Setter
            define_method "#{field}=".to_sym do |data|
              if !I18n.base_locale? && self.respond_to?("#{field}_db_store_#{I18n.language_code}")
                store = self.send("#{field}_db_store_#{I18n.language_code}")
                if store.nil?
                  new_store = DbStore.create(:content => data)
                  write_attribute("#{field}_db_store_#{I18n.language_code}_id", new_store.id)
                else
                  store.update_attribute(:content, data)
                end
              else
                send("_#{field}=", data)
              end
            end
            
            define_method "#{field}_before_type_cast" do
              #store = self.send("#{field}_db_store")
              #store.try(:content)
              self.send(field)
            end
            
            define_method "_#{field}" do
              return nil unless self.send("#{field}_db_store")
              self.send("#{field}_db_store").content
            end
            
            define_method "_#{field}=" do |data|
              store = self.send("#{field}_db_store")
              if store.nil?
                new_store = DbStore.create(:content => data)
                write_attribute("#{field}_db_store_id", new_store.id)
              else
                store.content = data
              end
            end
            
            alias_method "#{field}_en", "_#{field}"
            alias_method "#{field}_en=", "_#{field}="
            
            # def translated?(facet, locale_code = nil)
            #   localized_method = "\#{facet}_\#{Locale.language.code}"
            # 
            #   Locale.switch_locale(locale_code) do
            #     localized_method = "\#{facet}_\#{Locale.language.code}"
            #   end if locale_code
            # 
            #   value = send(localized_method.to_sym) if respond_to?(localized_method.to_sym)
            #   return !value.nil?
            # end
          end # end globalize_facet_accessors.each
          
        end # class_eval
        rescue ActiveRecord::StatementInvalid => e
          puts "Exception #{e.class.name}: #{e}. probably we're in migration."
        end
      end # translates_virtual_attribute
    end # ClassMethods

  end
end