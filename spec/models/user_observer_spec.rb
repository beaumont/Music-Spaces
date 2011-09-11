require File.dirname(__FILE__) + '/../spec_helper'

describe UserObserver do
  
  it "should work" do
    observer = UserObserver.instance
    observer.after_create(users(:not_activated))
  end

end
