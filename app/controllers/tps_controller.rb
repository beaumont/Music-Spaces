class TpsController < ApplicationController
  before_filter :login_required
  before_filter :load_hat_by_id, :only => [:goodies, :payments, :participants, :request_participant_info]

  before_filter :load_participant_by_id, :only => [:approve_participant, :deapprove_participant, :participant_dialogue,
                                                   :participant_attrib, :update_participant_attrib]

  before_filter :load_artist

  before_filter :owner_only, :only => [:payments, :participants, :request_participant_info, :approve_participant,
                                       :deapprove_participant, :participant_attrib, :update_participant_attrib,
                                       :setup]
  
  skip_before_filter :verify_authenticity_token, :only => [:goodies]

  def goodies
    if DonationProcessors.in_successful_payment_handler?(self)
      flash.now[:success] = "Thank you for supporting {{user_name}}'s '{{content_title}}'" / [@hat.user.display_name,
                                                                                              @hat.title]
    end
    @ticket_ids = Tps::GoodieTicket.pending.of_buyer(current_user).of_hat(@hat).
            map {|ticket| [ticket.goodie_id, ticket.id]}.to_hash

    @picked_tickets = Tps::GoodieTicket.picked.of_buyer(current_user).of_hat(@hat).map {|ticket| ticket}.
            sort {|a, b| a.goodie.identifier <=> b.goodie.identifier}
  end

  def payments
    @payments = @hat.payments
    @total_gross = @payments.map {|t| t.gross_amount_usd }.sum
    @total_net = @payments.map {|t| t.net_amount_usd }.sum
  end

  def participants
    @title = 'TPS Participants info'.t
    participants = @hat.participants
    @unreplied_participants = participants.unfilled
    sorter = lambda {|col| col.all(:include => :user, :order => 'users.login')}
    @unreplied_participants = sorter.call(@unreplied_participants)

    @replied_participants = participants.filled
    @replied_participants = sorter.call(@replied_participants)
  end

  def request_participant_info
    from = params[:request_info_from].map {|id| Tps::Participant.find(id)}
    from.each {|participant| participant.create_request}
    flash[:success] = 'Successfully sent {{count}} requests' / from.count
    redirect_to :action => 'participants', :id => params[:id] 
  end

  #redirector needed for some time 'cause we sent the url in emails
  def submit_info
    redirect_to :controller => '/goodies', :action => 'submit_info', :id => params[:id]
  end

  def approve_participant
    @participant.approve!
    redirect_to(participants_url(@hat))
  end

  def deapprove_participant
    @participant.deapprove!
    redirect_to(participants_url(@hat))
  end

  #redirector needed for some time 'cause we sent the url in emails
  def participant_dialogue
    redirect_to :controller => '/goodies', :action => 'participant_dialogue', :id => params[:id]
  end

  def participant_attrib
    render :text => @participant.send(params[:attrib]) || ''
  end

  def update_participant_attrib
    @participant.send(params[:attrib] + '=', params[:value])
    @participant.save_without_validation!
    render :partial => "/shared/in_place_value", :object => @participant.send(params[:attrib])    
  end
  
  protected
  
  def load_hat_by_id
    @hat = Tps::Content.find_by_id(params[:id])
    unless @hat
      flash[:error] = params[:id].blank? ? 'tps content not specified' : 'tps content not found'
      redirect_to '/'
    end
  end

  def load_artist
    @user = @hat.user if @hat
    @user ||= User.find_by_login(user_subdomain)
  end

  def owner_only
    raise Kroogi::NotPermitted unless current_user.is_self_or_owner?(@user)
  end

  def load_participant_by_id
    @participant = Tps::Participant.find_by_id(params[:id])
    unless @participant
      flash[:error] = params[:id].blank? ? 'tps participant not specified' : 'tps participant not found'
      redirect_to '/' and return
    end
    @hat = @participant.content
  end

  def participants_url(hat)
    {:action => 'participants', :id => hat.id}
  end
end
