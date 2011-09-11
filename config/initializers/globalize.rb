include Globalize

# extend locale module
module Locale
  class << self; delegate(:with_locale, :switch_locale, :to => I18n);end
  
  AVAILABLE_LOCALES = ['en', 'ru']
  
  def set(val)
    # ::ActiveSupport::Deprecation.warn("Locale#set is gone! Please change to I18n.locale = 'locale'",caller)
    if AVAILABLE_LOCALES.include?(val.to_s[0..1])
      I18n.locale = val.to_s[0..1]
    end
  end
  module_function :set

  def language
    Globalize::Language.find_by_iso_639_1(I18n.locale.to_s[0..1])
  end
  module_function :language

end

class GlobalizeTranslation < ActiveRecord::Base 
  set_table_name "globalize_translations" 
  belongs_to :language, :class_name => 'GlobalizeLanguage', :foreign_key => :language_id 
end 

module Globalize

  class ViewTranslation < GlobalizeTranslation 
  end 

  class ModelTranslation < GlobalizeTranslation 
  end 

  class Language < ActiveRecord::Base
    set_table_name "globalize_languages"
    has_many :translations, :class_name => 'GlobalizeTranslation', :foreign_key => :language_id 
    has_many :user_translations, :class_name => 'GlobalizeTranslation', :foreign_key => :language_id
    
    def code 
      ::I18n.language_code
    end
    
  end
end  

# old globalze string stuff
class String 

   def translate(options = {})
     I18n.t self, substitute_interpolation_hash.merge(options.reverse_merge(:default => default_translation))
   end

   alias t translate

   def tdown
     self.t.chars.downcase
   end

   def tup
     self.t.chars.upcase
   end
   
   def tn(namespace) 
     I18n.t self, :scope => namespace, :default => default_translation 
   end 

   def /(val) 
     I18n.t self, substitute_interpolation_hash(val).merge(:default => default_translation)
   end
   
   protected

   def default_translation
     default = self.dup
     if default =~ /\(\((.*)\)\)/
       match = $1
       default["((#{match}))"] = ''
       default.strip!
     end
     default
   end

   def substitute_interpolation_hash(*ary)
    i, l = 0, "a"
    h = {}
    ary = ary.flatten
    if ary[0].is_a?(Hash)
      h = ary[0]
      ary = nil
    end
    scan(/%d|%s|\{\{\w+\}\}/) do |m|
      key = "s#{l}"
      key = m[2..-3] if m.starts_with?('{{')
      key = "count" if m == "%d" 

      match = /(?:(start|end)_(\w+))/.match(key)
      if match
        tag = match[2]
        val = (match[1] == 'start' ? "<#{tag}>" : "</#{tag}>") 
      end
      if ary && !val
        val = ary[i]
        i += 1
      end
      val ||= ""
      
      h[key.to_sym] ||= val
      l.next!
    end
    h
   end
end

