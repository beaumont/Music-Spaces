require File.dirname(__FILE__) + '/../spec_helper'

include AuthenticatedTestHelper

describe UserController do
  integrate_views

  it "switching from user to project should work" do
    user = users(:ian_curtis)
    controller.instance_eval {self.current_user = user}
    controller.instance_eval {current_actor}.should == user #prerequisite
    get :switch, :id => users(:joy_division).id
    controller.instance_eval {current_actor}.should == users(:joy_division)
  end

  it "switching from project to user should work" do
    user = users(:ian_curtis)
    project = users(:joy_division)
    user.update_attributes!(:on_behalf_id => project.id)
    controller.instance_eval {self.current_user = user}
    controller.instance_eval {current_actor}.should == project #prerequisite
    get :switch, :id => user.id.to_s
    controller.instance_eval {current_actor}.should == user
  end

end
