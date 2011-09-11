require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MonetaryProcessor do
  fixtures :monetary_processors
  
  it "should filter available for donations" do
    list = [monetary_processors(:pseudo), monetary_processors(:paypal), monetary_processors(:webmoney)]
    MonetaryProcessor.available_for_donations.should eql(list)
  end

  it "should filter available for withdrawals" do
    list = [monetary_processors(:pseudo), monetary_processors(:paypal), monetary_processors(:webmoney)]
    MonetaryProcessor.available_for_withdrawals.should eql(list)
  end
  
  it "should have a short name" do
    monetary_processors(:paypal).should respond_to(:short_name)
    monetary_processors(:paypal).short_name.should eql('paypal')
  end

end
