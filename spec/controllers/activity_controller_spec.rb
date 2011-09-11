require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper

describe ActivityController do
  integrate_views

  before :each do
    
    Locale.set("en")
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
    controller.stub!(:authorize_moderators).and_return(true)
  end

  it "list should work" do
    get :list, :id => @current_user.id 
    response.should be_success
    assigns(:messages).should_not be_blank
  end

  it "list should content only displayed notifications" do
    user = users(:joe)
    @current_user.preference.update_attributes(:kroogi_notify_leaves_interested_circle => false)
    Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.interested)
    Relationship.first(:conditions => {:user_id => @current_user.id, :related_user_id => user.id}).destroy

    get :list, :id => @current_user.id

    response.should be_success
    assigns(:messages).include?(Activity.last).should == false
  end

  it "new should work" do
    get :new, :id => @current_user.id
    response.should be_success
    assigns(:activity).should_not be_blank
  end

  it "trying to mark removed activity as read shouldn't error" do
    post :mark, :activityids=>[19144], :as=>'read', :id => @current_user.id
  end

  it "batch marking activities as read should work" do
    activity_id = 8
    Activity.find(activity_id).unread?.should == true
    post :mark, :activityids=>[activity_id], :as=>'read', :id => @current_user.id
    response.should be_redirect
    Activity.find(activity_id).unread?.should == false
  end

  it "batch activities removal should work" do
    activity_id = 8
    Activity.find(activity_id).unread?.should == true
    post :remove, :activityids=>[activity_id], :id => @current_user.id
    response.should be_redirect
    Activity.find_by_id(activity_id).should == nil
  end

  it "marking activity as read should work in Ajax mode, too" do
    activity_id = 8
    Activity.find(activity_id).unread?.should == true
    post :mark, :activityids=>[activity_id], :as=>'read', :id => @current_user.id, :format => 'js'
    response.should be_success
    Activity.find(activity_id).unread?.should == false
  end

  it "activity removal should work in Ajax mode, too" do
    activity_id = 8
    Activity.find(activity_id).unread?.should == true
    post :remove, :activityids=>[activity_id], :id => @current_user.id, :format => 'js'
    response.should be_success
    Activity.find_by_id(activity_id).should == nil
  end

end
