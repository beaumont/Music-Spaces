require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe ExtraFieldset::Inbox do
  before(:each) do
    @valid_attributes = {
      :inbox_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ExtraFieldset::Inbox.create!(@valid_attributes)
  end
end
