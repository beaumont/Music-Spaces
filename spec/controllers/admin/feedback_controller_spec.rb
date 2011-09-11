require File.dirname(__FILE__) + '/../../spec_helper'

include AuthenticatedTestHelper

module Admin
  describe FeedbackController do
    integrate_views

    before :each do
      
      Locale.set("en")
      @current_user = users(:chief)
      controller.stub!(:current_user).and_return(@current_user)
    end
    
    it "index should work" do
      get :index
      response.should be_success
      assigns(:feedbacks).should_not be_blank
    end

    it "reply should return error for non-Kroogi member" do
      @current_user.should_receive(:is_kroogi_dev?).any_number_of_times.and_return(false)
      post :reply, :id => feedbacks(:one).id, :reply => {}
      response.should be_success
      flash.now[:error].should =~ /member of Kroogi/
    end

    it "reply should be success for Kroogi member" do
      @current_user.should_receive(:is_kroogi_dev?).and_return(true)
      post :reply, :id => feedbacks(:one).id, :reply => {:post => 'hey ho'}
      response.should be_redirect
      assert_no_errors(assigns(:reply_validation))
      flash.now[:error].should == nil
    end

    it "reply should return error if validation fail" do
      @current_user.should_receive(:is_kroogi_dev?).any_number_of_times.and_return(true)
      post :reply, :id => feedbacks(:one).id, :reply => {}
      response.should be_success
      assert_errors(assigns(:reply_validation))
      flash.now[:error].should =~ /valid/
    end

    it "reply should include original text" do
      @current_user.should_receive(:is_kroogi_dev?).and_return(true)
      msg = 'hey ho'
      post :reply, :id => feedbacks(:one).id, :reply => {:post => msg}
      response.should be_redirect
      assert_no_errors(assigns(:reply_validation))
      assigns(:replies)[feedbacks(:one).id].post.should be_include(feedbacks(:one).complaint)
      msg.should_not be_include(feedbacks(:one).complaint)
      flash.now[:error].should == nil
    end

    it "marking as junk should work" do
      f = feedbacks(:one)
      f.should_not be_junk
      post :mark_as_junk, :id => f.id
      f.reload
      f.should be_junk
    end

    it "marking as not junk should work" do
      f = feedbacks(:junk)
      f.should be_junk
      post :mark_as_not_junk, :id => f.id
      f.reload
      f.should_not be_junk
    end

    it "index should not show junk by default" do
      get :index
      (assigns(:feedbacks).find {|f| f.junk?}).should == nil      
    end

    it "index should not show junk with explicit param" do
      get :index, :filter => {:show_junk => 0}
      (assigns(:feedbacks).find {|f| f.junk?}).should == nil
    end

    it "index should show junk with explicit param" do
      get :index, :filter => {:show_junk => 1}
      (assigns(:feedbacks).find {|f| f.junk?}).should_not == nil
    end
  end
end