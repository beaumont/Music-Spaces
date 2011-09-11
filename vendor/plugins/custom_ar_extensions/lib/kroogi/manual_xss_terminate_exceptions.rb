module Kroogi
  # Manual xss_terminate exceptions. sigh. apparently xss_terminate :except isn't loaded properly
  module ManualXssTerminateExceptions
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def manual_xss_terminate_exclusions(*excludes)
        write_inheritable_attribute(:xss_terminate_options, {
          :except => excludes,
          :html5lib_sanitize => [],
          :sanitize => []
        })
      end
    end
  end
end