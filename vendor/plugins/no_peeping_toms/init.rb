if "test" == RAILS_ENV
#disable it for observers to run free
#  ActiveRecord::Observer.send :include, NoPeepingToms
end
