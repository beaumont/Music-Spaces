require File.dirname(__FILE__) + '/../../spec_helper'

describe  Facebook::InviteController do
  integrate_views
  include Facebooker::Rails::TestHelpers

  before :each do
    @current_fb_user = users(:fb_stephane)
    controller.stub!(:current_fb_user).and_return(@current_fb_user)

    @fb_session = Facebooker::Session.create('apikey', 'secretkey')
    Facebooker::Session.stub!(:create).and_return(@fb_session)
    @fb_session.stub!(:secure_with!).and_return(true)
    @fb_session.stub!(:secured?).and_return(true)
    @fb_session.stub!(:user).and_return(@current_fb_user)
    @current_fb_user.stub!(:to_i).and_return(@current_fb_user.facebook_id.to_i)
  end

  it "create should work and increment Activity" do
    old_count = Activity.only_from(@current_fb_user).only(:content_invite_sent).count

    facebook_post :create, :ids => [:fb_artem, :fb_anya].map {|u| users(u).details.fb_user_id},
                           :from => @current_fb_user,
                           :album => contents(:squarepusher_weird_album)

    Activity.only_from(@current_fb_user).only(:content_invite_sent).count.should == old_count + 2
    response.should be_success
  end

  it "duplicate invite for same content should not be allowed" do
    friend1 = Facebooker::User.new(435432543, @fb_session)
    friend2 = Facebooker::User.new(643553243, @fb_session)
    friends = [friend1,friend2]
    @current_fb_user.stub!(:friends).and_return(friends)
    
    facebook_get :new, :fb_sig_user=> @current_fb_user.facebook_id,
                       :ma_id => contents(:exit_planet_dust).id

    assigns(:current_fb_user).should_not be_nil
    assigns(:album).should_not be_nil
    
    excluded_friends_list = assigns(:excluded_friends_list)
    excluded_friends_list.should_not be_nil
    excluded_friends_list.count.should == 1

  end
end
