require File.dirname(__FILE__) + '/../spec_helper'

describe AccountSettingsController do
  integrate_views

  before :each do
    Locale.set("en")
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
  end

  it "donation_basket should work" do
    get :donation_basket
    response.should be_success
  end
end
