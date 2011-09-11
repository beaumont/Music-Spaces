require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MonetaryProcessorAccount do
  before(:each) do
    @valid_attributes = {
      
    }
    Thread.current['user'] = users(:chief)
  end

  it "should create a new instance given valid attributes" do
    m = MonetaryProcessorAccount.new(:account_setting_id => 1, :monetary_processor_id => 1)
    m.should be_valid
    m.should be_unverified
    m.verify!
    m.should be_verified
    m.verified_at.should_not be_blank
    m.save
    m.should be_verified
    m.reload
    m.should be_verified
  end
end
