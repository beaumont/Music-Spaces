module SystemMessages
  class SystemMessage

    #is it appropriate to show the SM in current context?
    def can_be_shown_here?(controller)
      return true
    end

    #What to do if trigger is accepted. A child may decide to remove the trigger.
    #Need to return trigger or nil if it's removed.
    def trigger_accepted(trigger)
      trigger.postpone #don't destroy trigger yet - user can skip action after accepting
      trigger
    end

    #Here the SM can determine by controller context if it's already accepted
    def accept_action?(controller)
      false
    end

    #is trigger stale? don't kill it inside, just answer
    def trigger_stale?(trigger)
      false
    end

    def partial_name
      self.class.name.underscore.split('/').last
    end

    def delay
      RAILS_ENV == 'production' ? 10.days : 5.minutes
    end

    def action_button_title
      nil
    end

    def after_accept_action?
      false
    end
  end
end
