# Custom Kroogi exceptions

module Kroogi
  class Error < RuntimeError; end
  class NotFound < Error; end
  class NotPermitted < Error; end
  class NothingToSend < RuntimeError; end

  module MovableBroker
    class DefaultMovableBrokerError < Error; end
    class InvalidChecksum < DefaultMovableBrokerError; end
    class NoMatchingPayload < DefaultMovableBrokerError; end
    class UnsupportedEnvironment < DefaultMovableBrokerError; end
  end

  module Money
    class ProcessorError < RuntimeError
      attr_accessor :prefix, :suffix, :suggestion
      def initialize(suffix)
        @suffix = suffix
      end

      def message
        [prefix, suggestion, suffix].compact.join(" ")
      end

      def inspect
        result = message
        result = result + "\n  " + application_backtrace.join("\n  ") if !backtrace.nil?
        result
      end
    end
    
    class ProcessorInternalError < ProcessorError
      attr_reader :user_explanation
      
      def initialize(user_explanation, suffix)
        super(suffix)
        @user_explanation = user_explanation
      end
    end    

    class WithdrawalFailed < ProcessorError
    end
  end
end

class UploadQuotaExceeded < ActiveRecord::RecordInvalid

end

module UploaderErrors
  PERMISSION_DENIED = 'permission_denied'
  REMOTE_STORAGE_ACCESS = 'remote_storage_access_error'
  QUOTA_EXCEEDED = 'quota_would_be_exceeded'
  INVALID_FILE = 'file_is_invalid'
end

