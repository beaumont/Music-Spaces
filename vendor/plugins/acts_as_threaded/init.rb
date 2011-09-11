# Include hook code here
require 'acts_as_threaded'
ActiveRecord::Base.send(:include, Randomduck::Acts::Commentable)