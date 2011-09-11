# Include hook code here
require "kroogi/dynamic_content_stat_accessors"
require "kroogi/manual_xss_terminate_exceptions"
require "kroogi/password_challenge"

ActiveRecord::Base.class_eval do 
  include Kroogi::DynamicContentStatAccessors
  include Kroogi::ManualXssTerminateExceptions
  include Kroogi::PasswordChallenge
end
