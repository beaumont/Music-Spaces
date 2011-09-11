require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper
include SpecHelpersMixin

describe TagController do
  integrate_views

  before :each do
    Locale.set("en")
    use_new_caching_keys
  end

  def disable_search_for_guests
    APP_CONFIG.set(:search_for_guests, {:enabled => false})
  end

  def allow_search_for_guests
    APP_CONFIG.set(:search_for_guests, {:enabled => true, :interval => 5.seconds, :requests => 10})
  end

  it "index should redirect to login page if guests search disabled" do
    disable_search_for_guests
    get :index, :q => "филька шкворень", :type => 'users'
    response.should redirect_to(login_url)
  end

  it "index should bear with non latinic queries if current user" do
    disable_search_for_guests
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
    users = []
    User.should_receive(:search).and_return(users)
    users.should_receive(:total_entries)

    get :index, :q => "филька шкворень", :type => 'users'
    response.should be_success
  end

  it "should bear with tabs and spaces in query if current user" do
    disable_search_for_guests
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
    
    get :index, :q => "qu \tery", :type => 'content'
    response.should be_success
  end

  it "index should bear with non latinic queries if guest and search enabled for guests" do
    allow_search_for_guests
    users = []
    User.should_receive(:search).and_return(users)
    users.should_receive(:total_entries)

    get :index, :q => "филька шкворень", :type => 'users'
    response.should be_success
  end

  it "should bear with tabs and spaces in query if guest and search enabled for guests" do
    allow_search_for_guests

    get :index, :q => "qu \tery", :type => 'content'
    response.should be_success
  end

  it "should disable if more then 10 requests" do
    allow_search_for_guests
    Rails.cache.write('search_visits', {:visits => 10, :grain_ends_at => Time.current})

    get :index, :q => "qu \tery", :type => 'content'
    Rails.cache.write('search_visits', {:visits => 0, :grain_ends_at => Time.current})
    response.should be_success
    response.should render_template('shared/many_rpm.html.erb')
  end

end
