# This controller handles validation of webmoney accounts,
# acceptance of donations, and purse activation.
class MonetaryProcessors::WebmoneyController < MonetaryProcessors::BaseController
  verify :method => :post

  include WmErrorsHandler

  def payment_complete
    common_processing
  end

  def webmoney_postback
    logger.info "[POSTBACK] Running Webmoney postback"
    if params["LMI_PREREQUEST"].to_i == 1 || !params[:LMI_SYS_TRANS_NO] # if they don't have prequest set up
      render :text => "YES", :layout => false, :status => 200
    else
      common_processing
      render :nothing => true    
    end
  end

  def common_processing
    unless (params[:LMI_MODE].to_i != 0 && RAILS_ENV[/production/])
      @mon_contrib = MonetaryDonation.from_webmoney_params(params)
      #@mon_contrib.add_to_kroogi_circle(@invite_kroogi)
      #@mon_contrib.invite = @invite
      @mon_contrib.save!
      #@mon_contrib.invite_guest_user
    end
  end
end
