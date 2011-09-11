require File.dirname(__FILE__) + '/../spec_helper'

describe LiveJournalEntry do
  
  describe "relationships" do
    it "should have comments" do
      LiveJournalEntry.new.should respond_to(:comments)
    end
    
    it "should have an account" do
      LiveJournalEntry.new.should respond_to(:account)
    end
  end
  
  describe "serialized columns" do
    it "should have security" do
      LiveJournalEntry.new.should respond_to(:security)
    end

    it "should have screening" do
      LiveJournalEntry.new.should respond_to(:screening)
    end
  end
  
  describe "body mappings" do
    it "should be cleanly specified" do
      LiveJournalEntry::BODY_MAPPINGS.should == (
      {:anum            => :anum,
      :journal_item_id => :itemid,
      :backdated       => :backdated,
      :preformatted    => :preformatted,
      :screening       => :screening,
      :subject         => :subject,
      :event           => :event,
      :location        => :location,
      :security        => :security,
      :music           => :music,
      :posted_at       => :time,
      :taglist         => :taglist})
    end
  end

  describe "after saving" do
    
    it "should fill event_cut and transpose lj tags" do
      html = "Hey I'm <script>EVIL</script> <lj-cut>but there may be more here</lj-cut> I have a name, its <lj user=\"jmartin81\"/>"
      e = LiveJournalEntry.new(:account_id => 999, :event => html)
      lambda do
        lambda do
          e.save
          LiveJournalEntry.transpose_lj_tags(e, 99)
        end.should change(e, :event_cut)
      end.should change(e, :event_formatted)
    end
    
  end
  
  describe "GetEvents API adjustments" do
    before(:each) do
      @lj_account = mock_model(Account)
      @lj_account.stub!(:username).and_return('username')
      @lj_account.stub!(:password).and_return('password')
      @lj_account.stub!(:usejournal).and_return(true)
    end

    # Need to dig a bit deeper to get this to mock out properly, was tested.
    #
    # it "should not be strict by default" do
    #   e = LiveJournal::Request::GetEvents.new(@lj_account, :itemid => 99)
    #   res = YAML::parse(e.to_yaml)
    #   res['strict'].value.should eql('false')
    # end
    # 
    # it "should allow setting strict to true via opts" do
    #   e = LiveJournal::Request::GetEvents.new(@lj_account, :itemid => 99, :strict => true)
    #   res = YAML::parse(e.to_yaml)
    #   res['strict'].value.should eql('true')
    # end

  end
  
  describe "when updating cache" do
    before(:each) do
      @user = mock_model(User)
      @account = mock_model(Account)
      @account.stub!(:username).and_return('bob')
      @account.stub!(:password).and_return('password')
      @account.stub!(:authenticate).and_return(@user)
      @account.stub!(:last_sync=)
      @account.stub!(:last_manual_sync=)
    end
        
    it "should return false if account is nil" do
      LiveJournalEntry.update_cache_for(nil).should eql(false)
    end
    
    it "should return false if account is unable to authenticate" do
      @account.should_receive(:authenticate).and_return(nil)
      LiveJournalEntry.update_cache_for(@account).should eql(false)
    end
    
    # it "should set last sync to 6 months ago if last sync was more than 6 months ago" do
    #   @account.stub!(:last_sync).and_return(2.years.ago)
    #   @sync.should_receive(:run_sync)
    #   @sync.should_receive(:run_syncitems)
    #   LiveJournalEntry.update_cache_for(@account)
    # end
    
    it "should use the body mappings when parsing a journal item" do
      example_entry_data = {
        :anum            => '1234',
        :itemid          => '9999',
        :backdated       => false,
        :preformatted    => true,
        :screening       => 'something',
        :subject         => 'Party Night',
        :event           => 'Party',
        :location        => 'My House',
        :security        => 'Public',
        :music           => 'Rock',
        :time            => 'a while ago',
        :taglist         => ('assuming, its, comma, delimited').split.to_yaml
      }
      
      # LiveJournal Provided Entry Item Stubbing
      @example_entry = mock('ExampleEntry', example_entry_data)
      @lj_entry_collection = {99 => @example_entry}
      
      # LiveJournal Sync Subsystem Stubbing
      @sync = mock('LjEntrySyncMock')
      @sync.stub!(:entries).and_return(@lj_entry_collection)
      @sync.stub!(:run_syncitems)
      @sync.stub!(:run_sync).and_yield(@sync, nil, 1)
      LiveJournal::Sync::Entries.stub!(:new).and_return(@sync)
      
      # Local Journal Item, User, and Account Stubbing
      @user = mock_model(User, :login => 'Jimmy')
      @mock_journal_item = mock_model(LiveJournalEntry)
      @mock_journal_item.stub!(:security).and_return(:public)
      @mock_journal_item.stub!(:posted_at).and_return 6.years.ago
      @account_entry_proxy = mock('AccountEntryProxy')
      @account_entry_proxy.stub!(:find_or_initialize_by_journal_item_id).and_return(@mock_journal_item)
      @account.stub!(:last_sync).and_return(2.years.ago)
      @account.stub!(:user).and_return(@user)
      
      # and the blog...
      @mock_blog = mock_model(Blog)
      Blog.stub!(:new).and_return @mock_blog
      @mock_blog.stub!(:user=)
      @mock_blog.stub!(:post=)
      @mock_blog.stub!(:save!)
      @mock_blog.stub!(:save)
      @mock_blog.stub!(:valid?).and_return(true)
      @mock_blog.stub!(:levels_can_see).and_return([0])
      Activity.stub!(:send_message)
      # make sure the account is validated
      @account.should_receive(:entries).and_return(@account_entry_proxy)

      # This happens within the mocked out block
      #@account.should_receive(:update_attribute)
      
      # The actual validation of proper mapping
      @mock_journal_item.should_receive(:anum=).with('1234')
      @mock_journal_item.should_receive(:journal_item_id=).with('9999')
      @mock_journal_item.should_receive(:location=).with('My House')
      @mock_journal_item.should_receive(:subject=).with('Party Night')
      @mock_journal_item.stub!(:event=)
      @mock_journal_item.stub!(:event_formatted=)
      @mock_journal_item.should_receive(:music=).with('Rock')
      @mock_journal_item.should_receive(:security=).with('Public')
      @mock_journal_item.should_receive(:backdated=).with(false)
      @mock_journal_item.should_receive(:posted_at=).with('a while ago')
      @mock_journal_item.should_receive(:screening=).with('something')
      @mock_journal_item.should_receive(:preformatted=).with(true)
      @mock_journal_item.should_receive(:taglist=).with("assuming, its, comma, delimited")
  
      @mock_journal_item.should_receive(:save).with(false) # for id generation
  
      # more stubs to complete this spec 
      @mock_journal_item.stub!(:save!)
      @mock_journal_item.stub!(:event_cut=)
      @mock_journal_item.should_receive(:content_id).at_least(:once).and_return(0)
            
      LiveJournalEntry.update_cache_for(@account)
    end
    
  end
end