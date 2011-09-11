class ActiveRecord::Base
  def new?
    id.nil?
  end

  # returns value of field in current locale without falling back to English
  def localized_field_value(field)
    f = (I18n.locale == 'en' ? "_#{field}" : "#{field}_#{I18n.locale}")
    self.send(f)
  end

  class <<self
    # Transforms attribute key names into a more humane format, such as "First name" instead of "first_name". Example:
    #   Person.human_attribute_name("first_name") # => "First name"
    # This used to be depricated in favor of humanize, but is now preferred, because it automatically uses the I18n
    # module now.
    # Specify +options+ with additional translating options.
    def human_attribute_name(attribute_key_name, options = {})
      defaults = self_and_descendents_from_active_record.map do |klass|
        :"#{klass.name.underscore}.#{attribute_key_name}"
      end
      defaults << options[:default] if options[:default]
      defaults.flatten!
      #we want this to be tried for translation, too
      defaults += [attribute_key_name.humanize.to_sym, attribute_key_name.humanize.titleize.to_sym, attribute_key_name.humanize]
      #defaults << attribute_key_name.humanize
      options[:count] ||= 1

      #example of call: I18n.translate(:"music_contest.title", {:count=>1, :default=>[:"basic_folder_with_downloadables.title",
      #   :"album.title", :"content.title", :"Title"]})
      I18n.translate(defaults.shift, options.merge(:default => defaults))
      #I18n.translate(defaults.shift, options.merge(:default => defaults, :scope => [:activerecord, :attributes]))
    end
  end
end
