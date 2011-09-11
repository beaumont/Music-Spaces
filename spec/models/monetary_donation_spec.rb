require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MonetaryDonation do
  
  include PostBackParamsHelper  
  include AccountSettingSpecHelper
  
  before(:each) do
    
    @receiver = account_settings(:chief)
    @receiver.update_attribute(:billable, true)
    
    @valid_attributes = {
      :content            => contents(:chiefs_sacred_album),
      :currency           => 'usd',
      :gross_amount       => 50.00,
      :monetary_processor_fee  =>  5.00,
      :monetary_processor          => monetary_processors(:paypal)
    }
    @donation = MonetaryDonation.new(@valid_attributes)    
    @donation.stub!(:handling_fee_percent).and_return(10.0)
    @donation.save!
  end
  
  describe "helpers" do
    it "should provide total contributions" do
      MonetaryDonation.should respond_to(:total_donations)
    end
    
    it "should be able to tell if it is for an album" do
      @donation.album_donation?.should be_true
      @donation.content.should_receive(:is_a?).with(BasicFolderWithDownloadables).and_return(false)
      @donation.album_donation?.should be_false
    end
    
    it "should be notifiable when not for an album and not anonymous" do
      @donation.should_receive(:suspicious?).and_return false
      @donation.should_receive(:album_donation?).and_return false
      @donation.should_receive(:anonymous?).and_return false
      @donation.notifiable_donation_received?.should be_true
    end
    
    it "should provide display api name" do
      @donation.display_payment_api.should eql('PayPal')
    end
    
    it "should calculate the total of all donations" do
      MonetaryDonation.should_receive(:sum).with(:gross_amount_usd).and_return(32.00)
      MonetaryDonation.total_donations.should eql(32.00)
    end
    
  end
  
  describe "anonymity" do
    it "should be anonymous" do
      @donation.should be_anonymous
    end
    
    it "should not be anonymous if there is a related sender" do
      @donation.sender = account_settings(:chief)
      @donation.should_not be_anonymous      
    end
    
  end
  
  describe "generating associations" do
    it "should associate the receiver via the content" do
      @donation.receiver.should eql(account_settings(:chief))
    end
    
    it "should provide a way to associate to a circle" do
      circle = mock_model(UserKroog)
      @donation.should respond_to(:add_to_kroogi_circle)
      @donation.should_receive(:kroogi_circle=).with(circle)
      @donation.add_to_kroogi_circle(circle)
    end
  end
  
  describe "calculating fees and totals" do
    
    it "should calculate a net amount from the gross minus processor" do
      assert_in_delta @donation.net_amount_usd.to_f, 45.0, 0.001
    end
    
    it "should calculate a 10% handling fee of the net donation" do
      @donation.receiver.should be_billable
      @donation.should be_billable
      @donation.handling_fee_usd.to_f.should eql(4.50)
    end

    it "should calculate the payable amount from the net amount minus handling fee" do
      @donation.payable_amount_usd.should eql(40.50)
    end
  end

  describe "calculating availability" do
    it "should store the availability time for the funds" do
      @donation.available_at.should_not be_blank
    end
    
    describe "availability descriptions" do
      it "should not be available if new record" do
        MonetaryDonation.new.availability_reason.should eql('Unavailable')
      end
      
      it "should need a receiver" do
        @donation.receiver = nil
        @donation.availability_reason.should eql('No Receiver')
      end
      
      it "should show that it was already applied" do
        @donation.available_at = 1.day.ago
        @donation.apply_to_balance!
        @donation.availability_reason.should eql('Already Applied')
      end
      
      it "should provide pending state if pending release" do
        @donation.stub!(:available_at).and_return(1.month.from_now)
        @donation.waiting_period_exceeded?.should eql(false)
        @donation.availability_reason.should =~ /^Pending Release on/
      end
    end
    
  end
  
  describe "applying payable balances to account" do
    
    before(:each) do
      # Kill the availability check for minimum hold time
      @time = Time.now
      Time.stub!(:now).and_return(@time + 999.days)
    end
  
    it "should apply the payable amount to the recipient's account" do
      @donation.apply_to_balance!
      @donation.receiver.balance_usd.should eql(40.50)
    end

    it "should not be applied if waiting period has not passed" do
      Time.stub!(:now).and_return(@donation.created_at)
      @donation.apply_to_balance!
      @donation.should_not be_applied_to_balance
      @donation.receiver.balance_usd.should eql(0)
    end

    it "should not allow a donation to be applied multiple times" do
      2.times { @donation.apply_to_balance! }
      @donation.receiver.balance_usd.should eql(40.50)
    end
    
    it "should provide a class method to apply all available donations" do
      m = mock_model(MonetaryDonation)
      MonetaryDonation.should_receive(:find).with(:all, :conditions => ["NOT applied_to_balance AND available_at <= ?", Time.now]).and_return([m])
      m.should_receive(:apply_to_balance!)
      MonetaryDonation.apply_available_donations!
    end
  
  end
  
  describe "fraud protection" do
    it "should be marked as suspect" do
      @donation.suspect!
      @donation.should be_suspicious
    end

    # No peeping toms!
    # it "should be marked as suspect when over $500" do
    #   @donation = MonetaryDonation.create!(@valid_attributes.merge(:gross_amount => 500.01))    
    #   @donation.should be_suspicious
    # end
    
  end
  
  describe "paypal ipn support" do
    
    before(:each) do
      @sender = account_settings(:chief)
      @receiver = account_settings(:joe)
      @content = contents(:joes_public_blog_entry)
    end
    
    it "should have paypal module" do
      MonetaryDonation.should respond_to(:from_paypal_params)
    end
    
    it "should process the ipn parameters and create a donation record" do
      ipn = paypal_postback(Time.now, @sender, @receiver, @content)
      m = MonetaryDonation.from_paypal_params(ipn)
      lambda {
        m.save!
      }.should change(MonetaryDonation, :count).by(1)
      m.reload
      m.sender.should eql(@sender)
      m.receiver.should eql(@receiver)
      m.content.should eql(@content)
    end

  end

  describe "webmoney ipn support" do
    it "should handle integration" do
      pending
    end
  end
  
  describe "sms support" do
    it "should handle integration" do
      pending
    end
  end

  describe "yandex support" do
    it "should handle integration" do
      pending
    end
  end

  describe "invitations" do
    it "should invite guests that make donations" do
      pending 'in observer'
    end
    
    it "invite to specific circle if configured" do
      pending 'in observer'
    end
  end
    
end
