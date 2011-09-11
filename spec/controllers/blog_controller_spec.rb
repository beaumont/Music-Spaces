require File.dirname(__FILE__) + '/../spec_helper'

describe BlogController do
  
  describe "GET index" do
    it "should redirect to settings if no blog and acting as same user" do
      u = users(:chief)
      login_as(:chief)
      get :index, :id => u.id
      pending("TODO: fix the spec")
      response.should redirect_to(:action => :settings, :id => u.id)
    end
    
    it "should display entries if there are entries to display" do
      u = users(:joe)      
      login_as(:joe)      
      entries = [mock_model(Blog)]
      Blog.should_receive(:paginate).and_return(entries)            
      get :index, :id => u.id
      response.should be_success      
      assigns['entries'].should eql(entries)
    end
        
    it "should display the standard index page even without entries" do
      u = users(:joe)      
      login_as(:joe)      
      Blog.should_receive(:paginate).and_return([])
      get :index, :id => u.id
      response.should be_success
      response.should render_template('index')
    end
    
  end
  
  describe "GET settings" do
    it "should set the account" do
      login_as(:joe)
      get :settings, :id => users(:joe).id
      assigns['account'].should eql(accounts(:joes))
      response.should be_success
    end
    
    it "should provide a new account if the user doesnt have one yet" do
      user = :chief
      login_as(user)
      get :settings, :id => users(user).id
      assigns['account'].should be_kind_of(Account)
      response.should be_success
    end
    
    it "should raise Kroogi::NotFound if not permitted" do
      login_as(:chief)
      lambda do
        get :settings, :id => users(:joe).id
      end.should raise_error(Kroogi::NotFound)
    end
  end
  
  describe "POST refresh" do
    it "should refresh the selected users entries" do
      u = users(:joe)
      u.livejournal_account.should_receive(:update_cache)
      controller.stub!(:current_actor).and_return(u)
      login_as(:joe)
      post :refresh, :id => u.id
      pending("TODO: fix the spec")
      response.should redirect_to(:action => :index, :id => u.id)
    end
  end

  describe "GET settings" do    
    before(:each) do
      login_as(:joe)      
    end
    
    it "should raise Kroogi::NotFound if not authorized" do
      lambda do
        get :settings, :id => 1
      end.should raise_error(Kroogi::NotFound)
    end
    
    it "should set the type to community if passed in type=community" do
      get :settings, :id => 3, :type => 'community'
      assigns['type'].should eql('community')
    end

    it "should be personal by default for users" do
      get :settings, :id => 3
      assigns['type'].should eql('personal')
    end
  end
  
  describe "POST update" do
    before(:each) do
      @settings = {
        :id => 3,
        :account => {
          :username => 'joe',
          :password => 'billy',
          :password_confirmation => 'billy'}}
    end
    
    it "should remove an account when username is passed back as a blank" do
      login_as(:joe)      
      a = mock(Account)
      a.stub!(:is_community?)
      a.should_receive(:destroy)
      controller.send(:current_actor).stub!(:livejournal_account).and_return(a)
      pending "Kali please look at this, it broke after your r8349. Maybe a real bug, maybe just mocks problem."
      post :update, @settings.merge(:account => {:username => ''})
      flash[:success].should_not be_blank
      pending("TODO: fix the spec")
      response.should redirect_to(:action => :settings, :id => 3)      
    end
    
    it "should create an account for someone if they do not have one" do
      login_as(:chief)
      a = mock(Account)
      a.should_receive(:save).and_return(true)
      a.stub!(:update_cache)
      a.stub!(:blogs).and_return([])
      a.stub!(:clear_passwords)
      a.stub!(:is_community?).and_return(false)
      controller.send(:current_actor).
        should_receive(:build_livejournal_account).
        with(@settings[:account].stringify_keys).
        and_return(a)
      post :update, @settings.merge(:id => users(:chief).id)
      flash[:success].should_not be_blank
      pending("TODO: fix the spec")
      response.should redirect_to(:action => :index, :id => 2)
    end
    
    it "should update an existing account" do
      login_as(:joe)
      a = users(:joe).livejournal_account
      controller.send(:current_actor).stub!(:livejournal_account).and_return(a)
      a.should_receive(:update_attributes).with(@settings[:account].stringify_keys).and_return(true)
      a.should_receive(:update_cache)
      post :update, @settings
      pending("TODO: fix the spec")
      response.should redirect_to(:action => :index, :id => 3)      
    end
    
    it "should destroy the account and start fresh if login is different" do
      @settings.merge!(:account => {:username => 'newname'})
      login_as(:joe)
      a = users(:joe).livejournal_account
      a.stub!(:blogs).and_return([])
      controller.send(:current_actor).stub!(:livejournal_account).and_return(a)
      a.should_receive(:destroy)
      b = mock_model(Account)
      b.stub!(:blogs).and_return([])
      controller.send(:current_actor).should_receive(:build_account).and_return(b)
      b.stub!(:is_community?).and_return(false)
      b.should_receive(:save).and_return(true)
      b.should_receive(:update_cache).with(true)
      b.stub!(:clear_passwords)
      pending "Kali please look at this, it broke after your r8349. Maybe a real bug, maybe just mocks problem."
      post :update, @settings
      pending("TODO: fix the spec")
      response.should redirect_to(:action => :index, :id => 3)            
    end

    #   # TODO: Figure out the GC error
    #   # /opt/local/bin/rcov:19: [BUG] rb_gc_mark(): unknown data type 0x18(0x74078a0) non object
    #   # only happens when running rcov    
    # it "should provide a flash and redirect to settings if unable to update" do
    #   login_as(:joe)
    #   a = accounts(:joes)
    #   controller.send(:current_actor).stub!(:account).and_return(a)
    #   a.should_receive(:update_attributes).with(@settings[:account].stringify_keys).and_return(false)
    #   post :update, @settings
    #   flash[:warning].should_not be_blank
    #   response.should redirect_to(:action => :index, :id => 3)      
    # end
    
    it "should raise Kroogi::NotFound if not authorized" do
      login_as(:joe)
      lambda do
        post :update, :id => 1
      end.should raise_error(Kroogi::NotFound)
    end    

  end
end