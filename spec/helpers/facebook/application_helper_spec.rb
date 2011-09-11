require File.dirname(__FILE__) + '/../../spec_helper'

class Helper
  include Facebook::ApplicationHelper
  include Facebooker::Rails::TestHelpers
  include ActionView::Helpers::SanitizeHelper
  extend ActionView::Helpers::SanitizeHelper::ClassMethods
end

module Facebook
  describe  Facebook::ApplicationHelper do

    before :each do
      @h = Helper.new
      @current_fb_user = users(:fb_stephane)
      @h.stub!(:current_fb_user).and_return(@current_fb_user)
    end

    it "html tags should not be truncated" do
      @h.kdf_simple('one two<a href="x">x</a>', :characters => 11).should include(">< Read less</a>")
      @h.kdf_simple('one two<strong>x y</strong>', :characters => 18).should include(">< Read less</a>")
      @h.kdf_simple('one<br/>two<br/>three<br/>', :characters => 12).should include(">< Read less</a>")
      @h.kdf_simple('one<br/>two<br/three<br/......', :characters => 6).should include(">< Read less</a>")
    end

    it "download impact on artist should work" do
      music_albums = [contents(:music_album_for_facebook),contents(:the_extremist)]
      count = @h.download_impact_on_artist(music_albums)
      count.should == "<span class='quantity'>2 People</span>"
    end

    it "donate impact on artist should work" do
      music_albums = [contents(:music_album_for_facebook),contents(:the_extremist)]
      count = @h.donate_impact_on_artist(music_albums)
      count.should == "<span class='quantity'>2 Contributions</span>"
    end

    it "invite impact on artist should work" do
      music_albums = [contents(:music_album_for_facebook),contents(:the_extremist)]
      count = @h.invite_impact_on_artist(music_albums)
      count.should == 2
    end

  end
end

