Given /^I visit "(.*)"$/ do |url|
  visits(url)
end

Given /^I am on the home page$/ do
  visit "/"
end

Given /^I am on the login page$/ do
  visit "/login"
end

When /^I am redirected$/ do
  click_link('redirected')
end