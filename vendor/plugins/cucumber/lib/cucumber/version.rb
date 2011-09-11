module Cucumber #:nodoc:
  class VERSION #:nodoc:
    MAJOR = 0
    MINOR = 1
    TINY  = 100
    PATCH = 2 # Set to nil for official release

    STRING = [MAJOR, MINOR, TINY, PATCH].compact.join('.')
  end
end
