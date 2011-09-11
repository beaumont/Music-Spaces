require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PaypalAccount do
  before(:each) do
    @valid_attributes = {
      :account_setting_id => 1,
      :account_identifier => 'user@paypal.com'
    }
    Thread.current['user'] = users(:chief)
  end

  it "should create a new instance given valid attributes" do
    a = PaypalAccount.create!(@valid_attributes)
    a.should be_unverified
    a.verify!
    a.should be_verified
  end
end
