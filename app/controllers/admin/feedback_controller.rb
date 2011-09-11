module Admin

  class FeedbacksFilters
    attr_accessor :show_junk
    def initialize(params)
      return if !params
      @show_junk = true if params[:show_junk] && params[:show_junk].to_i == 1
    end
  end
  
  class FeedbackController < BaseController

    verify :method => :post, :only => [:reply, :mark_as_junk, :mark_as_not_junk],
      :redirect_to => {:action => :index}

    def index
      @filter = FeedbacksFilters.new(params[:filter])
      User.kroogi_devs(true) #refresh cache just in case
      params[:page] = 1 if params[:page].blank?
      finder_params = {:per_page => setpagesize(5), :order => 'id desc',
        :page => params[:page]}
      finder_params.merge! :conditions => {:junk => false} if !@filter.show_junk
      @feedbacks = Feedback.paginate finder_params
      set_paging_header @feedbacks, :entity_name => 'feedback entry'
      @replies ||= {}
    end

    def reply
      f = Feedback.find(params[:id])
      if !params[:reply][:post].blank?
        params[:reply][:post] = ("> <i>%s</i>\r\n\r\n" % f.complaint) +
          params[:reply][:post]
      end
      reply = Pvtmessage.new(params[:reply])

      reply.foruser_id = f.user_id
      reply.parent_id = f.id
      @replies = {f.id => reply}
      @reply_validation = reply
      if !current_user.is_kroogi_dev?
        index
        flash[:error] = 'You need to be member of Kroogi to be able to reply a feedback'.t
        reply.errors.add_to_base("Reply is ok, it's just you don't have access") if reply.errors.blank?
        render :action => :index
        return
      end
      reply.send!(User.kroogi) #yes we always act as Kroogi here - this is for admins convenience
      flash[:success] = 'Your reply was sent successfully'.t
      send_params = {:action => :index}
      send_params.merge! :page => params[:page] if !params[:page].blank?
      redirect_to send_params
    rescue ActiveRecord::RecordInvalid
      index
      flash.now[:error] = 'Reply validation failed. Please check it.'.t
      render :action => :index
    end

    def mark_as_junk
      @feedback = Feedback.find(params[:id])
      @feedback.junk = true
      @feedback.save!
    end

    def mark_as_not_junk
      @feedback = Feedback.find(params[:id])
      @feedback.junk = false
      @feedback.save!
    end

  end
end