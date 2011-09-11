require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper

describe KroogiController do
  integrate_views

  before :each do
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
  end

  it "join_circles should work" do
    get :join_circles, :id => users(:joe).id
  end

  it "should can remove himself from kroogi" do
    user = users(:joe)
    Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.interested)
    old = Relationship.count

    get :remove_me, :id => user.id

    Relationship.count.should == old - 1
  end

  it "should not can remove user from Interested circle" do
    user = users(:joe)
    Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.interested)
    old = Relationship.count

    lambda {get :remove, :id => user.id}.should raise_error(Kroogi::NotPermitted)

    Relationship.count.should == old
  end

  it "should not can remove user from Interested circle if user not in the kroogi" do
    user = users(:joe)
    Relationship.delete_all(:user_id => @current_user.id, :related_user_id => user.id)
    old = Relationship.count

    lambda {get :remove, :id => user.id}.should raise_error(Kroogi::NotPermitted)

    Relationship.count.should == old
  end

  it "should not can remove himself from Interested circle if you not in the kroogi" do
    user = users(:joe)
    Relationship.delete_all(:user_id => user.id, :related_user_id => @current_user.id)
    old = Relationship.count

    lambda {get :remove_me, :id => user.id}.should raise_error(Kroogi::NotPermitted)

    Relationship.count.should == old
  end

  it "user should receive activity notification and email when other user deleted himself from kroogi" do
    user = users(:joe)
    user.preference.update_attribute(:email_notifications, Preference::EMAIL[:digest])
    Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.interested)
    old_r = Relationship.count
    old_a = Activity.count
    old_am = ActivityMail.count

    get :remove_me, :id => user.id

    Relationship.count.should == old_r - 1
    Activity.count.should == old_a + 1
    ActivityMail.count.should == old_am + 1

    activity = Activity.last
    activity.user_id.should == user.id
    activity.from_user_id.should == @current_user.id
    activity.activity_type_id.should == Activity::ACTIVITIES[:removed_from_circle][:id]
    activity.content.should == user.circle(Relationshiptype.interested)
    activity.show.should == true
  end

  it "user should not receive email when other user deleted himself from kroogi if he don't whant email" do
    user = users(:joe)
    user.preference.update_attributes(:email_notifications => Preference::EMAIL[:digest],
                                     :notify_leaves_interested_circle => false)
    Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.interested)
    old_r = Relationship.count
    old_a = Activity.count
    old_am = ActivityMail.count

    get :remove_me, :id => user.id

    Relationship.count.should == old_r - 1
    Activity.count.should == old_a + 1
    ActivityMail.count.should == old_am

    activity = Activity.last
    activity.user_id.should == user.id
    activity.from_user_id.should == @current_user.id
    activity.activity_type_id.should == Activity::ACTIVITIES[:removed_from_circle][:id]
    activity.content.should == user.circle(Relationshiptype.interested)
    activity.show.should == true
  end

  it "user should not see activity notification when other user deleted himself from kroogi if he don't whant this notification" do
    user = users(:joe)
    user.preference.update_attributes(:email_notifications => Preference::EMAIL[:digest],
                                     :kroogi_notify_leaves_interested_circle => false)
    Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.interested)
    old_r = Relationship.count
    old_a = Activity.count
    old_am = ActivityMail.count

    get :remove_me, :id => user.id

    Relationship.count.should == old_r - 1
    Activity.count.should == old_a + 1
    ActivityMail.count.should == old_am + 1

    activity = Activity.last
    activity.user_id.should == user.id
    activity.from_user_id.should == @current_user.id
    activity.activity_type_id.should == Activity::ACTIVITIES[:removed_from_circle][:id]
    activity.content.should == user.circle(Relationshiptype.interested)
    activity.show.should == false
  end

  it "user should move to the friends when someone remove him from his family circle" do
    user = users(:joe)
    relationship1 = Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.family)
    Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.family)
    old = Relationship.count

    get :remove, :id => user.id

    Relationship.count.should == old
    
    relationship1.reload
    relationship1.user_id.should == @current_user.id
    relationship1.related_user_id.should == user.id
    relationship1.relationshiptype_id.should == Relationshiptype.friends
  end

  it "both (Basic/Advanced) users should move to the friends when someone remove other from his family circle" do
    user = users(:joe)
    relationship1 = Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.family)
    relationship2 = Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.family)
    old = Relationship.count

    get :remove, :id => user.id

    Relationship.count.should == old

    relationship1.reload
    relationship1.user_id.should == @current_user.id
    relationship1.related_user_id.should == user.id
    relationship1.relationshiptype_id.should == Relationshiptype.friends

    relationship2.reload
    relationship2.user_id.should == user.id
    relationship2.related_user_id.should == @current_user.id
    relationship2.relationshiptype_id.should == Relationshiptype.friends
  end

  it "both (Basic/Advanced) users should move to the interested when someone remove other from his friends circle" do
    user = users(:joe)
    relationship1 = Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.friends)
    relationship2 = Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.friends)
    old = Relationship.count

    get :remove, :id => user.id

    Relationship.count.should == old

    relationship1.reload
    relationship1.user_id.should == @current_user.id
    relationship1.related_user_id.should == user.id
    relationship1.relationshiptype_id.should == Relationshiptype.interested

    relationship2.reload
    relationship2.user_id.should == user.id
    relationship2.related_user_id.should == @current_user.id
    relationship2.relationshiptype_id.should == Relationshiptype.interested
  end

  it "both (Basic/Advanced) users should move to the friends when someone remove himself from his family circle" do
    user = users(:joe)
    relationship1 = Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.family)
    relationship2 = Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.family)
    old = Relationship.count

    get :remove_me, :id => user.id

    Relationship.count.should == old

    relationship1.reload
    relationship1.user_id.should == @current_user.id
    relationship1.related_user_id.should == user.id
    relationship1.relationshiptype_id.should == Relationshiptype.friends

    relationship2.reload
    relationship2.user_id.should == user.id
    relationship2.related_user_id.should == @current_user.id
    relationship2.relationshiptype_id.should == Relationshiptype.friends
  end

  it "both (Basic/Advanced) users should move to the interested when someone remove himself from his friends circle" do
    user = users(:joe)
    relationship1 = Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.friends)
    relationship2 = Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.friends)
    old = Relationship.count

    get :remove_me, :id => user.id

    Relationship.count.should == old

    relationship1.reload
    relationship1.user_id.should == @current_user.id
    relationship1.related_user_id.should == user.id
    relationship1.relationshiptype_id.should == Relationshiptype.interested

    relationship2.reload
    relationship2.user_id.should == user.id
    relationship2.related_user_id.should == @current_user.id
    relationship2.relationshiptype_id.should == Relationshiptype.interested
  end

  it "only removed (Basic/Advanced) user should move to the fanclub when hi remove himself from project studio circle" do
    user = users(:joy_division)
    Thread.current['user'] = @current_user

    relationship1 = Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.family)
    relationship2 = Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.family)
    old = Relationship.count

    get :remove_me, :id => user.id

    Relationship.count.should == old

    relationship1.reload
    relationship1.user_id.should == @current_user.id
    relationship1.related_user_id.should == user.id
    relationship1.relationshiptype_id.should == Relationshiptype.family

    relationship2.reload
    relationship2.user_id.should == user.id
    relationship2.related_user_id.should == @current_user.id
    relationship2.relationshiptype_id.should == Relationshiptype.fanclub
  end

  it "only removed project should move to the friends when someone (Basic/Advanced) user remove him from his family circle" do
    user = users(:joy_division)
    Thread.current['user'] = @current_user

    relationship1 = Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.family)
    relationship2 = Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.family)
    old = Relationship.count

    get :remove, :id => user.id

    Relationship.count.should == old

    relationship1.reload
    relationship1.user_id.should == @current_user.id
    relationship1.related_user_id.should == user.id
    relationship1.relationshiptype_id.should == Relationshiptype.friends

    relationship2.reload
    relationship2.user_id.should == user.id
    relationship2.related_user_id.should == @current_user.id
    relationship2.relationshiptype_id.should == Relationshiptype.family
  end

  it "only removed (Basic/Advanced) user should move to the interested when hi remove himself from project fanclub circle" do
    user = users(:joy_division)
    Thread.current['user'] = @current_user

    relationship1 = Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.family)
    relationship2 = Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.fanclub)
    old = Relationship.count

    get :remove_me, :id => user.id

    Relationship.count.should == old

    relationship1.reload
    relationship1.user_id.should == @current_user.id
    relationship1.related_user_id.should == user.id
    relationship1.relationshiptype_id.should == Relationshiptype.family

    relationship2.reload
    relationship2.user_id.should == user.id
    relationship2.related_user_id.should == @current_user.id
    relationship2.relationshiptype_id.should == Relationshiptype.interested
  end

  it "only removed project should move to the interested when someone (Basic/Advanced) user remove him from his friends circle" do
    user = users(:joy_division)
    Thread.current['user'] = @current_user

    relationship1 = Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.friends)
    relationship2 = Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.family)
    old = Relationship.count

    get :remove, :id => user.id

    Relationship.count.should == old

    relationship1.reload
    relationship1.user_id.should == @current_user.id
    relationship1.related_user_id.should == user.id
    relationship1.relationshiptype_id.should == Relationshiptype.interested

    relationship2.reload
    relationship2.user_id.should == user.id
    relationship2.related_user_id.should == @current_user.id
    relationship2.relationshiptype_id.should == Relationshiptype.family
  end

  it "should not create any of the notifications when user moved to the friends from family circle" do
    user = users(:joe)
    Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.family)
    Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.family)
    old_r = Relationship.count
    old_a = Activity.count
    old_am = ActivityMail.count

    get :remove, :id => user.id

    Relationship.count.should == old_r
    Activity.count.should == old_a
    ActivityMail.count.should == old_am
  end

  it "should not create any of the notifications when user moved himself to the friends from family circle" do
    user = users(:joe)
    Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.family)
    Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.family)
    old_r = Relationship.count
    old_a = Activity.count
    old_am = ActivityMail.count

    get :remove_me, :id => user.id

    Relationship.count.should == old_r
    Activity.count.should == old_a
    ActivityMail.count.should == old_am
  end

end
