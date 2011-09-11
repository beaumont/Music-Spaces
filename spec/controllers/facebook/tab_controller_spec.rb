require File.dirname(__FILE__) + '/../../spec_helper'

module Facebook
  describe  Facebook::TabController do
    integrate_views
    include Facebooker::Rails::TestHelpers

    it "should display profile application tab for public page viewer" do
      facebook_get :tab, :fb_sig_profile_user => users(:fb_stephane).facebook_id,
                          :fb_sig_is_admin => 0,
                          :fb_sig_page_id => users(:fb_public_page1).facebook_id
      assigns(:user).should_not be_blank
      response.should be_success
    end

    it "should display profile application tab for public page Admin" do
      facebook_get :tab, :fb_sig_profile_user => users(:fb_stephane).facebook_id,
                          :fb_sig_is_admin => 1,
                          :fb_sig_page_id => users(:fb_public_page1).facebook_id
      assigns(:user).should_not be_blank
      response.should be_success
    end


  end
end