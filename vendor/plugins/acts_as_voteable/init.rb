require 'acts_as_voteable'
require 'vote'
require 'up_vote'
require 'down_vote'

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Voteable)
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Voter)