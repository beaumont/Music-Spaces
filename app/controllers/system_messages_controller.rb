class SystemMessagesController < ApplicationController
  skip_before_filter :choose_system_message
  before_filter :load_trigger

  def closed
    if params[:dont_show_again]
      @trigger.create_denied_response
      @trigger.destroy
    else
      @trigger.create_postponed_response
      @trigger.postpone
    end
    render(:text => 'OK')
  end

  def accepted
    @trigger.create_accepted_response
    @trigger.accept
    render(:text => 'OK')
  end

  private
  def load_trigger
    @trigger = SystemMessages::ShowTrigger.find(params[:id])
    @message = @trigger.system_message
  end
end
