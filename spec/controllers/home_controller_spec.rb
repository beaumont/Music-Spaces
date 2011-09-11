require File.dirname(__FILE__) + '/../spec_helper'

describe HomeController do
  integrate_views

  it "login without :user parameter should not blow" do
    post :login, "failure_action"=>"", "password"=>"x"
    response.should be_success
    flash.now[:error].should =~ /empty/
  end

  it "login with empty Kroogi Name parameter should say about it" do
    post :login, "user" => {"login" => ""}, "failure_action"=>"", "password"=>"x"
    response.should be_success
    flash.now[:error].should =~ /empty/
  end

  it "login should be successful sometimes" do
    post :login, "user" => {"login" => "joe"}, "failure_action"=>"", "password"=>"password"
    flash.now[:error].to_s.should == ""
    response.should be_redirect
    flash[:success].should_not be_blank
  end

  it "'forgot password' function should work" do
    post :reset_password, :user => {:login => 'joe', :email => 'joe.blow@sonific.com'}
    response.should be_redirect
    flash[:success].should_not be_blank
  end

  it "should fail login and redirect" do
    post :login, :user => {:login => 'quentin', :password => 'bad password'}
    assert_nil session[:user]
    assert_response :success
  end

  it "logout should work" do
    login_as :joe
    get :logout
    assert_nil session[:user]
    assert_response :redirect
  end

  it "should delete token on logout" do
    login_as :chief
    get :logout
    assert_equal response.cookies[AuthenticatedSystem::REMEMBER_ME_TOKEN], []
  end

  it "signup with same user and project logins should say about it" do
    params = signup_project_params
    params.merge!('project' => {'login' => params['user']['login']})
    post :signup, params
    response.should be_success
    assert_errors(assigns(:user), :match => /Project Kroogi Name.+differ/)
  end

  it "should allow signup for user" do
    params = signup_user_params
    post :signup, params

    assigns(:user).should_not be_blank
    assigns(:user).should be_kind_of(BasicUser)

    response.should be_redirect
  end

  it "should allow signup for single artist" do
    params = signup_project_params
    params["user"].merge!("artist_kind" => "single")
    post :signup, params

    assigns(:user).should_not be_blank
    assigns(:user).should be_kind_of(AdvancedUser)

    assigns(:project).should == nil 
    
    response.should be_redirect
  end

  it "should allow signup for host+project" do
    params = signup_project_params
    params["user"].merge!("artist_kind" => "project")
    post :signup, params

    assigns(:user).should_not be_blank
    assigns(:user).should be_kind_of(BasicUser)
    assigns(:project).should_not be_new

    response.should be_redirect
  end

  it "should allow signup for advanced+project" do
    params = signup_project_params
    params["user"].merge!("artist_kind" => "single_plus_project")
    post :signup, params

    assigns(:user).should_not be_blank
    assigns(:user).should be_kind_of(AdvancedUser)
    assigns(:project).should_not be_new

    response.should be_redirect
  end

  ['User', 'Project'].each do |type|
    ['password', 'password_confirmation', 'email'].each do |field| #'birthdate' does not work

      it "should require %s on %s signup" % [field, type] do |type|
        params = signup_user_params
        params['user']['type'] = type
        params.merge!('user' => {field => ''})
        post :signup, params
        response.should be_success
        assert assigns(:user).errors.on(field)
      end

    end
  end

  it "signup as non-artist should init circles" do
    post :signup, signup_user_params
    user = User.find_by_login('coocoo')
    user.circles.count.should == 3
  end

  it "signup as single artist should init circles" do
    params = signup_user_params
    params['user'].merge!('is_artist' => 'true', 'artist_kind' => 'single')
    post :signup, params
    user = User.find_by_login('coocoo')
    user.circles.count.should == 3
  end

  it "signup project should init circles" do
    post :signup, signup_project_params
    project = User.find_by_login('coocoo-p')
    project.circles.count.should == 3
  end

  def signup_user_params
    {"user"=>
       {
        "is_artist" => 'false',
        "password_confirmation"=>"test_user",
        "login"=>"coocoo",
        "email"=>"abc@gmail.com",
        "password"=>"test_user",
        "birthdate"=> (Date.today - 25.year).to_s(:db),
        "gender" => 'M',
        "language" => 'ru'
        },
     "preference"=>{"email_notifications"=>"2"},
     "tos"=>"on",
    }
  end

  def signup_project_params
    result = signup_user_params
    result['user'].merge!('is_artist' => 'true', 'artist_kind' => "project")
    result['project'] = {"login"=>"coocoo-p"}
    result
  end

  it "activation code should be propagated to form field" do
    invite = invites(:external_user_invited_to_circle)
    get :signup, :id => invite.activation_code
    log.debug response.body.dup
    assert_select "form input[value='#{invite.activation_code}']" 
  end
  
end
