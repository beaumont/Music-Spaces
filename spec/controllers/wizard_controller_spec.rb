require File.dirname(__FILE__) + '/../spec_helper'

describe WizardController do

  before :each do
    Locale.set("en")
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
  end

  it "add_avatar should work" do
    get :add_avatar
    response.should be_success
  end


  it "add_picture should work" do
    get :add_picture
    response.should be_success
  end

  it "basic_info_project should work for project" do
    Locale.set("en")
    current_actor = users(:chief)
    controller.stub!(:current_actor).and_return(current_actor)

    get :basic_info_project, :id => current_actor.id
    response.should be_success
  end

  it "basic_info_project POST should work for project" do
    Locale.set("en")
    current_actor = users(:chief)
    controller.stub!(:current_actor).and_return(current_actor)

    post :basic_info_project, :id => current_actor.id
    response.should be_success
  end

  it "basic_info should work for User" do
    get :basic_info, :id => users(:chief).id
    assigns(:profile).should_not be_nil
    response.should be_success
  end

  it "basic_info POST should work for User" do
    post :basic_info, :id => users(:chief).id
    assigns(:profile).should_not be_nil
    response.should be_success
  end
  
  it "add_content should work for User" do
    get :add_content, :id => users(:chief).id
    response.should be_success
  end

  it "add_content should work for Project" do
    get :add_content, :id => users(:chief).id
    response.should be_success
  end
  
  it "agreement should work for Project" do
    get :agreement, :id => users(:chief).id
    assigns(:account_setting).should_not be_nil
    response.should be_success
  end
  
  it "attach_money should work for Project" do
    get :attach_money, :id => users(:chief).id
    response.should be_success
  end

  it "join_project should add project to like list" do
    @project = users(:joy_division)
    old_count = WhatYouLike.count
    post :join_project, :project_id => @project.id, :follow => true
    response.should be_success
    WhatYouLike.count.should == old_count + 1
  end

  it "join_project should remove project from like list" do
    @project = users(:joy_division)
    WhatYouLike.make_user_like_project(:follower => @current_user, :followed => @project)
    old_count = WhatYouLike.count
    post :join_project, :project_id => @project.id
    response.should be_success
    WhatYouLike.count.should == old_count - 1
  end

  it "join_all_children should add project to like list" do
    @collection = users(:"kroogi-music")
    @project = users(:joy_division)
    CollectionInclusion.create(
      :child_pac_id => @project.id,
      :parent_id => @collection.id,
      :child_user_id => @project.id,
      :direct_parent_id => @collection.id,
      :child_is_collection => false,
      :stopped => false
    )
    old_count = WhatYouLike.count
    post :join_all_children, :dir_id => @collection.id, :follow => true
    response.should be_success
    WhatYouLike.count.should == old_count + 1
  end

  it "join_all_children should remove project from like list" do
    @collection = users(:"kroogi-music")
    @project = users(:joy_division)
    CollectionInclusion.create(
      :child_pac_id => @project.id,
      :parent_id => @collection.id,
      :child_user_id => @project.id,
      :direct_parent_id => @collection.id,
      :child_is_collection => false,
      :stopped => false
    )
    WhatYouLike.make_user_like_project(:follower => @current_user, :followed => @project)
    old_count = WhatYouLike.count
    post :join_all_children, :dir_id => @collection.id
    response.should be_success
    WhatYouLike.count.should == old_count - 1
  end

end