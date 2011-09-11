require File.dirname(__FILE__) + '/../spec_helper'

describe KarmaController do
  
  before(:each) do
    login_as(:chief)
    @content  = contents(:the_extremist)
    @referrer = users(:joe)
    @referred = users(:chief)
    request.stub!(:referer).and_return('http://example.com/blog/99')
    @mock_karma_point = mock_model(KarmaPoint)
  end
  
  describe "routing" do
    it "should map to /share/:content_id/:referrer_id" do
      route_for(:controller => "karma",
                :action     => "referral",
                :referrer_id => @referrer.id.to_s,
                :content_id  => @content.id.to_s).should == "/share/30/3"
    end
    
    it "should create simple urls/paths" do
      pending "Josh cannot fix it on CC"
      share_path(@content, @referrer).should == '/share/30/3'
    end
    
    it "should not require the referrer (for anonymous/nil users)" do
      pending "Josh cannot fix it on CC"
      share_path(@content.id).should == '/share/30'
    end
  end

  describe "content referral" do
    it "should create a karma point" do
      KarmaPoint.should_receive(:create!).with({
        :content      => @content,
        :referrer     => @referrer,
        :referred     => @referred,
        :referral_url => 'http://example.com/blog/99',
        :action       => 'click'
      }).and_return(@mock_karma_point)  
      get :referral, {:content_id => @content.id, :referrer_id => @referrer.id}
    end
        
    it "should redirect to the content if available" do
      get :referral, :content_id => @content.id, :referrer_id => @referrer.id
      response.should redirect_to(controller.content_url(@content))
    end
    
    it "should gracefully handle missing or removed content" do
      get :referral, :content_id => 999999999, :referrer_id => @referrer.id
      response.should redirect_to('/explore')
    end
    
    it "should store a reference to the current karma point in the session" do
      KarmaPoint.should_receive(:create!).and_return(@mock_karma_point)
      get :referral, {:content_id => @content.id, :referrer_id => @referrer.id}
      session[:karma_point_id].should eql(@mock_karma_point.id)
    end

  end

end
