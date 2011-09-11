require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper

describe ProfileController do
  integrate_views

  before :each do
    Locale.set("en")
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
  end

  it "custom questions: new questions should work, and updating old too" do
    profile = profiles(:chief)
    profile.profile_questions.detect {|q| q.question == 'Why?'}.should == nil
    ProfileQuestion.find(1).question.should_not == 'X?'

    post :update_account,
      "id"=>profile.id,
      "profile"=>{
      "question_list"=>[
        {"answer"=>"Becuz",
        "question"=>"Why?"},
        {"answer"=>"Y",
        "question"=>"X?", "id" => 1},
      ],
      }

    assert_no_errors(assigns(:profile))
    profile = Profile.find(profile.id)
    flash[:error].should == nil
    profile.profile_questions.detect {|q| q.question == 'Why?'}.should_not == nil
    ProfileQuestion.find(1).question.should == 'X?'
    response.should be_redirect
  end

  it "project's Display Name field at Edit screen should have correct id" do
    user = users(:ian_curtis)
    project = users(:joy_division)
    controller.stub!(:current_user).and_return(user)

    get :edit_basic, "id"=>project.profile.id

    (!!(response.body =~ /id="user__display_name"/)).should == true
    (!!(response.body =~ /id="user_display_name_ru"/)).should == true
  end

  it "update with unknown ids should work" do
    Locale.set("ru")

    profile = profiles(:chief)

    unknown = 800
    ProfileQuestion.find_by_id(unknown).should == nil

    post :update_account,
      "id"=>profile.id,
      "profile"=>{
      "question_list"=>[
        {"answer"=>"",
        "question"=>"", "id" => unknown},
      ],
      }

    assert_no_errors(assigns(:profile))
    profile = Profile.find(profile.id)
    flash[:error].should == nil
    profile.profile_questions.detect {|q| q.question == ''}.should == nil
    response.should be_redirect
  end

  it "upgrading account should work" do
    @current_user = users(:basic_user1)
    controller.stub!(:current_user).and_return(@current_user)

    basic_user_profile = profiles(:basic_user1)
    post :upgrade_account, :id => basic_user_profile.id

    upgraded_user = User.find(basic_user_profile.user.id)
    upgraded_user.should be_kind_of(AdvancedUser)

    flash[:error].should == nil
    response.should be_redirect
  end

  it "edit form fields should not care about subtype" do
    user = users(:chief)
    controller.stub!(:current_user).and_return(user)

    get :edit_basic, "id"=> user.profile.id
    
    (!!(response.body =~ /id="user_gender_m"/)).should == true
  end

end
