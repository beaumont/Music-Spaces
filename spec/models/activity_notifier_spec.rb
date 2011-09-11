require File.dirname(__FILE__) + '/../spec_helper'

describe ActivityNotifier do
  it "should not break on modified #helper method" do
    # this is actually enough because instantiating the model
    # would blow up if the helper methods didn't exist
    lambda { ActivityNotifier }.should_not raise_error
  end
end