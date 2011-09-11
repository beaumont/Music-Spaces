require File.dirname(__FILE__) + '/../../spec_helper'

include AuthenticatedTestHelper

module Admin
  describe UsersController do
    integrate_views

    before :each do
      Locale.set("en")
      @current_user = users(:chief)
      controller.stub!(:current_user).and_return(@current_user)
    end

    it "index should work" do
      get :index, :id => users(:joe).id
      response.should be_success
      assigns(:users).should_not be_blank
    end

    [:show, :edit].each do |action|
      it "%s should work" % action do
        get action, :id => users(:joe).id
        response.should be_success
        assigns(:user).should_not be_blank
      end
    end

    describe "update" do
      it "should handle validation errors" do
        user = users(:joe)
        pending "TODO: fix me"
        post :update, :user => {:password => '1', 
          :password_confirmation => '1'}, :id => user.id

        response.should be_success
        assert_errors(assigns(:user))
      end
      
      it "should change password" do
        user = users(:joe)
        post :update, :user => {:password => '1234', 
          :password_confirmation => '1234'}, :id => user.id
        
        response.should be_redirect
        assigns(:user).crypted_password.should_not == user.crypted_password
      end

      it "should not change password if it's blank" do
        user = users(:joe)
        post :update, :user => {:password => '',
          :password_confirmation => '', :crypted_password => ''}, 
          :id => user.id, :set_password => 'plain'

        response.should be_redirect
        assigns(:user).crypted_password == user.crypted_password
      end

      {'plain password update' => {:password => '1234', :password_confirmation => '1234'},
        'hashed password update' => {:crypted_password => 'hehehe never decifer'}}.each do |kind, params|

        it "should show hash when changing password via %s" % kind do
          user = users(:joe)
          hash = user.crypted_password
          post :update, :user => params, :id => user.id

          f = flash[:notice]
          assert f, 'flash should be present'
          assert f[hash], 'flash should include old hash'
        end

      end

      it "should change password via hash" do
        user = users(:joe)
        hash, salt = user.crypted_password, user.salt
        user.old_password = 'password'
        user.password, user.password_confirmation = ['432109754'] * 2
        user.save!
        #we don't send salt here 'cause it shouldn't be changed for existing users
        post :update, :user => {:crypted_password => hash}, :id => user.id

        response.should be_redirect
        user.reload
        user.crypted_password.should == hash
        user.salt.should == salt
      end

      it "posting both hash and plain password leaves only hash" do
        user = users(:joe)
        hash = user.crypted_password
        user.old_password = 'password' 
        user.password, user.password_confirmation = ['432109754'] * 2
        user.save!
        post :update, :user => {:crypted_password => hash,
          :password => 'blah', :password_confirmation => 'no matter'}, :id => user.id

        response.should be_redirect
        user.reload
        user.crypted_password.should == hash
        user.should be_authenticated('password')
      end
    end

    it "activate should work" do
      user = users(:not_activated)
      user.should_not be_activated
      post :activate, :id => user.id
      assert_no_errors(assigns(:user))
      user.reload
      user.should be_activated
    end

    it "activate should fail in case of activation error" do
      user = users(:bad_login)
      post :activate, :id => user.id
      assert_errors(assigns(:user)) #because of illegal '_' in login
      response.should_not be_success
    end

    it "search by role should work" do
      get :index, :role => roles(:admin).id
      assigns(:users).should_not be_blank
      assigns(:users).all? {|u| u.admin?}.should == true
    end

    it "search by name should work" do
      query = 'hun'
      get :index, :name => query
      assigns(:users).should_not be_blank
      assigns(:users).all? {|u| u.display_name[query]}.should == true
    end

    it "search by both name and role should work" do
      query = 'hun'
      get :index, :name => query, :role => roles(:admin).id
      assigns(:users).should_not be_blank
      assigns(:users).all? {|u| u.display_name[query] && u.admin?}.should == true
    end

    it "paginated index should work" do
      get :index, :id => users(:joe).id, :page_size => 1
      assigns(:users).should_not be_blank
    end

    it "edit Project page should work" do
      get :edit, :id => users(:joy_division).id
      response.should be_success
      assigns(:user).should_not be_blank
    end
  end
end