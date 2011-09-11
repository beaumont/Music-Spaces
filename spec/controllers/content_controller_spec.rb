require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper

describe ContentController do
  integrate_views
  include SpecHelpersMixin
  fixtures :karma_points

  before :each do
    Locale.set("en")
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
  end

  def test_show_content(content)
    content = contents(content) if content.is_a?(Symbol)
    get :show, :id => content.to_verbose_param, :locale => 'en', :format => 'html'
    response.should be_success
    assigns(:entry).should_not be_nil
  end

  it "viewing other's content should work for admins" do
    content = contents(:joes_public_blog_entry)
    @controller.instance_eval {can_view_donations_for?(content.user)}.should == true
    test_show_content(content)
  end

  it "viewing own donatable album should work" do
    user = users(:ian_curtis)
    controller.stub!(:current_user).and_return(user)
    content = contents(:joydivisions_up_folder)
    user.is_self_or_owner?(content.user).should == true
    controller.skip_path_verification = true
    test_show_content(content)
  end
  
  it "should create a karma point for a track when downloading" do
    point = karma_points(:click)
    track = contents(:jd_closer_isolation_track)
    KarmaPoint.should_receive(:create_from_id).with(point.id, :content => track, :action => :download)
    get :download, {:id => track.id}, {:karma_point_id => point.id}
    flash[:error].should be_blank
  end

  it "downloading MA's zip should work" do
    get :download_bundle, :id => contents(:matisyahu_youth_album_zip)
    response.should be_redirect
    flash[:warning].should be_nil
  end

  it "downloading MA's zip  should work for guests" do
    current_user = Guest.new
    controller.stub!(:current_user).and_return(current_user)
    controller.stub!(:handle_dl_link_expiration).and_return(true)

    get :download_bundle, :id => contents(:matisyahu_youth_album_zip)

    assigns(:album).should_not be_nil
  end

  it "inviting guest to circle of downloaded album should work" do
    current_user = Guest.new
    controller.stub!(:current_user).and_return(current_user)
    post :invite_guest_to_user_circle, :guest_invite => {:user_email => 'one@two.com', :inviter_id => users(:chief).id}
    response.should be_success
    assert_no_errors(assigns(:guest_invite))
  end
  
  it "inviting guest to circle of downloaded album should handle errors" do
    current_user = Guest.new
    controller.stub!(:current_user).and_return(current_user)
    post :invite_guest_to_user_circle, :guest_invite => {:user_email => 'uno!', :inviter_id => users(:chief).id}
    response.should be_success
    invite = assigns(:guest_invite)
    assert_errors(invite, :match => /email/)
    invite.should be_new
  end

  it "show downloadable album should work for guests" do
    current_user = Guest.new
    controller.stub!(:current_user).and_return(current_user)
    content = contents(:joydivisions_up_folder)
    controller.skip_path_verification = true
    test_show_content(content)
  end
  
  it "should create a karma point for an album when downloading" do
    current_user = Guest.new
    controller.stub!(:current_user).and_return(current_user)
    controller.stub!(:handle_dl_link_expiration).and_return(true)
    
    point = karma_points(:click)
    album = contents(:matisyahu_youth_album_zip)
    
    KarmaPoint.should_receive(:create_from_id).with(point.id, :content => album, :action => :download)
    get :download_bundle,{:id => album.id}, {:karma_point_id => point.id}
  end

  it "viewing own music album should work" do
    content = contents(:squarepusher_weird_album)
    controller.instance_eval {current_user}.is_self_or_owner?(content.user).should == true
    controller.skip_path_verification = true
    test_show_content(content)
  end

  it "removing content from regular album shouldn't delete content" do
    set_current_user(:ian_curtis)
    album = contents(:jd_up_insight_track)
    post :remove_from_album, :id => album.id, :album_id => contents(:joydivisions_up_folder), :format => 'js'
    response.should be_success
    album.reload
  end

  it "removing content from music album should delete content" do
    set_current_user(:ian_curtis)
    album = contents(:jd_closer_decades_track)
    post :remove_from_album, :id => album.id, :album_id => contents(:joydivisions_closer_album), :format => 'js'
    response.should be_success
    Track.find_by_id(album.id).should == nil
  end

  it "track upload tool should show for MA if zip is not generated already" do
    set_current_user(:ian_curtis)
    album = contents(:joydivisions_closer_album)
    controller.skip_path_verification = true
    get :show, :id => album.to_verbose_param, :locale => 'en', :format => 'html'
    #assert_select "[class=post_options]" #this is noisy
    (!!(response.body.dup =~ /content_post_options/)).should == true
  end

  it "track upload tool should not show for MA if zip is generated already" do
    set_current_user(:matisyahu)
    album = contents(:matisyahu_youth_album)
    get :show, :id => album.to_verbose_param, :locale => 'en', :format => 'html'
    #assert_select "[class=post_options]", false #this is noisy
    (!!(response.body.dup =~ /content_post_options/)).should == false
  end

  #we rely on this in other tests here
  it "Matisyahu's 'Youth' album should be downloadable" do
    contents(:matisyahu_youth_album).should be_downloadable
  end

  it "'Add comment' should be shown for MA's track if zip is generated already" do
    set_current_user(:ian_curtis)
    track = contents(:matisyahu_young_man_track)
    get :show, :id => track.to_verbose_param, :locale => 'en', :format => 'html'
    pending "TODO: fix me"
    response.body.dup.should =~ /Click to Leave Comment/
  end

  it "recent action should work"do
    NewContent.fill_with_content(5)
    get :recent
    response.should be_success
    assigns(:content).should_not be_blank
  end

  it "non-donatable FWD should show download link to guest" do
    content = contents(:chiefs_sacred_album)
    content.class.should == FolderWithDownloadables
    content.should_not be_donatable
    controller.stub!(:current_user).and_return(Guest.new)
    controller.skip_path_verification = true
    get :show, :id => content.to_verbose_param, :locale => 'en', :format => 'html'
    response.body.dup.should =~ /content\/download_bundle/
  end
end
