require File.dirname(__FILE__) + '/../../spec_helper'

describe '/preference/account' do

  before(:each) do
    current_user = users(:ian_curtis)
    user = users(:joy_division)

    assigns[:user] = user
    session[:user] = current_user.id
    assigns[:projects_info] = [current_user, user]
    assigns[:preference] = user.preference
    assigns[:profile] = user.profile
  end

  it "checkbox 'Show others when I view their content' should not be checked" do
    render '/preference/account'
    response.should have_tag('form[action=?][method=?]','/preference/account_update','post') do |f|
     f.should_not have_tag('input[name=?][type=?][checked=?]','preference[anonymous_stats]','checkbox', "checked")
     f.should have_tag('input[name=?][type=?]','preference[anonymous_stats]','checkbox')
    end
  end

  it "checkbox 'Show others when I view their content' should be checked" do
    assigns[:preference].stub!(:anonymous_stats).and_return true
    render '/preference/account'
    response.should have_tag('form[action=?][method=?]','/preference/account_update','post') do |f|
     f.should have_tag('input[name=?][type=?][checked=?]','preference[anonymous_stats]','checkbox', "checked")
    end
  end

end