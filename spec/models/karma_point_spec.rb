require File.dirname(__FILE__) + '/../spec_helper'

describe KarmaPoint do
  
  before(:each) do
    @point = KarmaPoint.create(:content       => contents(:the_extremist),
                               :referrer      => users(:joe),
                               :referral_url  => 'http://example.com/music/the_extremist',
                               :action        => 'click')
    @content = contents(:joydivisions_closer_album)
  end
  
  it "should create duplicates using an existing point" do
    lambda do
      KarmaPoint.create_from_id(@point.id)
    end.should change(KarmaPoint, :count).by(1)
  end
  
  it "should provide optional attribute overrides" do
    kp = KarmaPoint.create_from_id(@point.id, :content => @content, :action => 'donate')
    kp.action.should eql('donate')
    kp.content_id.should eql(14)
  end
  
  it "should handle not having a referral by not creating a point" do
    lambda do
      KarmaPoint.create_from_id(nil)
    end.should_not change(KarmaPoint, :count)
  end
  
  it "should give 1 point for download" do
    kp = KarmaPoint.create_from_id(@point.id, :content => @content, :action => :download)
    kp.points.should eql(1)
  end
  
  it "should give 0 points for donation" do
    kp = KarmaPoint.create_from_id(@point.id, :content => @content, :action => 'donate')
    kp.points.should eql(0)    
  end
  
end
