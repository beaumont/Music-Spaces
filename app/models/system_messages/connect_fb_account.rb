module SystemMessages

  class ConnectFbAccount < SystemMessage
    def trigger_stale?(trigger)
      not trigger.user.show_find_fb_friends_sm?
    end

    def action_button_title
      "Reconnect".t
    end

    def after_accept_action?
      true
    end
  end
end
