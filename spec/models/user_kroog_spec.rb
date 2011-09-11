require File.dirname(__FILE__) + '/../spec_helper'

describe UserKroog do
  before(:each) do
    @user_kroog = UserKroog.new(:updated_by_id => 5,:created_by_id => 5, :user_id => 5)
    user = mock_model(User, :display_name => "John Travolta",:id =>5)
    account_setting = mock_model(AccountSetting, :paypal_email => "yahh@internet.com", :webmoney_wmr => "R000000000000")
    user.stub!(:account_setting).and_return(account_setting)
    @user_kroog.stub!(:user).and_return(user)
  end
end