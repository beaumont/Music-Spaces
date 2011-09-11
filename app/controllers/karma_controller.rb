class KarmaController < ApplicationController
  
  skip_before_filter :run_basic_auth

  def referral
    @content  = Content.find_by_id(params[:content_id])
    @referrer = User.find_by_id(params[:referrer_id])

    @karma_point = KarmaPoint.create!(
      :content      => @content,
      :referrer     => @referrer,
      :referred     => (current_actor if logged_in?),
      :referral_url => request.referer,
      :action       => 'click')
    
    session[:karma_point_id] = @karma_point.id
    
    redirect_to(content_url(@content), :status => :moved_permanently) and return if @content
    redirect_to '/explore'
  end
  
end
