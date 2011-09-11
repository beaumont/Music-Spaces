require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe MonetaryProcessors::PaypalController do  
  include PostBackParamsHelper
  include AccountSettingSpecHelper
  
  describe "http method requirements" do
    it "should not allow GET requests" do
      get :instant_payment_notification
      response.should_not be_success  
    end
    
    it "should allow POST requests" do
      post :instant_payment_notification
      response.should be_success
    end
  end

  describe "Handling PayPal IPN" do
    fixtures :monetary_processor_accounts
    
    before(:each) do
      # stub currency conversion (external request)
      ch = mock(CashHandler::Base)
      ch.stub!(:get).and_return(0.0)
      ch.stub!(:convert).and_return(0.0)
      CashHandler::Base.stub!(:instance).and_return(ch)

      # mocks to the rescue
      @user = mock_model(User, :display_name => "John Travolta", :id => 1, :login => "bigtimejt", :project? => false)
      @preference = mock_model(Preference, :email_locale => nil)
      @account_setting = mock_model(AccountSetting)
      @content = mock_model(Content)
      @user.stub!(:preference).and_return(@preference)
      @account_setting.stub!(:owner).and_return(@user)
      @account_setting.stub!(:user).and_return(@user)
      @params = paypal_postback(Time.now, nil, @account_setting)      
      # url helper
      @ca = {:controller => 'monetary_processors/paypal',
             :action     => 'instant_payment_notification'}
    end
    
    it "should try to create MonetaryDonation from parameters" do

      donation = mock_model(MonetaryDonation)
      donation.should_receive(:invite=)
      donation.should_receive(:add_to_kroogi_circle)
      donation.should_receive(:save).with(false)
      MonetaryDonation.should_receive(:from_paypal_params).with(@params.merge(@ca)).and_return donation
      post :instant_payment_notification, @params
      response.should be_success
    end

    # These actually hit paypal at the moment, need to dry run them.
    #
    # it "should try to activate withdrawal accounts from paypal ipn" do
    #  @params = paypal_postback_activation(Time.now)
    #  DonationProcessors::Paypal::Activation.should_receive(:from_paypal_params).with(@params.merge(@ca))
    #  post :instant_payment_notification, @params      
    # end
    # 
    # it "should activate the account when proper activation" do
    #   @params = paypal_postback_activation(Time.now)
    #   DonationProcessors::Paypal::Activation.valid_paypal_activation?(@params).should eql(true)
    #   PaypalAccount.unverified.find_all_by_account_identifier('jmartin@webwideconsulting.com').size.should eql(1)
    #   #@params.with_indifferent_access[:sender_status].should eql('verified')
    #  post :instant_payment_notification, @params
    # end
  
  end



end