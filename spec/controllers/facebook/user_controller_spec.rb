require File.dirname(__FILE__) + '/../../spec_helper'

module Facebook
  describe  Facebook::UserController do
    integrate_views
    include Facebooker::Rails::TestHelpers

    before :each do
      @current_fb_user = users(:fb_stephane)
      controller.stub!(:current_fb_user).and_return(@current_fb_user)
    end

    it "index should work" do
      facebook_get :index
      assigns(:activities).should_not be_blank
      response.should be_success   
    end

    it "received should work" do
      facebook_get :received
      assigns(:activities).should_not be_blank
      response.should be_success
    end

  end
end
