require File.dirname(__FILE__) + '/../spec_helper'

describe "Content in general", :shared => true do
  # TEST_DIR = "tmp/test_uploads" 
  # 
  # before(:each) do
  #   Image.attachment_options[:path_prefix] = "#{TEST_DIR}/images" 
  #   @image = Image.create :uploaded_data => fixture_file_upload("test_image.jpg", "image/jpg")
  # end
  # 
  # after(:each) do
  #   @image.destroy
  #   FileUtils.rm_rf File.join(RAILS_ROOT, TEST_DIR)
  # end
  
  before(:each) do
    # @content = Content.new(:title => "blah", :post => "blah", :user_id => 5)
  end
    
  it "should be viewable by certain Kroogi levels" do
    # Content.any_instance.expects(:save_to_storage).returns(true)
    pending("not sure how security works on kroogi as it is...")
  end
  
  it "should be able to skip monitoring" do
    @content.skip_monitor.should be_nil
    @content.without_monitoring do
      @content.skip_monitor.should be_true
    end
    @content.skip_monitor.should be_false
    pending("TODO: fix the spec")
    lambda { @content.save }.should raise_error(Kroogi::Error)
    lambda { 
      @content.without_monitoring do
        @content.save 
      end
    }.should_not raise_error
    lambda { Content.new(:user_id => 5).save }.should raise_error(Kroogi::Error)
  end
  
  it "should skip monitoring at class level" do
    # pending("have found a way around this yet without modifying the class")
    pending("TODO: fix the spec")
    lambda { @content.save }.should raise_error(Kroogi::Error)
    lambda {  
      Content.without_monitoring do
        @content.save
      end
    }.should_not raise_error
    lambda { Content.new(:user_id => 5).save }.should raise_error(Kroogi::Error)
  end
  
    
end

describe "Content being translated", :shared => true do
  it "should copy the post to English default" do
     @content.without_monitoring do
       @content.post_ru = "russian"
       @content._post = ""
       @content.should be_valid
       @content.save
       Locale.switch_locale("ru-RU") do
         @content.post.should == "russian"
       end
     end
  end
  
  it "should not delete kroogi tags in xss" do
    @content.without_monitoring do
      @content.description = %{<kroogi user="8">yo</kroogi>}
      @content.description_ru = %{<kroogi user="8">yo</kroogi>}
      @content.save
      @content.description.should == %{<kroogi user="8">yo</kroogi>}
      @content.description_ru.should == %{<kroogi user="8">yo</kroogi>}
    end
  end
end


describe "Content that receives donations", :shared => true do
  it "should have a donation_setting for donations" do
    @content.donation_setting_object.should_not be_nil
  end

  it "should accept donation_setting methods" do
    @content.without_monitoring do
      @content.amount_usd = 5
      @content.save
      @content.amount_usd.should == 5
      
      @content.attributes = {:amount_wmr => 66}
      @content.save
      @content.amount_wmr.should == 66
    end
  end
end
