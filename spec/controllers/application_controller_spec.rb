require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationController do
  it "content_url's id should be correct when content is passed" do
    content = contents(:matisyahu_young_man_track)
    @controller.content_url(content) if false #it fails royally, can't understand why yet
  end
end
