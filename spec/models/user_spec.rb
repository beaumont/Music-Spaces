require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  include UserSpecHelper
  
  before(:each) do
    @user = BasicUser.new(valid_attributes)
  end
  
  it "should have a valid username" do
    
    # an invalid name should not pass
    @user.login = "developer"
    @user.should_not be_valid
    @user.errors.on_base.should eql("That Kroogi name is not allowed")
    
    # a name that looks like an invalid name should pass
    @user.login = "wwworldwidepants"
    @user.should be_valid
  end

  it "should have a valid birthdate" do
    user = users(:too_young_guy)
    user.should_not be_valid
    assert_errors(user, :on => :birthdate, :match => /Users thirteen/)
  end

  it "should require a password to change email address" do
    user = users(:joe)
    user.email = "new_email@email.com"
    user.should_not be_valid
    assert_errors(user, :on => :email, :match => /password/)
  end

  {false => {
      "зaraza@email.com" => 
        "starting with nonlatinic symbol"},
   true => {
     'one@two.com' => 'ordinary email',
     'one-two.three@some.com' => 'dots and hyphens'}}.each do |valid_expected, params|
    params.each do |email, description|
      it "should #{valid_expected ? 'accept' : 'reject'} email " + description do
        @user.email = email
        if valid_expected
          assert_no_errors(@user, :validate => true)
        else
          assert_errors(@user, :validate => true, :on => :email)
        end
      end
    end
  end

  it "email uniqueness must be checked for new users" do
    @user.email = users(:joe).email
    @user.email.should_not be_blank #pre-requisite
    assert_errors(@user, :validate => true, :match => /already taken/)
  end

  it "email uniqueness must be checked for existing users" do
    user = users(:chief)
    user.email = users(:joe).email
    user.email.should_not be_blank #pre-requisite
    assert_errors(user, :validate => true, :match => /already taken/)
  end

  it "email uniqueness should not be checked for existing users if email isn't changed" do
    user = users(:matisyahu1)
    user.display_name = 'Matisyahu The King'
    user.email.should_not be_blank
    assert_no_errors(user, :validate => true)
  end
  
  it "should have an account_setting after create" do
    with_current_user(mock_model(User, :id => 6)) do
      @user.save!
      @user.account_setting.should_not be_nil
      @user.preference.should_not be_nil
    end
  end

  it "content_album_ids should work" do
    user = users(:joy_division)
    {:joydivisions_closer_album => [:jd_closer_isolation_track, :jd_closer_decades_track],
            :joydivisions_up_folder => [:jd_up_disorder_track, :jd_up_insight_track]}.each do |album, tracks|

      tracks.each do |track|
        #pre-requisite
        contents(track).albums.to_a.include?(contents(album)).should == true
        
        #the check
        user.content_album_ids[contents(track).id].should == contents(album).id        
      end
    end
  end

  [['en', 'en'], ['ru', :all]].each do |locale, result|
    [BasicUser.new, Guest.new].each do |user|
      it "welcome_content_languages should work for %s in %s" % [user.class.name, locale] do
        I18n.locale = locale
        user.welcome_content_languages.should == result
      end
    end
  end
  
  it "list of albums for new Music Album" do
    user = users(:joy_division)
    user.albums.size.should == 6
    albums_for_menu = user.albums(:content => MusicAlbum.new, :for_menu => true)

    _albums_for_menu = user.albums.select {|a| !a.is_a?(MusicAlbum) && !a.downloadable? }

    albums_for_menu.size.should == _albums_for_menu.size
    albums_for_menu.first.should == [_albums_for_menu.first.title, _albums_for_menu.first.id]
  end

  protected
  
  def valid_attributes(opt={})
    {:login => 'bobby', :password => 'testing', :password_confirmation => 'testing', :email => 'bobby@example.com', :birthdate => "1985-06-22"}.merge(opt)
  end
end