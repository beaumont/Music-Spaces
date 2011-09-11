require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Activity do

  it "should be able to create :content_purchased activity" do
    @seller  = mock_model(User,    :login => 'seller')
    @content = mock_model(Content, :user => @seller)#, :cache => cache_obj)
    @payer   = mock_model(User)
    Activity.stub!(:clear_user_cache)
    Activity.send_message(@content, @payer, :content_purchased)
  end

  it "activity type ids should be unique" do
    counts = {}
    Activity::ACTIVITIES.each {|key, info| counts[info[:id]] ||= 0; counts[info[:id]] += 1}
    counts.each {|id, count| assert_equal 1, count, "count for activity id #{id} should be 1"}
  end

  it "friend feeds broadcasting should survive dupe requests" do
    old = APP_CONFIG[:disable_bdrb]
    APP_CONFIG[:disable_bdrb] = false
    begin
      params = contents(:matisyahu_youth_album), users(:matisyahu),
              {:friendcast=>true, :cc_myself=>true, :id=>4}, users(:chief), {} 
      Activity.send_to_all_friends_and_content_owner(*params)

      Activity.send_to_all_friends_and_content_owner(*params)
    ensure
      APP_CONFIG[:disable_bdrb] = old
    end
  end
  
end