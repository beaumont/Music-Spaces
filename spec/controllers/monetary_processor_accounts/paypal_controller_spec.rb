require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe MonetaryProcessorAccounts::PaypalController do  

  before :each do
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
  end

  it "create_account should work" do
    get :create_account, :edress => 'a@b.com'  
    response.should be_success
    assigns(:account).should_not be_nil
  end

end