require File.dirname(__FILE__) + '/lib/acts_as_permitted'
ActiveRecord::Base.send( :include, 
  ActsAsPermitted::ModelExtensions
)