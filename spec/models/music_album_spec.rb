require File.dirname(__FILE__) + '/../spec_helper'

describe MusicAlbum do

  it "should calculate tracks" do
    contents(:joydivisions_closer_album).number_of_tracks.should == 2
  end
  
end
