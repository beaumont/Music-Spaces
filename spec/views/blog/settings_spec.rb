require File.dirname(__FILE__) + '/../../spec_helper'

describe '/blog/settings' do
  before(:each) do
    @account = mock_model(Account,
      { :username => 'Bob',
        :connect_friends => true,
        :is_community? => false,
        :usejournal => '',
        :allow_friends => false,
        :friend_circle => false,
        :import_mine => true})
    assigns[:account] = @account
    user = mock_model(User, {:circles => [], :project? => false})
    user.stub!(:generic_circle_name).and_return('some')
    assigns[:user] = user
    assigns[:type] = 'personal'
    assigns[:projects_info] = []
  end
  
  # # using 2 blocks because of rspec/gc segfault issue.
  # it "should provide a form with proper tags and post to integration_update" do
  #   render 'blog/settings'
  #   response.should have_tag('form[action=?][method=?]','/blog/update','post') do |f|
  #     f.should have_tag('input[name=?][type=?][value=?]','account[username]','text','Bob')
  #     f.should have_tag('input[name=?][type=?][value=?]','account[password]','password','')
  #   end
  #   
  #   response.should have_tag('form[action=?][method=?]','/blog/update','post') do |f|
  #     f.should have_tag('input[name=?][type=?][value=?]','account[password_confirmation]','password','')
  #     f.should have_tag('input[name=?][type=?]','account[connect_friends]','checkbox')
  #   end
  # end
  # 
  # it "should provide a disconnect button with confirmation to remove integration settings" do
  #   render 'blog/settings'
  #   response.should have_tag('form[action=?][method=?][onsubmit=?]','/blog/update','post', 'return areYouSure();') do |f|
  #     f.should have_tag('input[name=?][type=?][value=?]','account[username]','hidden','')
  #     f.should have_tag('button[type=?][name=?]', 'submit', 'commit')
  #   end
  # end
  
  it "should render without errors" do
    render 'blog/settings'
  end
    
end