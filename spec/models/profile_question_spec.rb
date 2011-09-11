require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProfileQuestion do
  before(:each) do
    @valid_attributes = {
    }
  end

  it "should not be :is_complete? if trivia and question is empty" do
    trivia = {
      :question_key => :trivia,
      :question     => "english",
      :answer       => "english",
      :profile_id => 1
    }
    
    trivia_ru = {
      :question_key => :trivia,
      :answer_ru    => "russian",
      :question_ru  => "russian",
      :profile_id => 1
    }
    
    @pq = ProfileQuestion.new(trivia)
    @pq_ru = ProfileQuestion.new(trivia_ru)
    @pq.should be_is_complete
    @pq_ru.should be_is_complete
    
    ProfileQuestion.without_monitoring do
      @pq.should be_valid
      @pq_ru.should be_valid
    end
  end
  
  it "should be marked as :being_deleted? if all values are blank" do
    trivia = {
      :question_key => :trivia,
      :question     => "",
      :answer       => "",
      :profile_id => 1
    }
    @pq = ProfileQuestion.new(trivia)
    @pq.should be_being_deleted
  end
end
