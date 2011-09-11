require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ContentStat do

  before(:each) do
    Thread.current['user'] = users(:chief)
  end

  it "view counter should increase for guests from different IPs" do
    entry = contents(:the_extremist)
    was = ContentStat.viewed(entry)
    ContentStat.mark_async(:viewed!, {:content => entry, :user_id => nil, :ip => '1.2.3.4'})
    ContentStat.viewed(entry).should == was + 1 
    ContentStat.mark_async(:viewed!, {:content => entry, :user_id => nil, :ip => '1.2.3.5'})
    ContentStat.viewed(entry).should == was + 2
  end

  it "view counter should not increase for guests from the same IP for short timespan" do
    log.debug "hello!"
    entry = contents(:the_extremist)
    was = ContentStat.viewed(entry)
    ContentStat.mark_async(:viewed!, {:content => entry, :user_id => nil, :ip => '1.2.3.4'})
    ContentStat.viewed(entry).should == was + 1
    ContentStat.mark_async(:viewed!, {:content => entry, :user_id => nil, :ip => '1.2.3.4'})
    ContentStat.viewed(entry).should == was + 1
  end

  it "view counter should increase for different users" do
    entry = contents(:the_extremist)
    was = ContentStat.viewed(entry)
    ContentStat.mark_async(:viewed!, {:content => entry, :user_id => users(:joe).id})
    ContentStat.viewed(entry).should == was + 1
    ContentStat.mark_async(:viewed!, {:content => entry, :user_id => users(:filka).id})
    ContentStat.viewed(entry).should == was + 2
  end

  it "view counter should not increase for same user" do
    entry = contents(:the_extremist)
    was = ContentStat.viewed(entry)
    ContentStat.mark_async(:viewed!, {:content => entry, :user_id => users(:joe).id})
    ContentStat.viewed(entry).should == was + 1
    ContentStat.mark_async(:viewed!, {:content => entry, :user_id => users(:joe).id})
    ContentStat.viewed(entry).should == was + 1
  end
end
