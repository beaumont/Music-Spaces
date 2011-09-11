module SystemMessages

  class ForumEnabled < SystemMessage
    def accept_action?(controller)
      controller.is_a?(PublicQuestionController) && controller.action_name == 'unpublished'
    end

    def trigger_accepted(trigger)
      trigger.destroy
      nil
    end
  end

end
