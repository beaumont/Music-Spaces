require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SiteActivityLoggerForModels do

  before(:each) do
    Thread.current['user'] = users(:chief)
  end

  def changes_logs_count(change = 0)
    old_value = SiteActivityLog.count + change
    user = users(:chief)
    Album.create(:user_id => user.id, :cat_id => Content::CATEGORIES[:album][:id],
                 :relationshiptype_id => Relationshiptype.everyone, :is_in_gallery => true)
    new_value = SiteActivityLog.count

    assert_equal old_value, new_value
  end

  def logs_count_should_change
    changes_logs_count(1)
  end

  def logs_count_should_not_change
    changes_logs_count
  end

  it "shoud not log this action if ActivityLogConfig is blank" do
    logs_count_should_not_change
  end

  it "shoud not log this action if monitoring disabled" do
    SiteActivityLogConfig.create(:monitoring => false)
    logs_count_should_not_change
  end

  it "shoud log this action if monitoring enabled" do
    SiteActivityLogConfig.create(:monitoring => true, :all_users  => true)
    logs_count_should_change
  end

  it "shoud not log this action if all_users disabled and user not in list of logging users" do
    SiteActivityLogConfig.create(:monitoring => true, :all_users  => false)
    logs_count_should_not_change
  end

  it "shoud log this action if all_users disabled and user in list of logging users" do
    SiteActivityLogConfig.create(:monitoring => true, :all_users  => false)
    user = users(:chief)
    SiteActivityLogUser.create(:user_id => user.id, :login => user.login)
    logs_count_should_change
  end

  it "should fill data to log" do
    SiteActivityLogConfig.create(:monitoring => true, :all_users  => true)
    user = users(:chief)
    album = Album.create(:user_id => user.id, :cat_id => Content::CATEGORIES[:album][:id],
                 :relationshiptype_id => Relationshiptype.everyone, :is_in_gallery => true)

    log = SiteActivityLog.last

    assert_equal log.login, "chief"
    assert_equal log.user_id, 2
    assert_equal log.actor_login, "chief"
    assert_equal log.actor_id, 2
    assert_equal log.content_type, "Album"
    assert_equal log.content_id, album.id
    log.content.should_not == ""
  end

end