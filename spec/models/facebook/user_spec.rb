require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Facebook
  describe User do

    it "creation should work" do
      fb_user_id = 25265435234
      UserDetails.find_user(fb_user_id).should == nil
      user = with_current_user(users(:anonymous)) do
        User.without_monitoring do
          User.find_or_create(fb_user_id, nil, :invited => true) #let's cover as much creation as we can
        end
      end
      user.should_not be_new
      user.preference.email?.should == false
    end

  end
end