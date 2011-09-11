ActiveRecord::Base.class_eval do
  # set base globalize stuff so that validations pass for the english version
  # if you create a post in another language,
  # ya dig?
  def self.set_base_locale_defaults_before_validation
    class_eval do
      # before_validation :set_base_locale_defaults_before_validation
      def set_base_locale_defaults_before_validation
        # (self.class.globalize_facets + self.class.try(:globalize_facet_accessors, [])).each do |facet|
        #   next unless self.respond_to?("#{facet}_ru")
        #   val = self.send("_#{facet}")
        #   val = self.send("#{facet}_ru") if self.send("_#{facet}").blank?
        #   val = self.send("#{facet}_ru")  if (self.send("#{facet}_ru") == self.send("_#{facet}"))
        #   
        #   self.send("_#{facet}=", val)
        # end
      end
      protected(:set_base_locale_defaults_before_validation)
    end
  end
end