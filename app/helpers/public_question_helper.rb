module PublicQuestionHelper
  def answers_count_label(count, options = {})
    image_tag('comments.png') + "&nbsp;" + if options[:readonly]
      if count.zero?
        'No answers yet'.t
      else
        '{{count}} Answers' / count
      end
    else
      count.zero? ? 'Leave Answer'.t : 'Leave Answer (total {{count}})' / count
    end
  end

  def time_to_show_question(user, artist, options = {})
    return false unless artist
    return false if user.guest?
    return false if user.is_self_or_owner?(artist)
    return false unless artist.questions_enabled?
    return false if (questions = artist.public_questions.interactive_for(user)).empty?
    show = if options[:force_show]
      true
    else
      counter = AnswerIntervalCounter.find_or_build(user, artist)
      count = counter.cycle!
      count == 0
    end
    return nil unless show 
    PublicQuestion.choose_random(questions)
  end

  def self.set_question_artist_id(artist, controller, options = {})
    flash = controller.send(:flash)
    flash = flash.now if options[:now]
    flash[:question_artist_info] = [artist.id, options[:force_show]]
    log.debug "set_question_artist_id: #{[artist.id, options[:force_show]].inspect}"
  end

  def show_generic_question_widget
    question_user_info = flash[:question_artist_info]
    return false if question_user_info.blank?
    time_to_show_question(current_user, User.find(question_user_info[0]), :force_show => question_user_info[1])
  end

end
