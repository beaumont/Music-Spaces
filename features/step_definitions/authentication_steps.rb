Given /^a user is logged in as "(.*)"$/ do |login|  
  User.without_monitoring do
    @current_user = User.new(
      :login => login,
      :password => 'testing',
      :password_confirmation => 'testing',
      :email => "#{login}@example.com"
    )
    @current_user.profile = Profile.new
    @current_user.preference = Preference.new
    @current_user.activate
  end
  
  # Login as the new user
  visit "/login"
  fill_in("user[login]", :with => login)
  fill_in("password", :with => 'testing')
  click_button('Enter')
  response.body.should =~ /Home of #{login}/
  
  # Set up a profile
  visit "/home/wizard"
  fill_in("profile[country][answer]", :with => 'USA')
  fill_in("profile[city][answer]", :with => 'Anytown')
  fill_in("profile[tagline]", :with => 'I am testing')
  click_button('Done')
  click_link('redirected') # there is a redirect page here... why?
  response.body.should =~ /Your account has been configured/
end

When /^am redirected$/ do
  click_link('redirected')
end
