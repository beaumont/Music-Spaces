module Admin

  class TpsController < BaseController

    def stop
      @project = User.find_by_login(params[:id])
      redirect_to '/' unless @project
      @hat = Tps::Content.of_project(@project).first
      redirect_to '/' unless @hat
      if request.post?
        unless @hat.stopped?
          @hat.stop
          @hat.make_money_available
          flash[:success] = "{{project}}'s TPS has been stopped" / @project.login
        else
          flash[:warning] = "{{project}}'s TPS was stopped already" / @project.login          
        end
        redirect_to :id => @project.login
      end
    end
  end
end