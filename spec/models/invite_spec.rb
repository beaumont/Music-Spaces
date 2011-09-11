require File.dirname(__FILE__) + '/../spec_helper'

describe Invite do
  before(:each) do
    @invite = Invite.new(:circle_id => 3)
    @kroogi_circle = mock_model(UserKroog, :relationshiptype_id => 3)
    @invite.stub!(:circle).and_return(@kroogi_circle)
  end

  it "should be paid when it's paid" do
    pending("cannot stub this")
    @invite.is_paid?.should_not be_true
    @kroogi_circle.should_receive(:amounts_set).once.and_return([])
    @kroogi_circle.stub!(:amounts_set).with(["amount_usd"])
    
    @invite.without_monitoring{ @invite.save }
    @kroogi_circle.should_receive(:amounts_usd).once.and_return(5.00)
    @invite.is_paid?.should be_true
  end
end
