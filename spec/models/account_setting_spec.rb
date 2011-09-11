require File.dirname(__FILE__) + '/../spec_helper'

describe AccountSetting do
  include AccountSettingSpecHelper
  
  before(:each) do
    @account_setting = AccountSetting.new
    @user = mock_model(User, :id => 1, :display_name => "John Travolta")
    @account_setting.stub!(:user).and_return(@user)
    @account_setting.stub!(:money_status).and_return(:approved)
    @account_setting.stub!(:notify_of_account_changes).and_return(:true)
    I18n.locale = 'en'
  end
  
  describe "modular money handling" do
    
    it "should provide all gross donations received in the past 30 days" do
      account_settings(:chief).gross_donations_received_since(30.days.ago).to_f.should eql(7.00)
    end
    
    it "should provide all gross withdrawals in the past 30 days" do
      account_settings(:chief).gross_withdrawals_since(30.days.ago).to_f.should eql(4.00)
    end
    
    it "should provide related pending donations" do
      account_settings(:chief).donations_received.pending.should include(monetary_transactions(:joe_donates_to_chiefs_album_again))
    end
    
    it "should provide related applied donations" do
      account_settings(:chief).donations_received.applied.should include(monetary_transactions(:joe_donates_to_chiefs_album))
    end
    
  end
  
  describe "in general" do
    
    it "should accept donation_setting methods" do
      @account_setting.amount_usd = 5
      @account_setting.amount_wme = 50
      @account_setting.save
      @account_setting.amount_usd.should == 5
      @account_setting.amount_wme.should == 50
      
      # change by params
      @account_setting.attributes = { :amount_usd => 30, :amount_wme => 20 }
      @account_setting.save
      @account_setting.amount_usd.should == 30
      @account_setting.amount_wme.should == 20
    end
    
    describe "Requiring Passwords" do
      before(:each) do      
        @user.stub!(:authenticated?).and_return(:true)
        @user.stub!(:is_self_or_owner?).and_return(:true)
        @account_setting.stub!(:new_record?).and_return(false)
      end
      
      after(:each) do
        @account_setting.validate_password(@user, "blah")
        @account_setting.save
        @account_setting.errors_on(:paypal_email).should be_empty
        @account_setting.errors_on(:webmoney_wme).should be_empty
        @account_setting.errors_on(:webmoney_wmz).should be_empty
        @account_setting.errors_on(:webmoney_wmr).should be_empty
        @account_setting.errors_on(:webmoney_account).should be_empty
      end
      
      it "should require a password to change paypal_email setting" do
        @account_setting.paypal_email = "foo@money.com"
        @account_setting.should_not be_valid
        @account_setting.errors_on(:paypal_email).should include("requires your Kroogi password in order to be changed.")
      end
      
      it "should require a password to change webmoney_wme" do
        @account_setting.webmoney_wme = webmoney_attributes[:webmoney_wme]
        @account_setting.should_not be_valid
        @account_setting.errors_on(:webmoney_wme).should include("requires your Kroogi password in order to be changed.")    
      end

      it "should require a password to change webmoney_wmr" do
        @account_setting.webmoney_wmr = webmoney_attributes[:webmoney_wmr]
        @account_setting.should_not be_valid
        @account_setting.errors_on(:webmoney_wmr).should include("requires your Kroogi password in order to be changed.")    
      end

      it "should require a password to change webmoney_wmz" do
        @account_setting.webmoney_wmz = webmoney_attributes[:webmoney_wmz]
        @account_setting.should_not be_valid
        @account_setting.errors_on(:webmoney_wmz).should include("requires your Kroogi password in order to be changed.")    
      end

      it "should require a password to change webmoney_account" do
        @account_setting.webmoney_account = '123123123123'
        @account_setting.should_not be_valid
        @account_setting.errors_on(:webmoney_account).should include("requires your Kroogi password in order to be changed.")    
      end
      
      it "should only set a single password requirement for any set of fields" do
        @account_setting.webmoney_wmr = webmoney_attributes[:webmoney_wmr]
        @account_setting.webmoney_wme = webmoney_attributes[:webmoney_wme]
        @account_setting.should_not be_valid
        @account_setting.errors.size.should eql(1)
      end
    
      it "should not validate password for empty fields" do
        @account_setting.stub!(:new_record?).and_return(false)
        @account_setting.paypal_email = "joe@paypal.com"
        # @account_setting.stub!(:password_validated).and_return(:false)
        # @user.stub!(:authenticated?).and_return(:false)
        @account_setting.should_not be_valid
        @account_setting.errors_on(:paypal_email).should_not  be_empty
        @account_setting.errors_on(:webmoney_wmz).should  be_empty
        @account_setting.errors_on(:webmoney_wme).should  be_empty
        @account_setting.errors_on(:webmoney_wmr).should  be_empty
      end
    
      
    end
    
    it "should not validate other donation fields when updating payment systems" do
      @account_setting.stub!(:new_record?).and_return(false)
      @account_setting.paypal_email = "joe@paypal.com"
      @account_setting.stub!(:password_validated?).and_return(:true)
      @account_setting.save
      @account_setting.errors_on(:paypal_email).should  be_empty
    end
  end
  
  describe "accepting donations" do
    before(:each) do
      @account_setting.stub!(:password_validated?).and_return(true)
    end
    
    it "should be donatable if approved/valid with valid a valid account" do
      # paypal email
      @account_setting.show_donation_basket = true
      @account_setting.should_not be_donatable
      # approved with not verified email
      @account_setting.stub!(:money_status).and_return(:money_approved)
      @account_setting.should_not be_donatable
      # approved + verified email
      @account_setting.stub!(:current_monetary_processor_account).and_return('true')
      pending "TODO: fix me"
      @account_setting.should be_donatable
    end
 
    # this is no longer true
    # donations have to be turned off explicitly
    #it "should turn off donations if saved with no approved accounts" do
    #   @account_setting.stub!(:money_status).and_return(:money_approved)
    #   @account_setting.show_donation_basket = true
    #   @account_setting.save
    #   @account_setting.show_donation_basket.should be_false
    #   @account_setting.should_not be_donatable
    #   
    #   # set paypal email
    #   @account_setting.paypal_email = "foo@jones.com"
    #   @account_setting.show_donation_basket = true
    #   @account_setting.stub!(:paypal_status).and_return('verified:foo@jones.com')
    #   @account_setting.should be_valid
    #   @account_setting.should be_donatable
    # 
    #   # reset
    #   @account_setting.paypal_email = nil
    #   @account_setting.save
    #   @account_setting.should_not be_donatable
    #   @account_setting.show_donation_basket.should be_false
    # 
    #   # set web money
    #   @account_setting.attributes = webmoney_attributes
    #   @account_setting.show_donation_basket = true
    #   @account_setting.save
    #   @account_setting.should be_valid
    #   @account_setting.should be_donatable
    #end
  
    it "should validate/confirm email address if it is present" do
      # email empty, don't validate
      @account_setting.paypal_email = ""
      @account_setting.should be_valid
      # set invalid email, validation should run
      @account_setting.paypal_email = "foo@@invalid.com"
      pending "TODO: fix me"
      @account_setting.should_not be_valid
      @account_setting.should have(1).error_on(:paypal_email)
      # @account_setting.should have(1).error_on(:paypal_email_confirmation)
      # set valid email, validations should run
      @account_setting.paypal_email = "foo@valid.com"
      @account_setting.should be_valid
    end
  
    it "should validate webmoney accounts if present" do
      # webmoney empty, don't validate
      @account_setting.webmoney_wmr = ""
      @account_setting.should be_valid
    
      # set invalid webmoney account, validation should run
      @account_setting.webmoney_wmr = "V000000000000"
      pending "TODO: fix the spec (error: too many arguments for format string from validates_format_of)"
      @account_setting.should_not be_valid
      @account_setting.should have(1).error_on(:webmoney_wmr)
    
      # set valid webmoney account, validation should run
      @account_setting.webmoney_wmr = "R000000000000"
      @account_setting.should be_valid
    end
  
    it "should have default donation basket text if none is set" do
      I18n.locale = 'en'
      @account_setting.donation_request_explanation = "Hi, give me money"
      @account_setting.save
      @account_setting.donation_request_explanation.should eql("Hi, give me money")
      @account_setting.donation_request_explanation = nil
      @account_setting.save
      @account_setting.donation_request_explanation.should eql("Please support our project!")
    end
    
    it "should strip spaces from names before validating" do
      @account_setting.webmoney_wmr = " R000000000000 "
      @account_setting.should be_valid
      @account_setting.webmoney_wmr.should eql("R000000000000")
    end
  end
  
  describe "updating waiting period" do
    it "should allow updating the waiting period" do
      @account_setting.update_attribute(:waiting_period, 92)
      @account_setting.waiting_period.should eql(92)
    end
    
    it "should not apply changes in waiting period to pending withdrawals" do
      @oas = monetary_transactions(:joe_donates_to_chiefs_album)
      lambda do
        @as = users(:chief).account_setting
        @donation = monetary_transactions(:joe_donates_to_chiefs_album_again)
        @donation.available_for_balance?.should eql(false)
        @as.waiting_period = 0 ; @as.save! ; @donation.reload
        pending "Josh cannot fix it on CC"
        @donation.available_for_balance?.should eql(false)
      end.should_not change(@oas, :available_at)
    end
    
    it "should support default class level changing of defaults" do
      AccountSetting.default_withdrawal_waiting_period = 80
      AccountSetting.default_withdrawal_waiting_period.should eql(80)
    end
  end
    
  describe "invoice agreements" do
    it "should not be accepted by default" do
      @account_setting.invoice_agreement_accepted?.should eql(false)
    end
    
    it "should be accepted when invoice agreement accepted at is set" do
      @account_setting.invoice_agreement_accepted_at = Time.now
      @account_setting.invoice_agreement_accepted?.should eql(true)
    end
    
    it "should have a handy setter to keep things clean" do
      time = Time.now
      Time.stub!(:now).and_return(time)
      @account_setting.should respond_to(:invoice_agreement_accepted!)
      @account_setting.should_receive(:invoice_agreement_accepted_at=).with(time)
      @account_setting.invoice_agreement_accepted!
    end
  end
end
