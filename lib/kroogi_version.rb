module Kroogi #:nodoc:
  module VERSION #:nodoc:
    MAJOR     = 1
    MINOR     = 3
    TINY      = 6
    CODE_NAME = "Here Fishy Fishy"
    
    STRING = [MAJOR, MINOR, TINY].join('.')
  end
  
  @@version = VERSION::STRING + " (#{VERSION::CODE_NAME})"
  @@translation_file = Dir[File.join(RAILS_ROOT, *%w[db translations *])].grep(/[0-9]+/).last
  @@translation_version = @@translation_file[/[0-9]+/]
  @@translation_mtime   = File.stat(@@translation_file).mtime
  mattr_reader :translation_version, :version, :translation_mtime
end

ENV["RAILS_APP_VERSION"] = Kroogi::VERSION::STRING
