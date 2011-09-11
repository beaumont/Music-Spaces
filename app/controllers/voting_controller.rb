class VotingController < ApplicationController
  verify :method => :post, :only => [:vote_up, :rate], :redirect_to => { :controller => '/'}

  def rate
    @rate = params[:rate].to_i
    @ui_id = params[:ui_id]
    klass = params[:type] || 'Content'
    @entry = klass.constantize.find(params[:id])
    @entry.rate @rate, current_user
  end

  def vote_up
    klass = (params[:type] || 'Content').constantize
    @ui_id = params[:ui_id]
    @entry = klass.find(params[:id])
    return if current_user.voted_up?(@entry)
    if current_user.auto_like_to_fb_enabled? and content_is_safe_to_fb_like(@entry)
      begin
        LikePublisher.deliver_like(current_user, @entry, share_url(@entry))
      rescue StandardError => e
        logger.info "Error deliver like : #{e}"
      end
    end
    current_user.vote_up(@entry) unless kroogi_voting_disabled_for_test(@entry)
  end

end
