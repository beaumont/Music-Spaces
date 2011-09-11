require File.dirname(__FILE__) + '/../spec_helper'

include Admin::UsersHelper
describe Admin::UsersHelper do
  
  it 'should provide CSS for deleted state' do
    u = mock(User, :deleted? => true)    
    user_state_css(u).should eql('background: #990000;')
  end
  
  it 'should provide CSS for blocked state' do
    u = mock(User, :deleted? => false, :blocked? => true)    
    user_state_css(u).should eql('background: #FF9999;')
  end
  
  it 'should provide blank if neither blocked or deleted' do
    u = mock(User, :deleted? => false, :blocked? => false)    
    user_state_css(u).should be_blank
  end
  
end