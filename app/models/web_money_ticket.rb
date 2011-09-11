# WebMoney requires a unique identifier for every request across
# all services, so we will be using this this to keep track of
# the request number by creating and using a ticket with the id.
# Since there is no sandbox, we have set the increments for ID
# to start at different points so we don't end up with duplicates.
#
# Artem Vasiliev's dev database starts at 10,000
# Artem Levik's Sahi database starts at 1,010,000
# Development starts at  5,000,000
# Staging starts at     10,000,000
# Production starts at 100,000,000
#
class WebMoneyTicket < ActiveRecord::Base
  
  def number
    self.id
  end
  
end
