class TpsEmbedController < ApplicationController
  layout nil
  skip_before_filter :run_basic_auth, :login_from_cookie
  skip_before_filter :choose_system_message

  def config
    params[:format]="xml"
    @content = Content.find(params[:id])
    @pledge_goal = @content.goal_amount
    @pledge_state = @content.current_collected_percents
  end


end
