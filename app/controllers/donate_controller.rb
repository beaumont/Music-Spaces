class DonateController < ApplicationController
  layout false
  skip_before_filter :verify_authenticity_token
  verify :method => :post, :only => [:prepare_smscoin_transaction, :prepare_yandex_transaction], :redirect_to => '/'

  before_filter :load_smscoin_passthrough_params, :only => [:load_smscoin_providers, :load_smscoin_costs]
  after_filter :dump_response, :only => [:prepare_smscoin_transaction, :load_smscoin_costs]
  skip_before_filter :run_basic_auth

  def choose
    parse_common_params
    setup_movable
  end

  def choose_iphone
    parse_common_params
    setup_movable
    render :layout => 'phone'
  end

  def setup_movable
    return if APP_CONFIG.movable_disabled
    @countries = Movable::Country.get_current
    min = @content.min_contribution_amount if @content
    @movable_dump = Movable::Country.dump_to_js(@countries, :amounts_more_than => min)
    AdminNotifier.async_deliver_admin_alert("@movable_dump appears to be empty. #{@movable_dump}.\n\n\n #{@countries.inspect}") if @movable_dump.size < 10
  end

  def get_sms_payload
    parse_common_params
    @payload = SmsPayload.calculate(@donor || current_actor, @recipient, @content)
    @sms = SmsPayload.retrieve(@payload)
    render :text => @sms.payload
  end

  def load_smscoin_providers
    country = params[:country]
    @providers = Smscoin::Version.country_providers(country, smscoin_params_filters)
    
    if @providers.size == 1 && !@providers[0][1]
      do_load_smscoin_costs(country, @providers[0][1])
      if request_comes_from_facebook?
        render :partial => '/facebook/donate/smscoin/costs',
               :locals => @passthrough_params.merge(:costs => @costs, :filters => smscoin_params_filters, :box => params[:box])
      else
        render :file => '/donate/smscoin/load_smscoin_costs'
      end
    else
      if request_comes_from_facebook?
        render :partial => '/facebook/donate/smscoin/providers',
               :locals => @passthrough_params.merge(:providers => @providers, :filters => smscoin_params_filters, :box => params[:box])
      else
        render :file => '/donate/smscoin/load_smscoin_providers'
      end
    end
  end

  def load_smscoin_costs
    country = params[:country]
    provider = params[:provider]
    do_load_smscoin_costs(country, provider)
    if request_comes_from_facebook?
      render :partial => '/facebook/donate/smscoin/costs', :locals => {:box => params[:box]}
    else
      render :file => '/donate/smscoin/load_smscoin_costs'
    end
  end

  def prepare_smscoin_transaction
    tparams = params[:transaction]

    project_to_follow, follower_email = tparams.delete(:project_to_follow), tparams.delete(:follower_email)

    option = Smscoin::CostOption.find_by_id(tparams.delete(:cost_option_id))
    unless option
      render :js => ("jQuery('#{smscoin_element_selector} .progress').hide(); jQuery('#{smscoin_element_selector} .status').html('%s')" %
                      ('Cost option not found. Please refresh the page and try again.'.t ))
      return
    end

    errors = []
    unless project_to_follow.blank? || follower_email.blank?
      current_user_wanna_join(project_to_follow, follower_email, tparams[:download] == 'true' ? tparams[:content_id] : nil)
    end
    before_donation_form_submit(tparams, option.gross_usd, errors)

    unless errors.blank?
      render :js => %Q{jQuery('#donation_dialog_error_messages_#{tparams[:dialog_id_suffix]}').html("#{errors.join("\n")}");}
      return
    end

    tparams.reverse_merge!('content_type' => 'Content')
    transaction = Smscoin::Transaction.create!(tparams.merge(:cost_option => option))

    fparams = []
    fparams << ['s_purse', APP_CONFIG.smscoin[:purse_id]]
    fparams << ['s_order_id', transaction.id]
    fparams << ['s_amount', option.net_usd.to_f]
    fparams << ['s_clear_amount', 1]
    d = payment_description(transaction.recipient, transaction.content)
    mofo_d = escape_string_for_smscoin(d) 

    fparams << ['s_description', mofo_d]
    sign = (fparams.map {|x| x[1].to_s} + [APP_CONFIG.smscoin[:secret]]).join('::')
    log.info "string for signing: #{sign}"
    sign = Digest::MD5.hexdigest(sign)
    fparams.find {|x| x[0] == 's_description'}[1] = h(d)
    fparams << ['s_sign', sign]
    @fparams = fparams
    @option = option

    if request_comes_from_facebook?
      render :partial => '/shared/facebook/form_fields', :locals => {:fields => @fparams}
    else
      render :file => '/donate/smscoin/fill_transaction_fields'
    end
  end

  def prepare_yandex_transaction
    tparams = params[:transaction]
    sum = tparams['Sum'].to_f
    errors = []
    unless sum == 0
      current_user_wanna_join(tparams.delete(:project_to_follow), tparams.delete(:follower_email),
                              tparams[:download] == 'true' ? tparams[:content_id] : nil)
      before_donation_form_submit(tparams, sum, errors)
    end

    if errors.blank?
      @fparams = DonationProcessors::Yandex.build_payment_form_params(tparams)
      render :file => '/donate/yandex/fill_transaction_fields'
    else
      render :js => %Q{jQuery('#donation_dialog_error_messages_#{tparams[:dialog_id_suffix]}').html("#{errors.join("\n")}");}      
    end
  end

  def create_tps_goodie_ticket
    goodie = Tps::Goodie.find(params[:id])
    ticket = Tps::GoodieTicket.create!(:goodie_id => goodie.id, :buyer_id => current_user.id, :content_id => goodie.content.id)

    render :js => ("jQuery('#ticket_id_#{goodie.id}').val(#{ticket.id});")
  end
  
  private

  include ActionView::Helpers::TextHelper

  def load_smscoin_passthrough_params
    @passthrough_params = %w(return_url recipient_id donor_id content_id content_type karma_point_id download).map {|key| [key, params[key]]}.to_hash.symbolize_keys
    content_class = params[:content_type] unless params[:content_type].blank?
    content_class ||= Content.name
    @content = content_class.constantize.find(params[:content_id]) unless params[:content_id].blank?
  end

  def do_load_smscoin_costs(country, provider)
    @costs = Smscoin::Version.provider_options(country, provider, smscoin_params_filters).sort {|a, b| b.local_gross <=> a.local_gross}
  end

  def escape_string_for_smscoin(string)
    (0..string.length-1).to_a.map {|i| string.chars[i]}.map do |c|
      if c == '"'
        '\"'
      elsif c == "'"
        "\\'"
      else
        c
      end
    end.join
  end

  def parse_common_params
    @recipient = User.find(params[:recipient_id])
    content_klass = (params[:content_type] || 'Content').constantize #TODO: secure against illegal types submitted by hacker  
    @content   = params[:content_id].blank? ? nil : content_klass.find(params[:content_id])
    @donor     = params[:donor_id].blank? ? nil   : User.find(params[:donor_id])
    @invite_code = "" # invite_or_circle.try(:activation_code)
    @karma_point_id = session[:karma_point_id]
    @suggest_following_project = true
    if @donor && ((@donor == @recipient) || @donor.is_a_follower_of?(@recipient))  
      @suggest_following_project = false
    end
    re = IpToLocation.get_region(request.remote_ip)
    if re
      @monetary_processors = MonetaryProcessor.available_for_donations_in_region(re.region_code) + MonetaryProcessor.not_available_for_donations_in_region(re.region_code)
    else
      @monetary_processors = MonetaryProcessor.available_for_donations      
    end
    @download = (params[:download] == 'true')
    if @content.is_a?(Tps::GoodieTicket)
      @monetary_processors -= [MonetaryProcessor.smscoin] unless @content.goodie.donation?
      @is_goodie = true
      @return_url = user_url_for(@recipient, :controller => '/goodies', :action => 'thank_you') unless @content.tps_ticket?
      @cancel_url = @return_url
    end
    download_val = boolean_param_value(@download) 

    @return_url ||= (@content.nil? ? user_url_for(@recipient, :payment_status => 'Completed', :download => download_val) :
            content_url(@content, :payment_status => 'Completed', :download => download_val))

    @cancel_url ||= (@content.nil? ? user_url_for(@recipient) : content_url(@content))
  end
end
