require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WebMoneyAccount do
  before(:each) do
    @valid_attributes = {
      :account_setting_id => 1,
      :monetary_processor_id => 1,
      :account_identifier => 'somebody'
    }
  end

  it "should create a new instance given valid attributes" do
    Thread.current['user'] = users(:chief)
    WebMoneyAccount.create!(@valid_attributes)
  end
end
