require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NewContent do

  it "truncate should work" do
    NewContent.fill_with_content(5)
    NewContent.count.should == 5
    NewContent.truncate(4)
    NewContent.count.should == 4
    NewContent.truncate(5)
    NewContent.count.should == 4
  end

end
