require File.dirname(__FILE__) + '/../spec_helper'

describe HomeController do
  integrate_views

  def changes_logs_count(user, change = 0)
    Locale.set("en")
    @current_user = user
    controller.stub!(:current_user).and_return(@current_user)
    request.stub!(:accept_language).and_return('ru')

    old_value = SiteActivityLog.count + change
    get :index
    new_value = SiteActivityLog.count

    assert_equal old_value, new_value
  end

  def logs_count_should_change(user)
    changes_logs_count(user, 1)
  end

  def logs_count_should_not_change(user)
    changes_logs_count(user)
  end

  it "shoud not log this action if ActivityLogConfig is blank" do
    logs_count_should_not_change users(:chief)
  end

  it "shoud not log this action if monitoring disabled" do
    SiteActivityLogConfig.create(:monitoring => false)
    logs_count_should_not_change users(:chief)
  end

  it "shoud log this action if monitoring enabled" do
    SiteActivityLogConfig.create(:monitoring => true,:guests => false, :bots => false, :all_users  => true)
    logs_count_should_change users(:chief)
  end

  it "shoud not log this action if guests disabled and user is guest" do
    SiteActivityLogConfig.create(:monitoring => true,:guests => false, :bots => false)
    logs_count_should_not_change Guest.new
  end

  it "shoud log this action if guests enabled and user is guest" do
    SiteActivityLogConfig.create(:monitoring => true,:guests => true, :bots => false)
    logs_count_should_change Guest.new
  end

  it "shoud not log this action if bots disabled and user is bot" do
    SiteActivityLogConfig.create(:monitoring => true,:guests => true, :bots => false)
    @request.stub!(:user_agent).and_return "Googlebot/2.X (+http://www.googlebot.com/bot.html)"
    logs_count_should_not_change Guest.new
  end

  it "shoud log this action if bots enabled and user is bot" do
    SiteActivityLogConfig.create(:monitoring => true, :guests => true, :bots => true)
    @request.stub!(:user_agent).and_return "Googlebot/2.X (+http://www.googlebot.com/bot.html)"
    logs_count_should_change Guest.new
  end

  it "shoud not log this action if all_users disabled and user not in list of logging users" do
    SiteActivityLogConfig.create(:monitoring => true, :all_users  => false)
    logs_count_should_not_change users(:chief)
  end

  it "shoud log this action if all_users disabled and user in list of logging users" do
    SiteActivityLogConfig.create(:monitoring => true, :all_users  => false)
    user = users(:chief)
    SiteActivityLogUser.create(:user_id => user.id, :login => user.login)
    logs_count_should_change user
  end

  it "should fill data to log" do
    SiteActivityLogConfig.create(:monitoring => true, :all_users  => true)
    Locale.set("en")
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
    request.stub!(:accept_language).and_return('ru')

    get :index

    log = SiteActivityLog.last

    log.ip.should == "0.0.0.0"
    log.url.should == "http://test.host/home"
    log.path.should == "/home"
    log.referrer.should == nil
    log.user_agent.should == "Rails Testing"
    log.login.should == "chief"
    log.user_id.should == 2
    log.actor_login.should == "chief"
    log.actor_id.should == 2
  end
  
end