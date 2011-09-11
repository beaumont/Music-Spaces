require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MonetaryWithdrawal do
  
  before(:each) do
    @as = account_settings(:chief)
    @as.update_attribute(:balance_usd, 30.00)
    @valid_attributes = {
      :receiver => @as,
      :currency => 'usd',
      :gross_amount => 20.00,
      :monetary_processor => monetary_processors(:paypal)
    }
  end

  it "should create a new instance given valid attributes" do
    MonetaryWithdrawal.create!(@valid_attributes)
  end

  # No peeping toms 
  # it "should negate the users available balance" do
  #   AccountSetting.with_observers(:monetary_transaction_observer) do
  #     m = MonetaryWithdrawal.create!(@valid_attributes)
  #     @as.balance_usd.should eql(10.00)
  #   end
  # end
  
  it "should not let the user take out more than they have" do
    lambda do
      m = MonetaryWithdrawal.create!(@valid_attributes.merge(:gross_amount => 30.01))
    end.should raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Receiver does not have enough funds available')
  end
  
  it "should be able to set a handling fee for withdrawals" do
    m = MonetaryWithdrawal.new(@valid_attributes)
    m.stub!(:billable?).and_return(true)
    m.stub!(:handling_fee_percent).and_return(10)
    m.save!
    m.net_amount_usd.should eql(20.00)
    m.handling_fee_usd.should eql(2.00)
    m.payable_amount_usd.should eql(18.00)
  end
  
  it "should not allow someone to create negative withdrawals" do
    m = MonetaryWithdrawal.new(@valid_attributes.merge(:gross_amount => -5.00))
    m.should_not be_valid
  end
end
