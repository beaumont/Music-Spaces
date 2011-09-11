require File.dirname(__FILE__) + '/../spec_helper'

describe Profile do
  include ProfileSpecHelper
  include CurrentUser
  before(:all) do
    @user = mock(User, {:id => 5,
                      :email =>"user_#{random_string}@gmail.com", 
                        :password => "password", 
                        :password_confirmation => "password",
                        :login => "login#{random_string}",
                        :display_name => "display #{random_string}"})
    @user.stub!(:actor).and_return(@user)
  end
  
  before(:each) do
    Profile.without_monitoring do 
      @profile = Profile.find_or_create_by_user_id(5)
    end
    @profile.stub!(:user).and_return(@user)
    @profile.profile_questions.destroy_all
  end
  
  it "should accept profile questions as tags" do
    ActiveRecord::Base.without_monitoring do 
      pending "TODO: fix the spec"
      @profile.country = "england"
      @profile.save
      @profile.contextual_tag_list("country").include?("england").should be_true
      @profile.country.answer.should == "england"
    end
  end
  
  it "should create new profile questions" do
    ActiveRecord::Base.without_monitoring do     
      @profile.skype.should be_new_record
      pending "TODO: fix the spec"
      @profile.skype.save
      @profile.skype.should_not be_new_record
    end
  end
  
  it "should accept all profile question attributes" do
    ActiveRecord::Base.without_monitoring do 
      @profile.gmail.answer.should be_blank
      @profile.skype.answer.should be_blank
    
      # add bummy params
      pending "TODO: fix the spec"
      @profile.attributes = profile_params
      @profile.save
    
      # check values
      @profile.gmail.answer.should == "gmail"
      @profile.gmail.show_on_kroogi_page.should be_true
      @profile.skype.answer.should == "skype"
      @profile.skype.show_on_kroogi_page.should be_true        
    end
  end
  it "should take trivia questions" do
    ActiveRecord::Base.without_monitoring do
      trivia = {
        :question     => "english",
        :answer       => "english"
      }
      
      trivia1 = {
        :question => "what?", 
        :answer => "I don't know." 
      }
      
      @profile.question_list = [trivia, trivia1]
      pending "TODO: fix the spec"
      @profile.save.should be_true
      @profile.reload
      @profile.should have(2).trivia_questions
      
    end
  end
  
  it "should not be valid with empty questions for trivia" do
    ActiveRecord::Base.without_monitoring do
      @profile.question_list = [{
        :question     => "the question",
        :answer       => "the answer"
        },{
        :question     => "",
        :answer       => "bullshit"
      }]
      @profile.should_not be_valid
      @profile.errors.on_base.should == "One or more trivia questions is invalid."
    end
  end
end
