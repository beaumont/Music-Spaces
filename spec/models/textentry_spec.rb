require File.dirname(__FILE__) + '/../spec_helper'
require File.join(File.dirname(__FILE__), *%w[shared_content_spec])

describe Textentry do
  before(:each) do
    @textentry = @content = Textentry.new(:title => "blah", :post => "blah", :user_id => 5)
  end
  
  it_should_behave_like "Content in general"
  it_should_behave_like "Content that receives donations"
end