require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper

describe PreferenceController do
  integrate_views

  before :each do
    @current_user = users(:ian_curtis)
    controller.stub!(:current_user).and_return(@current_user)
  end

  it "show should work for folks with money" do
    current_actor = users(:joy_division)
    controller.stub!(:current_actor).and_return(current_actor)
    current_actor.account_setting.has_an_approved_account_set?.should == true
    get :show, :id => current_actor.id
    response.should be_success    
  end

  it "emails should work" do
    get :emails, :id => @current_user.id
    response.should be_success
  end

  it "project_emails should work" do
    project = users(:joy_division)
    get :project_emails, :id => project.id
    response.should be_success
  end

  it "should return list of blocked users" do
    user = users(:joe)
    banned = BlockedUser.create(:blocked_by_id => @current_user.id, :blocked_user_id => user.id, :blocked_type => BlockedUser::BLOCKED_TYPES[:pvt_message])

    get :blocked_users, :id => @current_user.id
    
    assigns(:blocked_pvt_users).should == [banned]
  end

  it "should add joe and chief to the blocked list" do
    joe = users(:joe)
    chief = users(:chief)
    old = BlockedUser.count

    post :block_users, :id => @current_user.id, :users_to_block => "#{joe.login}, #{chief.login}"

    BlockedUser.count.should == old + 2
  end

  it "should add correct joe to the blocked list" do
    joe = users(:joe)
    old = BlockedUser.count

    post :block_users, :id => @current_user.id, :users_to_block => "#{joe.login}"

    BlockedUser.count.should == old + 1
    blocked = BlockedUser.last
    blocked.blocked_by_id.should == @current_user.id
    blocked.blocked_user_id.should == joe.id
    blocked.blocked_type.should == BlockedUser::BLOCKED_TYPES[:pvt_message]
  end

  it "should add joe and chief to the blocked list" do
    joe = users(:joe)
    chief = users(:chief)
    BlockedUser.create(:blocked_by_id => @current_user.id, :blocked_user_id => joe.id, :blocked_type => BlockedUser::BLOCKED_TYPES[:pvt_message])
    BlockedUser.create(:blocked_by_id => @current_user.id, :blocked_user_id => chief.id, :blocked_type => BlockedUser::BLOCKED_TYPES[:pvt_message])
    old = BlockedUser.count

    post :unblock_users, :id => @current_user.id, :users_to_unblock => [joe.id, chief.id]

    BlockedUser.count.should == old - 2
  end

  it "should not add himself to the blocked list" do
    old = BlockedUser.count

    post :block_users, :id => @current_user.id, :users_to_block => @current_user.login

    BlockedUser.count.should == old
  end

end
