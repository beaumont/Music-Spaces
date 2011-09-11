require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Content do

  before(:each) do
    Thread.current['user'] = users(:chief)
    Content.add_observer(NewPublicContentObserver.instance) #this should happen automatically but it doesn't happen with Drb server
  end

  def create_item(klass, category, user)
    c = klass.new(:user_id => user.id, :cat_id => Content::CATEGORIES[category][:id],
                      :relationshiptype_id => Relationshiptype.everyone, :is_in_gallery => true)

    c.stub!(:attachment_attributes_valid_improved)
    c.stub!(:check_quota)
    c.save!
    c
  end
  
  [[Album, :album], [FolderWithDownloadables, :album], [Image, :image], [MusicAlbum, :album], [Textentry, :writing],
   [Track, :track], [Video, :video]].each do |klass, category|
    it "recent content should include fresh %s" % klass.name do
      user = users(:chief)

      c = create_item(klass, category, user)
      recent = Content.recent(2)
      recent.include?(c).should == true
    end
  end

  def test_new_content_with_user_blocking(user, action)
    c = create_item(Image, :image, user)
    Content.recent(1).include?(c).should == true
    user.send(action)
    Content.recent(1).include?(c).should == false
    c
  end

  it "should be removed from NewContents when user is blocked" do
    user = users(:chief)
    test_new_content_with_user_blocking(user, :block!)
  end

  it "should be removed from NewContents when user is deleted" do
    user = users(:chief)
    test_new_content_with_user_blocking(user, :delete!)
  end

  it "should move back to NewContents when user is restored from blocked" do
    user = users(:chief)
    c = test_new_content_with_user_blocking(user, :block!)
    user.restore!
    Content.recent(1).include?(c).should == true
  end  

  it "truncation should remove older content" do
    user = users(:chief)
    create_item(Image, :image, user)
    c2 = create_item(Image, :image, user)
    create_item(Image, :image, user)
    NewContent.count.should == 3
    Content.recent(2).include?(c2).should == true
    NewContent.truncate(2)
    NewContent.count.should == 2
    Content.recent(2).include?(c2).should == true
  end

  it "should be removed from NewContents when user is deleted after truncation" do
    user = users(:chief)
    create_item(Image, :image, user)
    create_item(Image, :image, user)
    c3 = create_item(Image, :image, user)
    Content.recent(2).include?(c3).should == true
    NewContent.truncate(2)
    user.delete!
    Content.recent(1).include?(c3).should == false
  end

  it "should be removed from NewContents when it's removed" do
    user = users(:chief)
    c = create_item(Textentry, :image, user)
    Content.recent(1).include?(c).should == true
    c.stub!(:donation_setting) #crazy stuff, it fires "undefined method `target' for #<CurrencyType:0xc14d17c>" here otherwise, and without damn backtrace!
    c.destroy
    Content.recent(1).include?(c).should == false
  end

end
