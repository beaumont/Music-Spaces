require File.dirname(__FILE__) + '/../spec_helper'

describe UserNotifier do
  
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end


end
