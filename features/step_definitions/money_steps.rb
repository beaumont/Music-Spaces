Given /^an administrator authorizes payments for "(.*)"$/ do |login|
  User.find_by_login(login).account_setting.approve_donations!
end