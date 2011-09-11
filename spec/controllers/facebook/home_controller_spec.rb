require File.dirname(__FILE__) + '/../../spec_helper'

module Facebook
  describe  Facebook::HomeController do
    integrate_views
    include Facebooker::Rails::TestHelpers

    before :each do
      @current_fb_user = users(:fb_stephane)
      controller.stub!(:current_fb_user).and_return(@current_fb_user)
    end

    it "returning users should be found" do
      @current_fb_user.should_receive(:friends_activities).and_return do
        @friends_activities = []
      end
      facebook_get :index, :fb_sig_user => users(:fb_stephane).details.fb_user_id
      user = assigns(:current_fb_user)
      user.class.name.should == Facebook::User.name
      user.should be_active
    end

    it "returning users should be found even if he removed the app previously" do
      @current_fb_user.should_receive(:friends_activities).and_return do
        @friends_activities = []
      end
      facebook_get :index, :fb_sig_user => users(:fb_removed).details.fb_user_id
      user = assigns(:current_fb_user)
      user.id.should == users(:fb_removed).id
      user.should be_active
    end

    it "deauthorize should work" do
      facebook_get :deauthorize, :fb_sig_user => users(:fb_stephane).details.fb_user_id
      response.should be_success
    end

    it "deauthorize should fail with wrong signature key" do
      begin
        get :deauthorize, facebook_params.merge('fb_sig' => 'incorrect')
        fail "No IncorrectSignature raised"
      rescue Facebooker::Session::IncorrectSignature=>e
      end
    end

  end
end