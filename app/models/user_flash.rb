#Kinda cross-domain flash
class UserFlash < ActiveRecord::Base
  serialize :data
  
end
