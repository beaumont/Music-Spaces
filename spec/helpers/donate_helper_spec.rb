require File.dirname(__FILE__) + '/../spec_helper'

describe DonateHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the DonateHelper" do
    pending "TODO:Spec Broken. Kali marking pending so autotest doesn't drive him crazy"
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(DonateHelper)
  end
  
end
