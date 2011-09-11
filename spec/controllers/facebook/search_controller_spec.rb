require File.dirname(__FILE__) + '/../../spec_helper'

module Facebook
  describe  Facebook::SearchController do
    integrate_views
    include Facebooker::Rails::TestHelpers

    it "albums action should display popular albums" do
      facebook_get :albums, :filter => 'popular'
      response.should be_success
    end

    it "albums action should display newest albums" do
      facebook_get :albums, :filter => 'new'
      response.should be_success
    end

    it "albums action should display albums with async request" do
      xhr :post, 'albums', :page => 2
      response.should be_success
    end

    it "artists action should display popular artists" do
      facebook_get :artists, :filter => 'popular'
      response.should be_success
    end

    it "artists action should display newest artists" do
      facebook_get :artists, :filter => 'newest'
      response.should be_success
    end

    it "artists action should display artists with async request" do
      xhr :post, 'artists', :page => 2
      response.should be_success
    end

    it "from_invite action should display albums" do
      facebook_get :from_invite, :filter => nil
      response.should be_success
    end

    it "index should display search results" do
      term = "Anya"
      MusicAlbum.should_receive(:search).once.with(term, {:retry_stale=>true}).and_return do
        @music_albums = []
      end

      ::User.should_receive(:search).once.with(term, {:retry_stale=>true}).and_return do
        @projects = []
      end

      facebook_get :index, :term => term
      assigns(:music_albums).should_not be_nil
      assigns(:projects).should_not be_nil
      response.should be_success
    end

  end
end