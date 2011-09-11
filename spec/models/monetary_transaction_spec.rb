require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MonetaryTransaction do
  before(:each) do
    @receiver = mock_model(AccountSetting, :id => 1, :billable? => false)
    @valid_attributes = {
      :currency => 'usd',
      :receiver => @receiver,
      :gross_amount => 10.00,
      :monetary_processor_fee => 0.10
    }
    @t = MonetaryTransaction.create!(@valid_attributes)
  end

  describe "storing postpack params" do
    it "should store the params" do
      p = {:foo => 'testing101'}
      @t = MonetaryTransaction.create!(@valid_attributes.merge(:params => p))
      @t.params.should == {:foo => 'testing101'}
    end
    
  end
  
  describe "calculating net and payable amounts" do    
    
    before(:each) do
      @mt = MonetaryTransaction.new(:sender => @sender, :receiver => @receiver) # no sender defined?
      @mt.gross_amount = 10.00
      @mt.currency = 'USD'
    end
    
    it "should handle the contribution cleanly for payment amount with strings without billable" do
      @mt.should_not_receive(:handling_fee_percent)
      @mt.stub!(:gross_amount_usd).and_return(BigDecimal.new('34.22'))
      @mt.send(:calculate_amounts)
      @mt.handling_fee_usd.should eql(0)
    end
    
    it "should calculate handling fee only if billable (even when 0)" do
      @receiver.should_receive(:billable?).and_return(true)
      @mt.send(:calculate_amounts)
      @mt.handling_fee_usd.to_f.should eql(0.0)
    end
    
    it "should calculate a net amount" do
      @t.net_amount_usd.should eql(9.90)
    end
    
    it "should caluculate a payable amount" do
      @t.payable_amount_usd.should eql(9.90)
    end
  end
  
  describe "currency storage" do
    it "should provide a currency based on the currency_id case insensitive" do
      @t.currency.should eql('USD')
      @t.currency_id.should eql(1)
      @t.currency.should eql('USD')
    end
    
    it "should allow setting via currency= method case insensitive" do
      @t.currency = 'eur'
      @t.currency_id.should eql(3)
      @t.currency.should eql('EUR')
    end
    
  end

  describe "converting currency" do
    before(:each) do
      @mt = MonetaryTransaction.new(:currency => 'usd', :gross_amount => 10.00, :receiver => @receiver)
    end
    
    it "should try to convert currency before save" do
      @mt.should_receive(:convert_currency)
      @mt.save!
    end
    
    it "should just update the gross_usd value when the amount is already usd" do
      @mt.should_receive(:gross_amount_usd=).with(10.00)
      @mt.should_receive(:conversion_rate=).with(1.0)
      @mt.save!
    end
    
    it "should mark suspicious and send a notification if there is an issue with conversion rates" do
      mock_ch = mock(CashHandler::Base)
      mock_ch.should_receive(:get).and_raise StandardError
      CashHandler::Base.should_receive(:instance).and_return(mock_ch)
      @mt.currency = 'EUR'
      AdminNotifier.should_receive(:async_deliver_alert).with(/^Error converting currency to USD/)
      @mt.save!
      @mt.should be_suspicious
    end
    
  end
    
  it "should use cash handler to receive a conversion rate for RUR to USD" do
    @mt = MonetaryTransaction.new(:currency => 'usd', :gross_amount => 10.00, :receiver => @receiver)
    
    mock_ch = mock(CashHandler::Base)
    mock_ch.should_receive(:convert).with(10.00, 'RUR', 'USD').and_return(5.23456)
    mock_ch.should_receive(:convert).with(nil, 'RUR', 'USD').and_return(nil)
    mock_ch.should_receive(:get).with('USD', :against => 'RUR').and_return(0.0325318)
    CashHandler::Base.should_receive(:instance).and_return(mock_ch)
    @mt.gross_amount = 10.00
    @mt.currency = 'RUR'
    @mt.should_receive(:conversion_rate=).with(0.0325318)
    @mt.should_receive(:gross_amount_usd=).with(5.23456)
    @mt.save!
  end

end
