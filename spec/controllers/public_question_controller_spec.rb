require File.dirname(__FILE__) + '/../spec_helper'

describe PublicQuestionController do

  before :each do
    Locale.set("en")
    @current_user = users(:chief)
    controller.stub!(:current_user).and_return(@current_user)
    controller.stub!(:current_actor).and_return(@current_user)
  end

  it "new should work" do
    controller.instance_eval {@user = current_user}
    get :new 
    assigns(:public_question).should_not be_nil
    response.should be_success
  end

  it "creation should work" do
    post :new, :public_question => {:text_ru => 'hey'}
    response.should be_redirect
  end

  it "creation should say it if text is empty" do
    controller.instance_eval {@user = current_user}
    post :new, :public_question => {:_text => '', :text_ru => ''}
    flash[:warning].should_not be_blank
    response.should_not be_redirect
  end

  it "update should work" do
    get :update, :question_id => public_questions(:question_number_one).id,
                 :from_action => 'unpublished'
    response.should be_redirect
  end


  it "unpublished should display unpublished questions" do
    controller.instance_eval {@user = current_user}
    get :unpublished
    assigns(:unpublished_q).should_not be_empty
    response.should be_success
  end

  it "published should display published questions" do
    controller.instance_eval {@user = current_user}
    get :published
    assigns(:published_q).should_not be_empty
    response.should be_success
  end

  it "publish should work" do
    post :publish, :question_id => public_questions(:question_number_one).id,
                            :visiblity => 1,
                            :from_action => 'published'
    response.should be_redirect
  end
  
  it "publish should say it if question not found" do
    controller.instance_eval {@user = current_user}
    post :publish, :question_id => 9999,
                            :visiblity => 1,
                            :from_action => 'published'
    response.should be_redirect
    flash[:error].should == "Please select one or more Question.".t
  end

  it "delete should work" do
    post :delete, :question_id => public_questions(:question_number_one).id,
                  :from_action => 'published'
    response.should be_redirect
    flash[:success].should == "Your question has been deleted.".t
  end

  it "index should redirect when no Q specified" do
    @current_user = users(:joe)
    controller.stub!(:current_user).and_return(@current_user)
    author = users(:chief)
    controller.instance_eval {@user = author}
    controller.stub!(:user_subdomain).and_return("")
    get :index
    response.should be_redirect
  end

  [[:question_number_two, :index, "index should work with Q specified"],
   [:archived_question, :archive, "index should work with archived Q"]].each do |question_key, action, test_case|
    it test_case do
      @current_user = users(:joe)
      controller.stub!(:current_user).and_return(@current_user)
      author = users(:chief)
      request.stub!(:subdomains).and_return [author.login]
      controller.instance_eval {@user = author}
      q = public_questions(question_key)
      get action, :id => q
      response.should be_success
      assigns(:questions).should_not be_empty
      assigns(:question).should == q
    end

  end

  it "index should work when there are no Qs" do
    @current_user = users(:joe)
    controller.stub!(:current_user).and_return(@current_user)
    request.stub!(:subdomains).and_return [@current_user.login]
    author = users(:joe)
    controller.instance_eval {@user = author}
    get :index
    response.should be_success
    assigns(:questions).should be_empty
    assigns(:question).should == nil
  end

  it "answer page finder should redirect to correct host" do
    #pending "TODO: it's shouldn't redirect. it's must get correct user by question"
    author = users(:chief)
    controller.instance_eval {@user = author}
    question = public_questions(:question_number_one)
    answer = public_answers(:answer_1_to_question_number_one)
    Thread.current['user'] = users(:joe)
    27.times {answer = answer.clone; answer.id = nil; answer.save!}
    controller.stub!(:user_subdomain).and_return("")
    get :index, :id => question, :show_comments => answer
    response.should redirect_to('http://%s.%s/public_question/index/%s?locale=%s&show_comments=%s' % [author.login, APP_CONFIG.hostname, question.id, 'en', answer.id])    
  end
end