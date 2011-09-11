class Facebook::DonateController < Facebook::ApplicationController
  protect_from_forgery :except =>[:prepare_yandex_transaction]
  
  def prepare_yandex_transaction
    tparams = params[:transaction]
    @fparams = DonationProcessors::Yandex.build_payment_form_params(tparams)
    render :partial => '/shared/facebook/form_fields', :locals => {:fields => @fparams}
  end

end