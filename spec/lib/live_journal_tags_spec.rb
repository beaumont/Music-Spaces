require File.dirname(__FILE__) + '/../spec_helper'

describe LiveJournalTags, 'class' do
    
  it 'should have a class parse method' do
    LiveJournalTags.should respond_to(:parse)
  end
  
  it 'should return a blank if the passed object doesnt respond to event method *quack*' do
    foo = mock('Junk')
    foo.should_receive(:respond_to?).with(:event).and_return(false)
    LiveJournalTags.parse(foo, 99).should eql('')
  end
  
  describe "parsing lj-embed tags" do
    it "should replace embed tags with a link back to livejournal" do
      lj_html = "Well hello there, here is my video <lj-embed id=\"1\" />"
      e = mock_model(LiveJournalEntry)
      a = mock_model(Account)
      b = mock_model(Blog)

      b.stub!(:filename).and_return('42.html')

      a.stub!(:url).and_return('http://example.com/')

      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_params).and_return(99)
      e.stub!(:account).and_return(a)
      e.stub!(:blogentry).and_return(b)

      res = LiveJournalTags.parse(e, 99)
      res[:full].should eql('Well hello there, here is my video <a href="http://example.com/42.html">This post contains embedded media, click here to view.</a>')      
    end
  end

  describe "parsing user tags" do
    it "should handle parsing different html variations" do
      [
        '<lj user="jmartin">',
        '<lj  user = "jmartin" />',
        '<LJ USER="jmartin"/>'
      ].each do |lj_user_tag|
        e = mock(LiveJournalEntry)
        e.stub!(:event).and_return(lj_user_tag)
        LiveJournalTags.parse(e, 99).each do |type, data|
          data.should eql("<a href=\"http://jmartin.livejournal.com/profile\" target=\"_blank\"><img src=\"/images/userinfo.gif\" border=\"0\" alt=\"[info]\" style=\"vertical-align:middle\"/></a><a href=\"http://jmartin.livejournal.com/\" target=\"_blank\"><b>jmartin</b></a>")
        end
      end
    end
  end
  
  describe "parsing community tags" do
    it "should handle parsing different html variations" do
      [
        '<lj comm="ruby">',
        '<lj  comm = "ruby" />',
        '<LJ COMM="ruby"/>'
      ].each do |lj_user_tag|
        e = mock(LiveJournalEntry)
        e.stub!(:event).and_return(lj_user_tag)
        LiveJournalTags.parse(e, 99).each do |type, data|
          data.should eql("<a href=\"http://community.livejournal.com/ruby\" target=\"_blank\"><img src=\"/images/community.gif\" border=\"0\" alt=\"[info]\" style=\"vertical-align:middle\"/></a><a href=\"http://community.livejournal.com/ruby\" target=\"_blank\"><b>ruby</b></a>")
        end
      end
    end
  end
  
  describe "parsing cut tags" do
    
    it "should gracefully ignore blank html" do
      lj_html = nil
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)      
      res = LiveJournalTags.parse(e, 99)
      res[:full].should eql('')
    end
    
    it "should handle tags with a text attribute" do
      lj_html = "This post <lj-cut text=\"You Love It\"> when full</lj-cut>"
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)
      
      res = LiveJournalTags.parse(e, 99)
      res[:cut].should eql("This post <b>(&nbsp;<a href=\"/content/show/99#cut99_1\">You Love It</a>&nbsp;)</b>")
    end
    
    it "should replace cut tags in full content with a unique anchor" do
      lj_html = "This post <lj-cut> when full</lj-cut> rocks"
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)
      res = LiveJournalTags.parse(e, 99)
      res[:full].should eql("This post <a href=\"#cut99_1\"></a> when full rocks")
    end
    
    it "should replace cut tag content in cut result and support single quotes" do
      lj_html = "This post <lj-cut text='wtf'> when full of useless stuff</lj-cut> rocks"
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)
      res = LiveJournalTags.parse(e, 99)
      res[:cut].should eql("This post <b>(&nbsp;<a href=\"/content/show/99#cut99_1\">wtf</a>&nbsp;)</b> rocks")
    end
    
    it "should handle multiple lines" do
      lj_html = '<lj-cut text="lorem ipsum...">
      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
      </lj-cut>'
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)
      res = LiveJournalTags.parse(e, 99)
      res[:cut].should eql("<b>(&nbsp;<a href=\"/content/show/99#cut99_1\">lorem ipsum...</a>&nbsp;)</b>")
    end
    
    it "should not need a closing tag" do
      lj_html ="Story of my life. <lj-cut> Everything here would be cut"
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)
      
      res = LiveJournalTags.parse(e, 99)
      res[:cut].should eql("Story of my life. <b>(&nbsp;<a href=\"/content/show/99#cut99_1\">Read More...</a>&nbsp;)</b>")
    end
    
    it "should handle this strange cut correctly" do
      lj_html = "Outside of cut<lj-cut text=\"большая\"><br/>Inside of cut</lj-cut>"
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)      
      res = LiveJournalTags.parse(e, 99)
      res[:cut].should eql("Outside of cut<b>(&nbsp;<a href=\"/content/show/99#cut99_1\">большая</a>&nbsp;)</b>")
    end
    
  end
  
  describe "whitelisting html" do
    
    it "should ignore comments" do
      lj_html = "<!-- this should be skipped -->Howdy!"
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)
      LiveJournalTags.parse(e, 99)[:full].should eql('Howdy!')
    end
    
    it "should check for protocols" do
      lj_html = "<a href=\"crazy://things\">bad protocol</a>"
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)
      LiveJournalTags.parse(e, 99)[:full].should eql('<a>bad protocol</a>')
    end
    
    it "should be used" do
      lj_html = 'NO<script>alert("Die!")</script>EVIL'
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)
      LiveJournalTags.should_receive(:white_list).with(lj_html).and_return(lj_html)
      LiveJournalTags.parse(e, 99)
    end
    
    it "should actually be stripping stuff" do
      lj_html = 'NO<script>muahah();</script> but this is removed also up to the next tag<badtag></badtag>EVIL'
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)
      LiveJournalTags.parse(e, 99)[:full].should eql('NO<badtag></badtag>EVIL')
    end
    
    it "should allow embedded youtube tags" do
      lj_html = '<object width="425" height="344"><param name="movie" value="http://www.youtube.com/v/_lMpdX-emxk&hl=en&fs=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/_lMpdX-emxk&hl=en&fs=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="344"></embed></object>'
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)
      pending("TODO: fix the spec")
      LiveJournalTags.parse(e, 99)[:cut].should eql("<object height=\"344\" width=\"425\"><param name=\"movie\" value=\"http://www.youtube.com/v/_lMpdX-emxk&amp;hl=en&amp;fs=1\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed allowfullscreen=\"true\" type=\"application/x-shockwave-flash\" src=\"http://www.youtube.com/v/_lMpdX-emxk&amp;hl=en&amp;fs=1\" allowscriptaccess=\"always\" height=\"344\" width=\"425\"></embed></object>")
    end
    
    it "should allow <embed> and <lj-embed> tags" do
      lj_html = "<lj-embed id=\"1\"><embed></embed></lj-embed>"
      e = mock_model(LiveJournalEntry)
      e.stub!(:event).and_return(lj_html)
      e.stub!(:to_param).and_return(99)
      LiveJournalTags.stub!(:parse_lj_embed_tags).and_return(lj_html)
      LiveJournalTags.parse(e, 99)[:cut].should eql("<lj-embed id=\"1\"><embed></embed></lj-embed>")
    end
    
  end
  
end
