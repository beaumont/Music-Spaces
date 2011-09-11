module WmErrorsHandler
  def rescue_action(error)
    if error.is_a?(WebMoney::Errors::ConversationError)
      just_notify(error.source)
      flash[:error] = "Sorry, conversation error happened when talking to Webmoney server. We're notified of the issue and will try to help.".t
      redirect_to request.env["HTTP_REFERER"] || '/explore'
    else
      super
    end
  end
end
