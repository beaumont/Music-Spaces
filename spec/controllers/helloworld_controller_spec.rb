require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper

describe HelloworldController do

  before :each do
    login_as(:joe)
  end

  it "feedback post should send :from parameter" do
    sent_from = 'http://localhost:3333/user/kroogi/'

    post :feedback, :feedback_field => 'hey ho lets go',
      :from => @controller.uri_escape(sent_from)
    
    response.should be_success
    assigns(:feedback).should_not be_blank
    assigns(:feedback).sent_from.should == sent_from
  end

  it "feedback post should be tolerant to :from absence" do
    post :feedback, :feedback_field => 'hey ho lets go'

    response.should be_success
  end

  it "feedback post should accept single-line feedback" do
    msg = 'hey ho lets go'
    post :feedback, :feedback_field => msg

    assigns(:feedback).complaint.should == msg
  end

  it "feedback post should accept multiline feedback" do
    msg = 'hey ho lets go'
    post :feedback, :big_feedback_field => msg

    assigns(:feedback).complaint.should == msg
  end

  it "feedback post should prefer multiline feedback" do
    msg = 'hey ho lets go'
    post :feedback, :feedback_field => 'should be ignored',
      :big_feedback_field => msg

    assigns(:feedback).complaint.should == msg
  end

end
