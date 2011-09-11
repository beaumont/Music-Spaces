require File.dirname(__FILE__) + '/../spec_helper'

describe Project do
  before(:each) do
    @project = Project.new
  end

  it "should not allow reserved names" do
    @project.login = "ADMIN"
    @project.email = 'krasota@krasota.com'
    @project.valid?.should == false
    @project.errors.on(:base).should == "That Kroogi name is not allowed"
  end
end
