ActionController::CgiRequest #load base class
  
module ActionController #:nodoc:
  class CgiRequest
    private
      def stale_session_check!
        yield
      rescue ArgumentError => argument_error
        if argument_error.message =~ %r{undefined class/module ([\w:]*\w)}
          begin
            # Note that the regexp does not allow $1 to end with a ':'
            $1.constantize
          rescue LoadError, NameError => const_error
            log.error <<-end_msg
Session contains objects whose class definition isn\'t available.
Remember to require the classes for all objects kept in the session.
(Original exception: #{const_error.inspect})
end_msg
            return reset_session
          end

          retry
        else
          raise
        end
      end
  end
end
