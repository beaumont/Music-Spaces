require File.dirname(__FILE__) + '/../spec_helper'

describe PlayerController do
  integrate_views

  before :each do
  end

  [[:album_id, lambda {|caller| caller.contents(:joydivisions_closer_album).id}],
   [:track_id, lambda {|caller| caller.contents(:jd_closer_isolation_track).id}],
  ].each do |param, calc|
    it "embedded_play_list should work with #{param} param" do
      get :embedded_play_list, :format => 'xml', param => calc.call(self)
      vars = assigns(:vars)
      vars[:tracks].should_not be_blank
      vars[:tracks].each do |c|
        c.class.name.should == Track.name
      end
      vars[:more_attribs][:user].should_not be_blank
      vars[:more_attribs][:title].should_not be_blank
      vars[:more_attribs][:kroogi_url].should_not be_blank
    end
  end

  it "should survive request without params" do
    get :embedded_play_list, :format => 'xml'
  end
end
