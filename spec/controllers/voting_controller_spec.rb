require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper
include SpecHelpersMixin

describe VotingController do
  integrate_views

  before :each do
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
  end

  it "voting should work for empty albums" do
    album = contents(:joydivisions_empty_draft)
    album.should be_empty
    album.up_votes.count.should == 0
    post :vote_up, :id => album.id
    album.up_votes.count.should == 1
  end
end
