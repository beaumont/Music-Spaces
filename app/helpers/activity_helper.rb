module ActivityHelper
  def msg_unread
    session[:msg_unread_only] = true if session[:msg_unread_only].nil?
    return session[:msg_unread_only]
  end

  def activity_icon(type, options = {})
    case type
      # followers
      when :invite_accepted
#	      '[icon] Joined'
        ''
      when :invite_deleted
#	      '[icon] Left'
        ''
      when :invite_denied
#	      '[icon] Rejected'
        ''
      # new content
      when :published_image then
        'i_image'
      when :published_track then
        unless options[:content].music_contest_item?
          'i_music'
        else
          'i_contest'
        end
      when :published_album then
        'i_album'
      when :published_music_album then
        'i_music_album'
      when :published_blog then
        'i_blog'
      when :published_writing
#	      '[writing icon]'
        ''
      when :sent_pvtmsg
#	      '[message icon]'
        ''
      when :published_announcement then
        'i_announcement'
      when :created_project then
        'i_project'
      when :added_as_favorite then
        'i_favorite_add'
      when :published_question then
        'i_question'
      when :published_answer, :author_answered_his_question, :author_commented_an_answer then
        'i_answer'
      when :added_project_to_collection
        'i_plus'
      else
        type.to_s
    end

    #"[missing type - icon] #{type}" # should not happen
  end

  # pass as such
  # activity_url_for(one_liner, activity, "title of link", {:id => 5, :blah => "blah"})
  def activity_url_for(one_liner, activity, * args)
    link_options = args.extract_options!.merge(:controller => 'activity', :action => 'read_and_frwd')
    if one_liner
      if activity.content.is_a?(Content) || activity.content.is_a?(PublicQuestion) || activity.content.is_a?(PublicAnswer)
        link_options =  content_url(activity.content)
      end
      link_options = user_url_for(activity.content) if activity.content.is_a?(User)
    end
    link_options = comment_url(activity.content) if activity.comment?
    link_content = args.first
    link_to(link_content, link_options)
  end

  def remove_pvt(message, title = '')
    link_to(image_tag('remove.png', :alt => 'Delete Message'.t),
        "javascript:void(0);",
        :title => title,
        :class => "private_message_links",
        :user => "#{js message.from_user.login}",
        :activity_id => message.id,
        :from_user_id => message.from_user_id)
  end

end
