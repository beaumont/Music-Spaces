require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper

describe MoneyController do
  integrate_views

  before :each do
    
    Locale.set("en")
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
  end
  
  it "should only allow owners to see their money info" do
    get :index, :id => 2 # chief
    response.should be_success
  end
  
  it "should not allow other people to see others money info" do
    lambda{
      get :index, :id => 3
    }.should raise_error(Kroogi::NotPermitted)
  end
  
  it "received should work for user" do
    get :donations_received, :id => 2
    response.should be_success
    assigns(:monetary_donations).should_not be_blank
    assert_in_delta 5.45, assigns(:usd_sum).to_f, 0.001, 'usd_sum'
  end

  ['created_at', 'item_name', 'gross_amount_usd'].each do |sort_by|
    ['donations_received', 'donations_made'].each do |from|
      it "%s should work with sorting by %s" % [from, sort_by] do
        get from, :id => 2, :dir => 'asc', :sort_by => sort_by
        response.should be_success
        assigns(:monetary_donations).should_not be_nil
      end
    end
  end

  it "received should work for content" do
    get :donations_received, :id => 3, :content_id => 1
    response.should be_success
    assigns(:monetary_donations).should_not be_blank
    {:usd_sum => 1.4}.each do |currency, amount|
      assert_in_delta amount.to_f, assigns(currency).to_f, 0.001, 'sum in %s' % currency
    end
  end

end
