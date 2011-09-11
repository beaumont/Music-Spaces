require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WebMoneyDonation do

  describe "validation" do
    before(:each) do
      @d = WebMoneyDonation.new()
      @d.should_not be_valid
    end
    
    describe "Receiver WMID" do

      it "should reject missing receiver_wmid" do
        @d.errors.on(:receiver_wmid).should include('is invalid')
      end
      
      it "should allow 12 digit number" do
        @d.receiver_wmid = 123123123123
        @d.valid?
        @d.errors.on(:receiver_wmid).should be_blank
      end
      
      it "should not allow random garbage" do
        @d.receiver_wmid = 'i4ouhg2i3ughoi4ugh3o1'
        @d.valid?
        @d.errors.on(:receiver_wmid).should include('is invalid')
      end
      
      it "should not allow more than 12 digits" do
        @d.receiver_wmid = 1231231231239
        @d.valid?
        @d.errors.on(:receiver_wmid).should include('is invalid')
      end
      
      it "should not allow less than 12 digits" do
        @d.receiver_wmid = 12312312312
        @d.valid?
        @d.errors.on(:receiver_wmid).should include('is invalid')
      end
      
    end

    describe "Sender WMID" do
      
     it "should reject missing sender_wmid" do
        @d.errors.on(:sender_wmid).should include('is invalid')
      end
      
      it "should allow 12 digit number" do
        @d.sender_wmid = 123123123123
        @d.valid?
        @d.errors.on(:sender_wmid).should be_blank
      end
      
      it "should not allow random garbage" do
        @d.sender_wmid = 'i4ouhg2i3ughoi4ugh3o1'
        @d.valid?
        @d.errors.on(:sender_wmid).should include('is invalid')
      end
      
      it "should not allow more than 12 digits" do
        @d.sender_wmid = 1231231231239
        @d.valid?
        @d.errors.on(:sender_wmid).should include('is invalid')
      end
      
      it "should not allow less than 12 digits" do
        @d.sender_wmid = 12312312312
        @d.valid?
        @d.errors.on(:sender_wmid).should include('is invalid')
      end
      
    end    
   
    describe "Purse Type" do
      
      it "should reject missing purse_type" do
        @d.errors.on(:purse_type).should include('is invalid')
      end
      
      it "should allow 90, 82, 69" do
        %w{90 82 69}.each do |p|
          @d.purse_type = p
          @d.valid?
          @d.errors.on(:purse_type).should be_blank
        end
      end
      
      it "should not allow strange purse types" do
        %w{R U 2134 sdigh 3!}.each do |p|
          @d.purse_type = p
          @d.valid?
          @d.errors.on(:purse_type).should include('is invalid')
        end
      end
      
    end

    describe "Amount" do
      
      it "should only allow numbers" do
        @d.amount = 50
        @d.valid?
        @d.errors.on(:amount).should be_blank
      end
      
      it "should disallow characters" do
        @d.amount = 'blah'
        @d.valid?
        @d.errors.on(:amount).should include('must be a number')
      end
      
      it "should disallow numbers less than 0" do
        @d.amount = -1
        @d.valid?
        @d.errors.on(:amount).should include('must be greater than 0')
      end
      
    end

  end
  
  describe "Initialization" do
    
    it "should allow init with args" do
      w = WebMoneyDonation.new(:amount => 10, :receiver_wmid => 123123123123)
      w.amount.should eql(10)
      w.receiver_wmid.should eql(123123123123)      
    end

    it "should allow init with block" do
      w = WebMoneyDonation.new do |w|
        w.amount = 10
        w.receiver_wmid = 123123123123
      end
      w.amount.should eql(10)
      w.receiver_wmid.should eql(123123123123)      
    end
    
  end
  
  describe "Updating Attributes" do
    
    it "should allow update with args" do
      w = WebMoneyDonation.new
      w.update_attributes(:amount => 10, :receiver_wmid => 123123123123)
      w.amount.should eql(10)
      w.receiver_wmid.should eql(123123123123)      
    end

    it "should allow update with block" do
      z = WebMoneyDonation.new
      z.update_attributes do |w|
        w.amount = 10
        w.receiver_wmid = 123123123123
      end
      z.amount.should eql(10)
      z.receiver_wmid.should eql(123123123123)      
    end
    
  end

  
end