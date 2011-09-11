require File.dirname(__FILE__) + '/../spec_helper'

describe LiveJournalFriend do
  
  describe "attributes" do
    it 'should have an account_id' do
      LiveJournalFriend.new.should respond_to(:account_id)
    end
  end
  
  describe "when updating cache" do
    before(:each) do
      @account = mock_model(Account)
      @account.stub!(:id).and_return(99)
      lj_user = LiveJournal::User.new('Some User', 'Any Password')
      @account.stub!(:authenticate).and_return(lj_user)
      LiveJournalFriend.should_receive(:find_or_create_by_account_id).with(@account).and_return(@account)      
    end
    
    it 'should return false when unable to authenticate' do
      @account.should_receive(:authenticate).and_return(false)
      LiveJournalFriend.update_cache_for(@account).should eql(false)
    end
    
    it 'should return false if there are no lj friends for the user' do 
      friends = []
      @friend_api = mock('LiveJournalFriendApi')
      @friend_api.stub!(:run).and_return(friends)
      LiveJournal::Request::Friends.stub!(:new).and_return(@friend_api)
      @account.should_receive(:authenticate).and_return(@account)
      LiveJournalFriend.update_cache_for(@account).should eql(false)
    end
    
    it 'should try to update each friend when there are friends available' do
      Time.stub!(:now).and_return('right now')
      friend1, friend2 = 'joe', 'bob'
      friends = [friend1, friend2]
      @friend_api = mock('LiveJournalFriendApi')
      @friend_api.stub!(:run).and_return(friends)
      LiveJournal::Request::Friends.stub!(:new).and_return(@friend_api)
      @account.should_receive(:authenticate).and_return(@account)
      @account.should_receive(:update_attribute).with(:last_sync, 'right now')
      LiveJournalFriend.should_receive(:update_friend).with(@account, friend1).once
      LiveJournalFriend.should_receive(:update_friend).with(@account, friend2).once

      LiveJournalFriend.update_cache_for(@account).should_not eql(false)
    end
  end
  
  describe "when updating friend" do
    before(:each) do
      @account = mock_model(Account)
      @account.stub!(:username).and_return('Joey')
      @friend = mock_model(User)
      @friend.stub!(:username).and_return('Joey')
    end
    
    it "should not do anything unless the friend is actually a User" do
      @friend.should_receive(:is_a?).with(User).and_return(false)
      # eh? User.should_not_recieve(:find_by_livejournal_username)
      LiveJournalFriend.send(:update_friend, @account, @friend)
    end
    
    it "should not do anythign unless we are able to find that friend by their name" do
      User.should_receive(:find_by_livejournal_username).with(@friend.username).and_return(false)
      # eh? Friendship.should_not_receive(:find_by_user_id_and_friend_id)
      LiveJournalFriend.send(:update_friend, @account, @friend)
    end
    
    # TODO: remove the exception as the process is continued
    it "REMOVE ME: should raise exception if friend is found" do
      User.should_receive(:find_by_livejournal_username).with(@friend.username).and_return(@friend)
      lambda{
        LiveJournalFriend.send(:update_friend, @account, @friend)
      }.should raise_error(Exception)
    end
    
    it "should update the local system friendship" do
      pending 'There is no friendship model anymore, we are using relationships'
    end
  end

end