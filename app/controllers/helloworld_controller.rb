class HelloworldController < ApplicationController

  def explore
    redirect_to(explore_path)
  end

  def feedback
    feedback = params[:big_feedback_field]
    feedback = params[:feedback_field] if feedback.blank?
    unless feedback.blank?

      if !params[:from].blank?
        sent_from = uri_unescape(params[:from])
      else
        sent_from = request.env['HTTP_REFERER']
      end
      
      @feedback = Feedback.create(:user_id => current_user.id,
        :complaint => feedback,
        :environment => request.env.inspect.to_s,
        :sent_from => sent_from,
        :ip => request.remote_ip)
    end
    respond_to do |wants|
      wants.js
      wants.html {render :nothing => true}
    end
  end
  
end
