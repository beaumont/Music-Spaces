require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MonetaryTransactionObserver do
  
  before(:each) do
    @user     = users(:chief)
    Thread.current['user'] = @user
    @send_user  = users(:joe)
    @observer = MonetaryTransactionObserver.instance
    @receiver = mock_model(AccountSetting, :balance_usd => 10.00, :increment! => true, :decrement! => true, :user => @user, :owner => @user, :user_id => @user.id, :billable? => true, :waiting_period => 1.day)
    @sender   = mock_model(AccountSetting, :collected_usd => 0.00, :user => @send_user, :user_id => @send_user.id)
  end
  
  describe "MonetaryDonations" do  
    before(:each) do
      @content  = contents(:chiefs_sacred_album)
      @donation = MonetaryDonation.new(:sender => @sender,
                                       :receiver => @receiver,
                                       :content => @content,
                                       :monetary_processor => monetary_processors(:paypal),
                                       :monetary_processor_fee => 0.10,
                                       :gross_amount => 10.00,
                                       :currency => 'USD',
                                       :net_amount_usd => 9.00,
                                       :handling_fee_usd => 0.00,
                                       :payable_amount_usd => 9.00 )
    end
    
    it "should be applied to receivers total" do
      @receiver.should_receive(:increment!).with(:collected_usd, 9.00)
    end
    
    it "should be applied to content total" do
      @content.should_receive(:increment!).with(:collected_usd, 9.00)      
    end
    
    it "should flag suspicious donations (over $500)" do
      @donation.gross_amount_usd = 500.01
      @donation.should_receive(:suspect!)
    end
    
    it "should not invite guest users if sender is provided" do
      @observer.should_not_receive(:invite_guest_user)
    end
    
    it "should send invite to guest if anonymous donation" do
      @donation.sender = nil
      @donation.should be_anonymous
      @observer.should_receive(:invite_guest_user).with(@donation)
    end
    
    it "should not invite users to a circle without invite" do
      @observer.should_not_receive(:invite_to_circle)
    end
    
    it "should invite users if there is an invite" do
      @donation.invite = mock_model(Invite)
      @observer.should_receive(:invite_to_circle).with(@donation)
    end
    
    it "should notify people of donations received if notifiable" do
      @donation.stub!(:notifiable_donation_received?).and_return true
      @observer.should_receive(:notify_of_donation_received).with(@donation)
    end
    
    it "should not notify unless notifiable" do
      @donation.stub!(:notifiable_donation_received?).and_return false
      @observer.should_not_receive(:notify_of_donation_received)
    end
      
    it "should notify of album donation" do
      @donation.should be_album_donation
      @observer.should_receive(:notify_of_album_donation).with(@donation)
    end
    
    it "should not notify of album donation if not an album" do
      @donation.content = contents(:joes_public_blog_entry)
      @observer.should_not_receive(:notify_of_album_donation)
    end
    
    it "should actually create invitation for guest user" do
      @donation.invite = mock_model(Invite)
      @donation.sender = nil
      @donation.sender_email = 'bobbyjoe@example.com'
      @donation.should be_invitable_as_anonymous_donor
      InviteNotifier.should_receive(:async_deliver_invite_from_donation).with('bobbyjoe@example.com', 'en', @receiver.user)
    end
    
    it "should actually increment the impacts correctly" do
      pending 'thats a big glob of code to spec... lets see if it works first'
    end
    
    it "should actually invite to circle" do
      pending 'thats a big glob of code to spec... lets see if it works first'      
    end
    
    after(:each) do
      @observer.after_create(@donation)
    end
    
  end
  
  describe "MonetaryWithdrawals" do
    before(:each) do
      @withdrawal = MonetaryWithdrawal.new(:receiver => @receiver, :payable_amount_usd => 5.00)
    end
        
    after(:each) do
      @observer.after_create(@withdrawal)
    end
    
    # it "should negate the users balance" do
    #   @receiver.should_receive(:decrement!).with(:balance_usd, 5.00)
    # end
    
  end
  
end