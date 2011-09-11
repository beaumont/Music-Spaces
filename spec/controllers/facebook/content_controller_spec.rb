require File.dirname(__FILE__) + '/../../spec_helper'

module Facebook
  describe  Facebook::ContentController do
    integrate_views
    include Facebooker::Rails::TestHelpers

    it "show downloadable album should work" do
      facebook_get :show, :id => contents(:music_album_for_facebook)
      assigns(:entry).should_not be_nil
      assigns(:current_fb_user).should_not be_nil
      entry = assigns(:entry)
      entry.class.name.should == MusicAlbum.name
    end

    it "show downloadable album should work from invite" do
      @session = Facebooker::Session.create('apikey', 'secretkey')
      facebook_get :content_from_invite, :id => contents(:music_album_for_facebook)
      assigns(:entry).should_not be_nil
      assigns(:current_fb_user).should_not be_nil
      entry = assigns(:entry)
      entry.class.name.should == MusicAlbum.name
    end

    it "show downloadable album should work for non logged in user" do
      facebook_get :show, :fb_sig_user=>nil, :id => contents(:music_album_for_facebook)
      assigns(:current_fb_user).should be_nil
      assert_response :success
    end

    it "download an album should work" do
      facebook_get :save_as, :id => contents(:exit_planet_dust)
      assigns(:entry).should_not be_nil
      album = assigns(:entry)
      album.class.name.should == MusicAlbum.name
      flash[:warning].should be_nil
    end
    
    it "should handle Facebooker::Session::MissingOrInvalidParameter exception" do
      facebook_get :show, :auth_token => "9abe7c1838cf1a9a16a19b07947cab1c", :installed => 1, :id => contents(:music_album_for_facebook)
      response.should be_success
    end

    describe "referral process" do
      before :each do
        @current_fb_user = users(:fb_stephane)
        controller.stub!(:current_fb_user).and_return(@current_fb_user)
      end

      it "show should handle referrer" do #Anya click on Stef profile content link
        @current_fb_user = users(:fb_anya)
        controller.stub!(:current_fb_user).and_return(@current_fb_user)

        facebook_get :show, :id => contents(:music_album_for_facebook).id,
                            :fb_referrer_id => users(:fb_stephane).facebook_id,
                            :fb_referral_type => 'profile'

        assigns(:entry).should_not be_nil
        entry = assigns(:entry)
        entry.class.name.should == MusicAlbum.name

        response.should be_success
      end

    end

    it "show without param specification should work" do
      get :show, :id => contents(:music_album_for_facebook).id
      response.should be_success
    end
  end
end
