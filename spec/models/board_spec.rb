require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/shared_content_spec'

describe Board do
  before(:each) do
    @board = Board.new(:user_id => 5)
     user = mock(User)
     @account_setting = mock_model(AccountSetting, :paypal_email => nil)
     user.stub!(:account_setting).and_return(@account_setting)
     user.stub!(:private?).and_return(false)
     @board.stub!(:user).and_return(user)
     @content = @board
    
    Locale.set("en")
  end
  
  it_should_behave_like "Content in general"
  it_should_behave_like "Content being translated"
  it_should_behave_like "Content that receives donations"
  
  it "should have an announcement when initialized" do
    @board.announcement.should_not be_nil
  end
    
  describe "trying to accept donations" do
    
    it "should require paypal or web money if show donations is checked" do
       @account_setting.should_receive(:has_an_approved_account_set?).at_most(3).times.and_return(false)
       @board.show_donation_button = true
       @board.should_not be_valid
       @board.errors.on_base.should eql("You need to set up PayPal or Webmoney in your account in order to allow contributions!")
       @board.should_not be_donatable
       pending "TODO: fix the spec"
       @board.should_not have_an_account_set
    end
    
    it "should allow donations to be set" do
      @account_setting.should_receive(:has_an_approved_account_set?).any_number_of_times.and_return(true)
      @account_setting.should_receive(:money_approved?).any_number_of_times.and_return(true)
      @board.show_donation_button = true
      @board.can_have_prices_set?.should be_true
      @board.should be_valid
      @board.should be_donatable
    end
    
    it "should allow a :reason_for_kroogi_pass in all languages" do
      @board.reason_for_kroogi_pass = "because you need it, fool."
      @board.without_monitoring do
        @board.save.should be_true
      end
    end
  end
end
