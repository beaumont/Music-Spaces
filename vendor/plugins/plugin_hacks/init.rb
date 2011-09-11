# Include hook code here
require "awesome_nested_set_hack"
require "attachment_fu_hack"
ActiveRecord::Base.send(:extend, Technoweenie::AttachmentFu::HackedActMethods)
require "globalize_hack"
require "xss_terminate_hack"
require 'exception'

ActionMailer::Base #make sure it's loaded before the patch
require File.join(File.dirname(__FILE__), 'lib', 'action_mailer', 'base')

require File.join(File.dirname(__FILE__), 'lib', 'active_support', 'buffered_logger') 

require File.join(File.dirname(__FILE__), 'lib', 'action_controller', 'cgi_process') 

require File.join(File.dirname(__FILE__), 'lib', 'active_record', 'base') 
require File.join(File.dirname(__FILE__), 'lib', 'active_record', 'validations') 