# make a backend for I18n to use that works like old globalize
module I18n 

   class << self
          
     # A wrapper to execute the passed block in the specified locale
     def with_locale(loc, &block)
       begin
         prev_locale = I18n.locale
         begin
           Locale::set(loc)
         rescue
           I18n.locale = prev_locale
         end

         return block.call
       ensure
         (I18n.locale = prev_locale) unless I18n.locale == prev_locale
       end
     end
     alias_method :switch_locale, :with_locale

     def with_default_locale(&block)
       with_locale(APP_CONFIG.default_locale, &block)
     end
     
     def base_locale?
       locale.to_s[0..1] == default_locale.to_s[0..1]
     end

     def language_code
       locale.to_s[0..1]
     end

     protected 
     
       # Merges the given locale, key and scope into a single array of keys. 
       # Splits keys that contain dots into multiple keys, but only if the 
       # key is not a built-in translation. 
       # Makes sure all keys are Symbols. 
       def normalize_translation_keys(locale, key, scope) 
         keys = [locale] + Array(scope) + [key] 
         keys = keys.map do |k|
           k = k.to_s
           k['..'] ? k : k.split(/\./) #don't split strings containing '..'
         end
         result = keys.flatten.map{|k| k.to_sym} 
         unless [:date, :time, :support, :number, :datetime, :activerecord, :pluralize].include?(result[1])
           result = [result[0], :sql, (Array(scope).collect{|k| k.to_sym}), key.to_sym].flatten 
         end 
         result 
       end 

   end 


   module Backend 
     class Globalize < Advanced

       def reload!
         #We know it's expensive and it's called too often by code we don't want to control. So let's just deny reloading here.
       end

       def default(locale, default, options = {})
         return default if default.is_a?(Proc)
         super
       end

       protected

         def init_translations
           load_translations(*I18n.load_path)
           load_globalize_translations
           @initialized = true
         end

         def load_globalize_translations(options = {})
           all_trannies = ViewTranslation.all(:conditions => ['tr_key != ? and text != ? and text != ?', '', '', 'dnr'], :order => 'language_id, tr_key, pluralization_index')
           trannies_by_lang_id = all_trannies.group_by {|tr| tr.read_attribute(:language_id)} 
           [:en, :ru, :fr].each do |locale|
             translations[locale] = {} if options[:clean_existing]
             lang = Globalize::Language.find_by_iso_639_1(locale.to_s)
             next if !lang #for Test env
             all = trannies_by_lang_id[lang.id] || []
             all.each_with_index do |tr, index|
               next unless ((translations[locale] || {})[:sql] || {})[tr.tr_key.to_sym].blank? #the cycle will have all pluralization variants for single key
               data = { :sql => { tr.tr_key.to_sym => maybe_load_pluralized(tr, all, index)} }
               merge_translations(locale, data) 
             end 
           end
         end 

         def maybe_load_pluralized(tr, all, start)
           texts_hash = {}
           tr_forms = []
           index = start 
           while all[index] && all[index].tr_key == tr.tr_key
             p = all[index]
             idx = {1 => :one, 2 => :few, 3 => :many}[p.pluralization_index]
             texts_hash.merge!(idx => p.text)
             index += 1
           end
           return tr.text if texts_hash.size == 1
           few = texts_hash[:few]
           texts_hash.reverse_merge!(:many => few, :other => few) if few #for English we only set '2' == :few in the table for pluralized; and I18n asks :other
           texts_hash
         end
         
         def interpolate(locale, string, values = {})
           return string unless string.is_a?(String)

           l = "a"
           string = string.gsub(/%d|%s/) do |s|
             # instead = DEPRECATED_INTERPOLATORS[s]
             instead = (s == '%d') ? "{{count}}" : "{{s#{l}}}"
             l.next!

             ActiveSupport::Deprecation.warn "[HEY] using #{s} in messages is deprecated; use #{instead} instead. String was '#{string}'"
             instead
           end unless string.index(/%m|%y|%Y|%b|%B/)

           interpolate_without_deprecated_syntax(locale, string, values)
         end

         
     end 
   end 
end 

I18n.backend = I18n::Backend::Globalize.new

# This makes date fallbacks work properly, but breaks everything else
# I18n.backend = Globalize::Backend::Static.new

# still gotta use I18n yml or rb files for shit
LOCALES_DIRECTORY = File.join(RAILS_ROOT, 'config', 'locales') 
LOCALE_FILES = Dir[ File.join(LOCALES_DIRECTORY, '*.{rb,yml}') ] 
# 
LOCALES = LOCALE_FILES.collect do |locale_file| 
   File.basename(File.basename(locale_file, ".rb"), ".yml")
end.uniq.sort 
# 


I18n.load_path += LOCALE_FILES 

I18n.default_locale = 'en' 

require 'globalize/i18n/missing_translations_log_handler'
I18n.missing_translations_logger = Logger.new(File.join(Rails.root,'log','trans.log'))
I18n.exception_handler = :missing_translations_log_handler
