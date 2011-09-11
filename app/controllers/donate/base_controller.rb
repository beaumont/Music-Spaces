class Donate::BaseController < ApplicationController
  
  before_filter :load_karma_point
  
  protected
  
    # Finds the current karma point for referencing referrals.
    def load_karma_point
      @karma_point = KarmaPoint.find_by_id(session[:karma_point_id])
    end

end