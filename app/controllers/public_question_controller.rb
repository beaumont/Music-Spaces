class PublicQuestionController < ApplicationController
  before_filter :load_question, :only => [:update, :delete, :answer, :put_to_archive, :unarchive, :toggle_show_on_events]
  before_filter :load_question_for_index, :only => :index
  before_filter :load_question_for_archive, :only => :archive
  before_filter :load_owner
  before_filter :owner_required, :except => [:index, :archive, :answer, :delete_answer, :didnt_answer]
  verify :method => :post, :only => [:publish, :answer, :delete_answer, :delete, :put_to_archive, :unarchive, :didnt_answer],
         :redirect_to => { :controller => '/'}
  skip_before_filter :verify_authenticity_token, :only => [:update_order]

  def new
    @title = (title_base + ['Add Question'.t]).join(' :: ')
    @public_question = PublicQuestion.new(:show_on_events => true)
    if request.post?
      if params[:public_question][:_text].blank? && params[:public_question][:text_ru].blank?
        flash.now[:warning] = "Can't create a blank question".t
        render :action => :new
      else
        if params[:publish_directly] == 'true'
          public_question = PublicQuestion.create!(params[:public_question].merge(:user => @user))
          public_question.publish!
          flash[:success] = "Question has been published successfully".t
          redirect_to :host => user_host(@user), :action => :published
        else
          PublicQuestion.create!(params[:public_question].merge(:user => @user))
          flash[:success] = "Question has been created successfully".t
          redirect_to :host => user_host(@user), :action => :unpublished
        end
      end
    end
  end

  def update
    public_question = @question
    public_question.update_attributes(params[:public_question])
    flash[:success] = "Your question has been updated.".t
    redirect_to :host => user_host(@user), :action => params[:from_action]
  end

  def unpublished
    @title = (title_base + ['Unpublished Questions'.t]).join(' :: ')
    @unpublished_q = PublicQuestion.with_user(@user).unpublished.by_date
  end
 
  def published
    @title = [@user.display_name, 'Forum'.t, 'Published Questions'.t].join(' :: ')
    @published_q = PublicQuestion.with_user(@user).published.by_position.
      paginate(:page => params[:page], :per_page => getpagesize)
  end

  def publish
    if params[:q_ids].nil?
      flash[:error] = "Please select one or more Question.".t
    else
      public_questions = PublicQuestion.find_all_by_id(params[:q_ids])
      public_questions.each {|public_question| public_question.publish!}
      flash[:success] = "Your question(s) has been published.".t
    end
    redirect_to :host => user_host(@user), :action => :published
  end

  def delete
    public_question = @question
    if params[:q_ids].nil?
      if public_question
        public_question.destroy
        flash[:success] = "Your question has been deleted.".t
      else
        flash[:error] = "Question not found.".t
      end
    else
      p_questions = PublicQuestion.find_all_by_id(params[:q_ids])
      p_questions.each {|p_question| p_question.destroy}
      flash[:success] = "Your question(s) has been deleted.".t
    end
    redirect_to :host => user_host(@user), :action => params[:from_action]
  end

  def archive
    index(:archived, :by_date, 'Forum Archive'.t)
  end

  def index(kind = :published, order_kind = :by_position, label = nil)
    @questions = PublicQuestion.with_user(@user).send(kind).send(order_kind)
    if params[:id].blank? && !@questions.empty?
      redirect_to :host => user_host(@user), :action => action_name, :id => @questions.first
    end
    label ||= 'Forum'.t
    @title = "%s :: %s" % [@user.display_name, label]
    unless @question.blank?
      @title += " :: %s" % @question.title_long
      order = 'created_at desc' 
      @answers = @question.answers.paginate(:page => params[:page], :per_page => getpagesize, :order => order)
      if params[:show_comments]
        answer = PublicAnswer.find_by_id(params[:show_comments])
        if answer
          unless @answers.include?(answer)
            page = @question.find_answer_page(answer, getpagesize, order)
            if page
              x = params_without_paging(:keep_size => true).merge(:page => page, :host => user_host(@user))
              x = url_for(x)
              redirect_to(x)
            end
          end
        end
      end
    end
  end

  def answer
    redirect_to '/' and return unless @question
    answer_params = params[:comment]
    @answer = @question.answers.create!(:text => answer_params[:comment],
                                        :user_id => answer_params[:user_id] || User::ANONYMOUS_ID,
                                        :avatar_id => answer_params[:avatar_id])

    counter = AnswerIntervalCounter.find_by_user_id_and_artist_id(@answer.user.id, @question.user.id)
    counter.reset(:persist => true) if counter

    unless params[:ajax_mode]
      flash[:success] = 'Thank you for answering'.t
      redirect_to :host => user_host(@question.user), :action => 'index', :id => @question
    end
  end

  def delete_answer
    answer = PublicAnswer.find(params[:id])
    if answer.can_delete?
      answer.destroy
      flash[:success] = 'The answer was successfully deleted'.t
    else
      flash[:error] = 'You are not authorized to delete that'.t
    end
    render(:update) do |page|
      page << 'document.location.reload(false);'
    end
  end

  def put_to_archive
    unless @question
      flash[:error] = "Question not found".t
      redirect_to :host => user_host(@user), :action => 'index' and return
    end
    if @question.archived?
      flash[:error] = "Question is already archived".t
      redirect_to :host => user_host(@user), :action => 'archive' and return
    end
    @question.archive!
    flash[:success] = "Your question has been archived".t
    redirect_to :host => user_host(@user), :action => 'archive' 
  end
  
  def unarchive
    unless @question
      flash[:error] = "Question not found".t
      redirect_to :host => user_host(@user), :action => 'archive' and return
    end
    if @question.published?
      flash[:error] = "Question is already unarchived".t
      redirect_to :host => user_host(@user), :action => 'index' and return
    end
    @question.publish!
    flash[:success] = "Your question has been unarchived".t
    redirect_to :host => user_host(@user), :action => 'index', :id => @question.id
  end

  def question_attrib
    question = PublicQuestion.find(params[:id])
    render :text => question.read_attribute(params[:attrib])
  end

  def set_question_attrib
    question = PublicQuestion.find(params[:id])
    attrib = params[:attrib]
    previous = question.read_attribute(attrib)
    value = params[:value]
    question.write_attribute(attrib, value)
    value = previous unless question.save_without_validation
    render :text => value
  end

  def didnt_answer
    counter = AnswerIntervalCounter.find_by_user_id_and_artist_id(params[:user_id], params[:artist_id])
    render :text => 'not found' and return unless counter
    counter.reset(:enlarge_interval => true, :persist => true)
    render :text => 'ok'
  end

  def reorder_questions
    @questions = PublicQuestion.with_user(@user).published.by_position
    @title = "%s :: %s :: %s" % [@user.display_name, 'Forum'.t, 'Reorder'.t]
  end

  def update_order
    params[:album_list_id].each_with_index do |id, position|
      PublicQuestion.update(id, :position => position+1)
    end
    render :text => ''
  end

  def toggle_show_on_events
    @question.update_attribute(:show_on_events, !@question.show_on_events?)
    render :text => question_show_on_events_caption(@question)
  end
  
  private
  def maybe_create_question

  end

  def load_question
    @question = PublicQuestion.find_by_id(params[:question_id] || params[:id])
    @user = @question.user if @question
  end

  def load_question_for_index
    @question = PublicQuestion.published.find_by_id(params[:question_id] || params[:id])
    @user = @question.user if @question
  end

  def load_question_for_archive
    @question = PublicQuestion.archived.find_by_id(params[:question_id] || params[:id])
    @user = @question.user if @question
  end
  
  def load_owner
    @user ||= User.find_by_login(user_subdomain) || current_actor

    raise Kroogi::NotPermitted if [@user, @question].all?(&:blank?) || @question.blank? && @user.guest?

    redirect_to(user_url_for(
      @user, :action => :index, :controller => 'public_question',
      :page => params[:page], :show_comments => params[:show_comments], :id => params[:id]
    )) and return if @user && action_name == "index" && @user.login.downcase != user_subdomain.downcase

    redirect_to user_url_for(
      current_actor, :action => action_name, :controller => 'public_question', :id => params[:id]
    ) and return if @user.blank? && !current_actor.guest?
  end

  def owner_required
    raise Kroogi::NotPermitted unless permitted?(@user, :content_edit)    
  end

  def title_base
    [@user.display_name, 'Forum'.t]
  end

  def question_show_on_events_caption(question)
    if question.show_on_events?
      if question.published?
        "This question <b>is shown</b> on various events (download, comment, etc).".t
      else
        "This question <b>will be shown</b> on various events (download, comment, etc).".t
      end
    else
      if question.published?
        "This question <b>is shown only</b> in Forum.".t
      else
        "This question <b>will be shown only</b> in Forum.".t
      end
    end
  end
  helper_method :question_show_on_events_caption
  
end
