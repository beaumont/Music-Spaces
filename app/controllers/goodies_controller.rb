class GoodiesController < ApplicationController
  before_filter :load_project, :only => [:index, :payments, :participants, :thank_you]
  before_filter :load_hat_by_id, :only => [:request_participant_info]
  before_filter :load_participant_by_id, :only => [:approve_participant, :deapprove_participant, :participant_dialogue, :participant_attrib, :update_participant_attrib]
  before_filter :owner_only, :only => [:payments, :participants, :request_participant_info, :approve_participant, :deapprove_participant, :participant_attrib, :update_participant_attrib]
  skip_before_filter :verify_authenticity_token, :only => [:index]

  def index
    @title = "List of {{project}}'s Goodies" / h(@project.display_name)
    if DonationProcessors.in_successful_payment_handler?(self)
      flash.now[:success] = "Thank you for supporting {{user_name}}" / @project.display_name
    end
    @goodies = Tps::Goodie.with_contents.of_project(@project).non_tps
    
    @ticket_ids = Tps::GoodieTicket.pending.of_buyer(current_user).
            map {|ticket| [ticket.goodie_id, ticket.id]}.to_hash

    @picked_tickets = Tps::GoodieTicket.picked.of_buyer(current_user).with_contents.non_tps.map {|ticket| ticket}.
            sort {|a, b| a.goodie.identifier <=> b.goodie.identifier}
  end

  def payments
    @payments = Tps::Goodie.payments(@project)
    @total_gross = @payments.map {|t| t.gross_amount_usd }.sum
    @total_net = @payments.map {|t| t.net_amount_usd }.sum
  end

  def participants
    @title = 'TPS Participants info'.t
    participants = Tps::Participant.with_contents.of_project(@project)
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

  def submit_info
    @title = 'Goodie Receiver'.t + '::' + 'submit personal info'.t
    @info_request = Tps::ParticipantInfoRequest.find(params[:id])
    #not just @request because that wouldn't play well with ExceptionNotifier 
    @hat = @info_request.content
    participant = @info_request.participant
    raise Kroogi::NotPermitted unless current_user.is_self_or_owner?(participant.user)
    
    if participant.approved?
      flash[:success] = 'Your information is already fulfilled. Please write a private message to {{project}} if you want to correct it.' / @hat.user.login 
      redirect_to(:action => 'participant_dialogue', :id => participant.id) and return
    end
    unless request.get?
      @info_request.attributes = params[:tps_participant_info_request]
      if @info_request.save_answer
        flash[:success] = 'Thank you for submitting information about yourself'.t
        redirect_to(content_url(@hat))
      end
    end
  end

  def approve_participant
    @participant.approve!
    redirect_to(participants_url(@hat))
  end

  def deapprove_participant
    @participant.deapprove!
    redirect_to(participants_url(@hat))
  end

  def participant_dialogue
    @title = 'TPS Participant'.t + '::' + 'personal info discussion'.t
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
  
  def load_project
    @project = User.find_by_login(user_subdomain)
    unless @project
      flash[:error] = 'project not found'
      redirect_to '/'
    end
    @user = @project
  end

  def load_hat_by_id
    @hat = Tps::Content.find_by_id(params[:id])
    unless @hat
      flash[:error] = params[:id].blank? ? 'tps content not specified' : 'tps content not found'
      redirect_to '/'
    end
  end

  def owner_only
    project = @project
    project ||= @hat.user if @hat 
    raise Kroogi::NotPermitted unless current_user.is_self_or_owner?(project)
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
    {:action => 'participants', :host => user_host(hat.user)}
  end
end
