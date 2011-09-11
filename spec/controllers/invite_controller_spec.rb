require File.dirname(__FILE__) + '/../spec_helper'

describe InviteController do

  before :each do
    Locale.set("en")
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
    controller.stub!(:current_actor).and_return(@current_user)
  end

  it "follow_users should be success when data is present" do
    flash_data = {
      :suggest_following => [],
      :already_followed => [],
      :external_emails => [],
      :already_invited_or_followers => [],
      :start_following_step => true
    }
    @current_user.stub!(:get_and_delete_flasha).and_return flash_data
    post :follow_users
    response.should be_success
  end

  it "follow_users should be success when data is nil" do
    @current_user.stub!(:get_and_delete_flasha).and_return nil
    post :follow_users
    response.should be_success
  end

  it "should follow user" do
    user = users(:joe)
    old = Relationship.count
    post :join, :id => user.id, :circle => Relationshiptype.interested
    Relationship.count.should == old + 1
  end

  it "should not follow user if followed count > 1000" do
    @current_user.stub!(:can_not_follow?).and_return true
    user = users(:joe)
    old = Relationship.count
    post :join, :id => user.id, :circle => Relationshiptype.interested
    Relationship.count.should == old
  end

  it "should follow user and create activity notify and email" do
    user = users(:joe)
    user.preference.update_attribute(:email_notifications, Preference::EMAIL[:digest])
    old_r = Relationship.count
    old_a = Activity.count
    old_am = ActivityMail.count

    post :join, :id => user.id, :circle => Relationshiptype.interested

    Relationship.count.should == old_r + 1
    Activity.count.should == old_a + 1
    ActivityMail.count.should == old_am + 1

    activity = Activity.last
    activity.user_id.should == user.id
    activity.from_user_id.should == @current_user.id
    activity.activity_type_id.should == Activity::ACTIVITIES[:added_as_friend][:id]
    activity.content.should == user.circle(Relationshiptype.interested)
    activity.show.should == true
  end

  it "should follow user and create activity notify without email" do
    user = users(:joe)
    user.preference.update_attributes(:email_notifications => Preference::EMAIL[:digest],
                                      :notify_joins_interested_circle => false)
    old_r = Relationship.count
    old_a = Activity.count
    old_am = ActivityMail.count

    post :join, :id => user.id, :circle => Relationshiptype.interested

    Relationship.count.should == old_r + 1
    Activity.count.should == old_a + 1
    ActivityMail.count.should == old_am

    activity = Activity.last
    activity.user_id.should == user.id
    activity.from_user_id.should == @current_user.id
    activity.activity_type_id.should == Activity::ACTIVITIES[:added_as_friend][:id]
    activity.content.should == user.circle(Relationshiptype.interested)
    activity.show.should == true
  end

  it "should follow user and create invisible activity notify with email" do
    user = users(:joe)
    user.preference.update_attributes(:email_notifications => Preference::EMAIL[:digest],
                                      :kroogi_notify_joins_interested_circle => false)
    old_r = Relationship.count
    old_a = Activity.count
    old_am = ActivityMail.count

    post :join, :id => user.id, :circle => Relationshiptype.interested

    Relationship.count.should == old_r + 1
    Activity.count.should == old_a + 1
    ActivityMail.count.should == old_am + 1

    activity = Activity.last
    activity.user_id.should == user.id
    activity.from_user_id.should == @current_user.id
    activity.activity_type_id.should == Activity::ACTIVITIES[:added_as_friend][:id]
    activity.content.should == user.circle(Relationshiptype.interested)
    activity.show.should == false
  end

  it "both users should move to friends if invite accepted" do
    user = users(:joe)
    Thread.current['user'] = @current_user
    old = Relationship.count
    invite = Invite.create(:user_id => @current_user.id, :inviter_id => user.id, :circle_id => Relationshiptype.friends)
    post :accept, :id => invite.id

    Relationship.count.should == old + 2
    Relationship.exists?(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.friends).should == true
    Relationship.exists?(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.friends).should == true
  end

  it "both users should move to friends if invite accepted and one user in interested" do
    user = users(:joe)
    Thread.current['user'] = @current_user
    relationship = Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.interested)
    old = Relationship.count
    invite = Invite.create(:user_id => @current_user.id, :inviter_id => user.id, :circle_id => Relationshiptype.friends)

    post :accept, :id => invite.id

    Relationship.count.should == old + 1
    Relationship.exists?(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.friends).should == true

    relationship.reload
    relationship.user_id.should == user.id
    relationship.related_user_id.should == @current_user.id
    relationship.relationshiptype_id.should == Relationshiptype.friends
  end

  it "both users should move to family if invite accepted" do
    user = users(:joe)
    Thread.current['user'] = @current_user
    old = Relationship.count
    invite = Invite.create(:user_id => @current_user.id, :inviter_id => user.id, :circle_id => Relationshiptype.family)
    post :accept, :id => invite.id

    Relationship.count.should == old + 2
    Relationship.exists?(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.family).should == true
    Relationship.exists?(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.family).should == true
  end

  it "only invited user should move to fanclub if invite accepted" do
    user = users(:joy_division)
    Thread.current['user'] = @current_user
    old = Relationship.count
    invite = Invite.create(:user_id => @current_user.id, :inviter_id => user.id, :circle_id => Relationshiptype.fanclub)
    post :accept, :id => invite.id

    Relationship.count.should == old + 1
    Relationship.exists?(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.fanclub).should == false
    Relationship.exists?(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.fanclub).should == true
  end

  it "only invited user should move to studio if invite accepted" do
    user = users(:joy_division)
    Thread.current['user'] = @current_user
    old = Relationship.count
    invite = Invite.create(:user_id => @current_user.id, :inviter_id => user.id, :circle_id => Relationshiptype.family)

    post :accept, :id => invite.id

    Relationship.count.should == old + 1
    Relationship.exists?(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.family).should == false
    Relationship.exists?(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.family).should == true
  end

  it "should send invitation and email to user" do
    user = users(:joe)
    relationship = Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.interested)
    user.preference.update_attribute(:email_notifications, Preference::EMAIL[:digest])
    old_i = Invite.count
    old_am = ActivityMail.count

    post :send_invites, :id => @current_user.id, :circle_id => Relationshiptype.friends, :to_invite => ["uid:#{user.id}"]

    ActivityMail.count.should == old_am + 1
    Invite.count.should == old_i + 1
  end

  it "should not send email with invitation if user don't whant" do
    user = users(:joe)
    relationship = Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.interested)
    user.preference.update_attributes(:email_notifications => Preference::EMAIL[:digest],
                                     :notify_invitations_and_requests => false)
    old_i = Invite.count
    old_am = ActivityMail.count

    post :send_invites, :id => @current_user.id, :circle_id => Relationshiptype.friends, :to_invite => ["uid:#{user.id}"]

    ActivityMail.count.should == old_am
    Invite.count.should == old_i + 1
  end

  it "should send request invite and email" do
    user = users(:joe)
    Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.interested)
    user.preference.update_attribute(:email_notifications, Preference::EMAIL[:digest])
    old_ir = InviteRequest.count
    old_am = ActivityMail.count

    get :closer_add, :id => user.id, :circle => Relationshiptype.friends

    InviteRequest.count.should == old_ir + 1
    ActivityMail.count.should == old_ir + 1
  end

  it "should not send request invite if user not follow he" do
    user = users(:joe)
    user.preference.update_attribute(:email_notifications, Preference::EMAIL[:digest])
    old_ir = InviteRequest.count
    old_am = ActivityMail.count

    get :closer_add, :id => user.id, :circle => Relationshiptype.friends

    flash[:warning].should == "No request sent: you can not send requests to the not followed users".t
    InviteRequest.count.should == old_ir
    ActivityMail.count.should == old_ir
  end

  it "should not send email when request invite created if user don't whant" do
    user = users(:joe)
    Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.interested)
    user.preference.update_attributes(:email_notifications => Preference::EMAIL[:digest],
                                     :notify_invitations_and_requests => false)
    old_ir = InviteRequest.count
    old_am = ActivityMail.count

    get :closer_add, :id => user.id, :circle => Relationshiptype.friends

    InviteRequest.count.should == old_ir + 1
    ActivityMail.count.should == old_ir
  end

  it "should not send request invite to the family circle" do
    user = users(:joe)
    old = InviteRequest.count
    Relationship.create(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.interested)
    user.circle(Relationshiptype.family).update_attributes(:open => false, :can_request_invite => false)
    
    get :closer_add, :id => user.id, :circle => Relationshiptype.family

    flash[:warning].should == "No request sent: you can not send request to this circle".t
    InviteRequest.count.should == old
  end

  it "should add user when request granted" do
    user = users(:joe)
    Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.interested)
    irequest = InviteRequest.create(:user_id => user.id, :circle_id => Relationshiptype.friends, :wants_to_join_id => @current_user.id)
    old_i = Invite.count
    old_r = Relationship.count

    post :send_invites, :id => @current_user, :circle_id => Relationshiptype.friends, :invite_id => irequest.id, :to_invite => "uid:#{user.id}"

    flash[:success].should_not be_blank
    irequest.reload
    irequest.state.should == 'accepted'
    Invite.count.should == old_i
    Relationship.count.should == old_r + 1
    Relationship.exists?(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.friends).should == true
    Relationship.exists?(:user_id => user.id, :related_user_id => @current_user.id, :relationshiptype_id => Relationshiptype.friends).should == true
  end

  it "should create notification and email when request granted" do
    user = users(:joe)
    user.preference.update_attribute(:email_notifications, Preference::EMAIL[:digest])
    Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.interested)
    irequest = InviteRequest.create(:user_id => user.id, :circle_id => Relationshiptype.friends, :wants_to_join_id => @current_user.id)
    old_a = Activity.count
    old_am = ActivityMail.count

    post :send_invites, :id => @current_user, :circle_id => Relationshiptype.friends, :invite_id => irequest.id, :to_invite => "uid:#{user.id}"

    irequest.reload
    irequest.state.should == 'accepted'
    Activity.count.should == old_a + 2
    ActivityMail.count.should == old_am + 2
  end

  it "should create notification and email when request granted" do
    user = users(:joe)
    user.preference.update_attributes(:email_notifications => Preference::EMAIL[:digest],
                                     :notify_invitations_and_requests => false)
    Relationship.create(:user_id => @current_user.id, :related_user_id => user.id, :relationshiptype_id => Relationshiptype.interested)
    irequest = InviteRequest.create(:user_id => user.id, :circle_id => Relationshiptype.friends, :wants_to_join_id => @current_user.id)
    old_a = Activity.count
    old_am = ActivityMail.count

    post :send_invites, :id => @current_user, :circle_id => Relationshiptype.friends, :invite_id => irequest.id, :to_invite => "uid:#{user.id}"

    irequest.reload
    irequest.state.should == 'accepted'
    Activity.count.should == old_a + 2
    ActivityMail.count.should == old_am
  end

end