require File.dirname(__FILE__) + '/../spec_helper'

describe CollectionInclusion do

  it "repopulate_all_inclusions shouldn't introduce CollectionInclusions dupes" do
    CollectionProject.repopulate_all_inclusions

    cis = users('kroogi-music').inclusions.select {|ci| ci.child_pac.body_project == users(:joy_division)}
    cis.size.should == 1 #there should not be 2 inclusions of JD in KM
    cis[0].should be_direct #direct child should have preference
  end

end
