require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper

describe ProjectController do
  integrate_views

  before :each do
    
    Locale.set("en")
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
    controller.stub!(:authorize_moderators).and_return(true)
  end

  it "creation should work" do
    post :create, "project"=>{"display_name"=>"", "login"=>"hump"},
      "user_type"=>"creating", "founder_role"=>"Your Project Role"
    assert_no_errors assigns(:project)
    response.should be_redirect
  end

  it "collection creation should work" do
    post :create, "project"=>{"display_name"=>"", "login"=>"music-collection"},
      "user_type"=>"collection", "founder_role"=>"Your Project Role"
    project = assigns(:project)
    assert_no_errors project
    response.should be_redirect

    project.reload
    project.should be_collection
  end
end
