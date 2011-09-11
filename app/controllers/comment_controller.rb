class CommentController < ApplicationController

  before_filter :login_required, :except => [:add_comment, :view_more]
  before_filter :ensure_not_blank, :only => [:add_comment, :reply_comment, :tps_participant_was_questioned, :tps_participant_answered]
  before_filter :set_user_and_avatar, :only => [:add_comment, :reply_comment, :tps_participant_was_questioned, :tps_participant_answered]

  def add_comment(kind = nil)
    if commentable = (params[:commentable_type]).constantize.find(params[:id])
      if logged_in? || commentable.host_user.allows_guest_comments?
        unless commentable.is_a?(Comment)
          comment = commentable.add_comment(
            {
              :comment    => params[:comment][:comment],
              :avatar_id  => @avatar ? @avatar.id : nil,
              :user_id    => @user.id,
              :private    => params[:comment][:private]
            }
          )
          comment.set_privacy!

          kind ||= :comment_made
          if comment.commentable.is_a?(PublicAnswer)
            answer = comment.commentable
            if comment.user.is_self_or_owner?(answer.host_user)
              kind = :author_commented_an_answer              
            end
          end

          Activity.send_message(comment, @user, kind)

          #Forum notification
          if params[:alert] && !comment.private?
            Activity.send_message(comment, @user, :alert_forum_post) if comment.commentable.allow_easy_notifiaction?
          end
          
          PublicQuestionHelper::set_question_artist_id(comment.commentable_user, self)

          if commentable.is_a?(Profile)
            commentable.user.set_wall_tab_active
          elsif commentable.is_a?(Board) && commentable.usernote?
            commentable.user.maybe_set_notes_tab_active(commentable)
          end
        else
          do_reply_comment(commentable, commentable.commentable)
        end
      end
    end

    @entry = commentable

    respond_to do |wants|
      wants.html { redirect_to safe_redirect(params[:curr_url]) }
      wants.js do
        render(:update) do |page|
          page.replace_html "comments_#{dom_id(@entry)}", :partial => "comment/comments", :locals => {:commentable => @entry}
        end
      end
    end
  end

  def do_reply_comment(parent, commentable)
    comment = commentable.add_comment(
      {
        :comment    => params['comment']['comment'],
        :avatar_id  => @avatar ? @avatar.id : nil,
        :user_id    => @user.id,
        :private    => params['comment']['private']
      },
      parent
    )
    comment.set_privacy!
    Activity.send_message(comment, @user, :comment_replied_to)
    PublicQuestionHelper::set_question_artist_id(comment.commentable_user, self)
    if commentable.is_a?(Profile)
      commentable.user.maybe_set_wall_tab_active(parent)
    end
  end

  def reply_comment
    if commentable = (params[:commentable_type]).constantize.find(params[:id])
      parent = Comment.find(params[:parent_id]) # TODO: verify it really belongs in that commentable, move to plugin
      do_reply_comment(parent, commentable)
    end
    redirect_to safe_redirect(params[:curr_url])
  end

  def delete
    @deleted_comment = Comment.find_by_id(params[:id])
    @is_deleted = @deleted_comment && @deleted_comment.delete!(true)
  end

  def view_more
    @entry = (params[:commentable_type]).constantize.find(params[:id])
    @all_comments = @entry.all_comments(false, {:order => "created_at"})
  end

  def delete_thread
    comment = Comment.find(params[:id])
    
    if comment && comment.delete_thread!
      flash[:success] = "Comment thread deleted".t
      if comment.commentable.is_a?(Profile)
        render(:update) {|p| p << "document.location = '#{url_for(userpage_path(comment.commentable.user))}'"}
      elsif comment.commentable.is_a?(UserKroog)
        render(:update) {|p| p << "document.location = '#{url_for(:controller => 'kroogi', :action => 'show', :id => comment.commentable.user, :type => comment.commentable.relationshiptype_id)}'"}
      else
        render(:update) {|p| p << 'document.location.reload(false);'}
      end
    else
      flash[:warning] = "Error deleting thread".t
      render(:update) {|p| p << 'document.location.reload(false);'}
    end
  end

  def tps_participant_was_questioned
    add_comment(:tps_participant_was_questioned)
  end

  def tps_participant_answered
    add_comment(:tps_participant_answered)    
  end
  protected
  
  def ensure_not_blank
    if params[:comment].nil? || params[:comment][:comment].blank?
      flash[:warning] = "Can't create a blank comment".t
      redirect_to safe_redirect(params[:curr_url]) and return 
      false
    end
  end

  def set_user_and_avatar
    # Choose user, with security
    @user = User.find_by_id(params[:comment][:user_id]) if params[:comment][:user_id]
    @user ||= current_actor
    raise Kroogi::NotPermitted unless @user && current_user.is_self_or_owner?(@user)
    @user = User.anonymous if @user.guest?

    # Choose avatar, with security
    @avatar = Image.find_by_id(params[:comment][:avatar_id])
    @avatar = nil unless @avatar && @user.profile.avatars.include?(@avatar)
    @avatar ||= @user.profile.avatar
  end

end
