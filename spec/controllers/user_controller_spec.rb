require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper

describe UserController do
  integrate_views

  before :each do
    
    Locale.set("en")
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
    #controller.stub!(:authorize_moderators).and_return(true)
  end

  it "show project should work" do
    get :index, :id => Project.find_by_login('joydivision').id, :locale => 'en'
    response.should be_success    
  end

  it "showcase should work" do
    get :gallery, :id => Project.find_by_login('joydivision').id
    response.should be_success
  end

  it "showing own project should work" do
    controller.stub!(:current_user).and_return(users(:ian_curtis))
    get :index, :id => Project.find_by_login('joydivision').id, :locale => 'en'
    response.should be_success
  end

  it "show non-empty collection project should work" do
    CollectionProject.repopulate_all_inclusions
    get :index, :id => Project.find_by_login('kroogi-music').id, :locale => 'en' 
    response.should be_success
    assigns(:projects).should_not be_blank
  end

  it "'Upload' word shouldn't show up for collection owners" do
    controller.stub!(:current_user).and_return(users(:joe))
    get :index, :id => Project.find_by_login('kroogi-music').id, :locale => 'en'
    (!!(response.body.dup['Add User or Project'])).should == true
    (!!(response.body.dup['Upload:'])).should == false
  end

  it "show empty collection project should work" do
    get :index, :id => Project.find_by_login('empty_collection').id, :locale => 'en'
    response.should be_success

    #verify pre-conditions
    assigns(:projects).should be_blank
    assigns(:collections).should be_blank
  end

  it "about page should work for collection project" do
    get :about, :id => users('kroogi-music').id
    response.should be_success
  end

  ['en', 'ru'].each do |locale|
    it "explore page should work in locale '%s' for logged in" % locale do
      get :explore, :locale => locale
      response.should be_success
      I18n.locale.should == locale
    end

    it "explore page should work in locale '%s' for logged out" % locale do
      NewContent.fill_with_content(5)
      
      current_user = Guest.new
      controller.stub!(:current_user).and_return(current_user)

      get :explore, :locale => locale
      response.should be_success
      I18n.locale.should == locale
    end
  end

  it "should survive tag request with spaces" do
    current_user = Guest.new
    controller.stub!(:current_user).and_return(current_user)

    get :tags, :id => users(:chief).id, :tag => 'раз. два три'
    response.should be_success
  end

  {'long tag request' => "не разграничивает стихи и прозу – это пространство для эксперимента и импровизации Искусство ba",
  'tag request of edge size' => "не разграничивает стихи и прозу – это пространство для эксперимента и импровизации Искусство b"}.each do |case_name, tag|
    it "should survive %s" % case_name do
      controller.stub!(:action_name).and_return('tags')
      controller.stub!(:params).and_return({})
      user = users(:chief)
      controller.instance_eval {@user = user}
      c = controller
      CACHE = MemCache.new 'localhost:11211' #no matter if it doesn't exist
      key = 'kroogi-production:views/1.3.6/' + controller.cache_key_with_locale(tag, !!c.params[:or],
                                                                                c.params[:page] || 1, c.setpagesize)
      puts "%s; %s" % [key, key.length]
      begin
        CACHE.get(key)
      rescue MemCache::MemCacheError => e
        puts "no connection to memcached, but who cares: %s" % e
      end
    end
  end

  it "it should escape user name for displaying, but only once" do
    get :index, :id => User.find_by_login('matisyahu1').id, :locale => 'en'
    response.should be_success
    assert_select 'div.account_middle span', '&nbsp;Matisyahu &quot;Grave Digga&quot; Kohen and blah-blah-blah and blah-blah...'
  end

  it "founders page should work" do
    get :founders, :id => User.find_by_login('kroogi-music').id
    response.should be_success
  end

  it "wall body: no wall posts case" do
    get :index, :id => User.find_by_login('joe').id, :locale => 'en'
    (!!(response.body.dup['No wall posts yet'])).should == true
  end

  it "wall posts should be shown if user have them" do
    get :index, :id => User.find_by_login('chief').id
    (!!(response.body.dup['No wall posts yet'])).should == false
  end

  it "Post Note form should have user_id field filled" do
    user = users(:ian_curtis)
    current_user = user
    controller.stub!(:current_user).and_return(current_user)
    
    project  = users(:joy_division)
    get :index, :id => project.id, :locale => 'en'
    assert_select "#user_notes_module #content_user_id[value=#{project.id}]"
  end

  describe "hide method" do

    it "should hide project" do
      @current_user = users(:dub)
      @current_actor = users(:joe)
      controller.stub!(:current_user).and_return(@current_actor)
      controller.stub!(:current_actor).and_return(@current_actor)

      post :hide, :id => @current_user.id

      response.should be_redirect
      flash[:success].should == "This account is now hidden"
      @current_user.reload.private.should == true
    end

    it "should reject if current_user not founder of hiding project" do
      @current_user = users(:dub)
      @current_actor = users(:joy_division)
      controller.stub!(:current_user).and_return(@current_user)
      controller.stub!(:current_actor).and_return(@current_actor)

      post :hide, :id => @current_user.id

      response.should be_redirect
      flash[:warning].should == "You can only hide your own accounts. Are you acting as the right user?"
      @current_user.reload.private.should == false
    end
  
  end

end
