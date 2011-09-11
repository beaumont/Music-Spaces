ActiveRecord::Base.class_eval do
  class << self
    alias_method :old_xss_terminate, :xss_terminate
    
    def xss_terminate(options = {})
      cols = column_names.grep(/_(fr|ru)/)
      except = (options[:except] || []).collect { |field| v = cols.grep(/#{field.to_s}/); v unless v.empty? }.compact.flatten
      (options[:except] ||= []) << except.collect(&:to_sym)
      options[:except].flatten!
      old_xss_terminate(options)
    rescue StandardError => e
      logger.error e
    end
  end
end
