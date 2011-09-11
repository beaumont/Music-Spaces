require "globalize_hack/virtual_attribute_translation"
require "globalize_hack/set_defaults"

module Globalize
  module Model
    module ActiveRecord
      module Translated
        module ActMethods
          # def translates(*attr_names)
          #   options = attr_names.extract_options!
          #   options[:translated_attributes] = attr_names
          # 
          #   # Only set up once per class
          #   unless included_modules.include? InstanceMethods
          #     class_inheritable_accessor :globalize_options, :globalize_proxy
          #     
          #     include InstanceMethods
          #     extend  ClassMethods
          #     alias_method_chain :reload, :globalize
          #     
          #     after_save :update_globalize_record
          #   end
          # 
          #   self.globalize_options = options
          #   Globalize::Model::ActiveRecord.define_accessors(self, attr_names)
          #   
          #   # Import any callbacks that have been defined by extensions to Globalize2
          #   # and run them.
          #   extend Callbacks
          #   Callbacks.instance_methods.each {|cb| send cb }
          # end
          
          def translates(*facets)
            
            # parse out options hash
            options = facets.extract_options!
            options.reverse_merge!({:base_as_default => false})
            options[:translated_attributes] = facets
            
            # include InstanceMethods
            extend ClassMethods
            # extend RedoMM
            # alias_method_chain :reload, :globalize
            class_eval do
              @@globalize_options = options
              cattr_reader :globalize_options
            end
            translate_internal(facets, options)
          end
          
          # get rid of the other method_missing
          # module RedoMM
          #   def method_missing(meth, *args, &blk)
          #     super
          #   end
          # end
          
          protected
          def translate_internal(facets, options)
            facets_string = "[" + facets.map {|facet| ":#{facet}"}.join(", ") + "]"
            class_eval <<-RUBY, "__(TRANSLATE_INTERNAL)__", 61
              class_inheritable_accessor :facet_options, :globalize_facets
              self.facet_options = {}
              self.globalize_facets = #{facets_string}

              class << self              

                #Returns the localized column name of the supplied attribute for the
                #current locale
                #
                #Useful when you have to build up sql by hand or for AR::Base::find conditions
                #
                #  e.g. Product.find(:all , :conditions = ["\#{Product.localized_facet(:name)} = ?", name])
                #
                # Note: <i>Used when Globalize::DbTranslate.keep_translations_in_model is true</i>
                def localized_facet(facet)
                  unless I18n.base_locale?
                    "\#{facet}_\#{I18n.language_code}"
                  else
                    facet.to_s
                  end
                end

                alias_method :globalize_old_method_missing, :method_missing unless
                  respond_to? :globalize_old_method_missing
              end

              def globalize_facets_hash
                self.globalize_facets_hash ||= self.class.globalize_facets.inject({}) {|hash, facet|
                  hash[facet.to_s] = true; hash
                }
              end

              def non_localized_fields
                @@non_localized_fields ||=
                  column_names.map {|cn| cn.intern } - globalize_facets
              end

              #Is field translated?
              #Returns true if translated
              #Warning! Depends on Locale.switch_locale
              def translated?(facet, locale_code = nil)
                localized_method = "\#{facet}_\#{I18n.language_code}"

                ::Locale.switch_locale(locale_code) do
                  localized_method = "\#{facet}_\#{I18n.language_code}"
                end if locale_code

                value = send(localized_method.to_sym) if respond_to?(localized_method.to_sym)
                return !value.blank?
              end

              # extend  Globalize::DbTranslate::InternalStorageClassMethods
            RUBY

            facets.each do |facet|
              bidi = (!(options[facet] && !options[facet][:bidi_embed])).to_s
              class_eval  <<-RUBY, "__(TRANSLATE_INTERNAL)__", __LINE__

                #Handle facet-specific options (.e.g a bidirectional setting)
                self.facet_options[:#{facet}] ||= {}
                self.facet_options[:#{facet}][:bidi] = #{bidi}

                #Accessor that proxies to the right accessor for the current locale
                def #{facet}
                  value = nil
                  if I18n.base_locale?
                    value = read_attribute(:#{facet})
                    value = send("#{facet}_ru") if  value.blank?
                  else
                    localized_method = "#{facet}_\#{I18n.language_code}"
                    value = send(localized_method.to_sym) if respond_to?(localized_method.to_sym)
                    value = !value.blank? ? value : read_attribute(:#{facet}) if #{options[:base_as_default]}
                  end
                  value.nil? ? nil : add_bidi(value, :#{facet})
                end

                #Accessor before typecasting that proxies to the right accessor for the current locale
                def #{facet}_before_type_cast
                  unless I18n.base_locale?
                    localized_method = "#{facet}_\#{Locale.language.code}_before_type_cast"
                    value = send(localized_method.to_sym) if respond_to?(localized_method.to_sym)
                    value = value ? value : read_attribute_before_type_cast('#{facet}') if #{options[:base_as_default]}
                    return value
                  else
                    value = read_attribute_before_type_cast('#{facet}')
                  end
                  value.nil? ? nil : add_bidi(value, :#{facet})
                end

                #Write to appropriate localized attribute
                def #{facet}=(value)
                  unless I18n.base_locale?
                    localized_method = "#{facet}_\#{I18n.language_code}"
                    write_attribute(localized_method.to_sym, value) if respond_to?(localized_method.to_sym)
                  else
                    write_attribute(:#{facet}, value)
                  end
                end

                #Is field translated?
                #Returns true if untranslated
                def #{facet}_is_base?
                  localized_method = "#{facet}_\#{I18n.language_code}"
                  value = send(localized_method.to_sym) if respond_to?(localized_method.to_sym)
                  return value.nil?
                end

                #Read base language attribute directly
                def _#{facet}
                  value = read_attribute(:#{facet})
                  value.nil? ? nil : add_bidi(value, :#{facet})
                end

                #Read base language attribute directly without typecasting
                def _#{facet}_before_type_cast
                  read_attribute_before_type_cast('#{facet}')
                end

                #Write base language attribute directly
                def _#{facet}=(value)
                  write_attribute(:#{facet}, value)
                end
                
                alias_attribute :#{facet}_en, :_#{facet}
                
                def add_bidi(value, facet)
                  # return value unless Locale.active?
                  # value.direction = self.send("\#{facet}_is_base?") ?
                  #   (Locale.base_language ? Locale.base_language.direction : nil) :
                  #   (Locale.active ? Locale.language.direction : nil)
                  # 
                  #   # insert bidi embedding characters, if necessary
                  #   if self.facet_options[facet][:bidi] &&
                  #       Locale.language && Locale.language.direction && value.direction
                  #     if Locale.language.direction == 'ltr' && value.direction == 'rtl'
                  #       bidi_str = "\xe2\x80\xab" + value + "\xe2\x80\xac"
                  #       bidi_str.direction = value.direction
                  #       return bidi_str
                  #     elsif Locale.language.direction == 'rtl' && value.direction == 'ltr'
                  #       bidi_str = "\xe2\x80\xaa" + value + "\xe2\x80\xac"
                  #       bidi_str.direction = value.direction
                  #       return bidi_str
                  #     end
                  #   end
                    return value
                end

                protected :add_bidi
              RUBY
            end
          end
          
        end
      end
    end
  end
end
ActiveRecord::Base.send(:include, Kroogi::VirtualAttributeTranslation)
