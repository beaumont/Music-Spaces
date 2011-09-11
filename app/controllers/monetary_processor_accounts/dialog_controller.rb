class MonetaryProcessorAccounts::DialogController < ApplicationController
  layout "jquery_dialog"
  before_filter :login_required

  before_filter :load_owner, :only => [:attach]

  include WmErrorsHandler

  def attach
    @is_for_wizard = params[:is_for_wizard]
  end

  def delete
    raise "delete called without a params[:id]" if params[:id].blank?
    raise "delete called with an invalid params[:id]: #{params[:id]}" if params[:id].to_i.eql?(0)
    mpa = MonetaryProcessorAccount.find(params[:id].to_i)
    raise "delete called for non-owner" unless current_user.is_self_or_owner?(mpa.account_setting.user)
    mpa.destroy
    flash[:warning] = "Account removed."
    redirect_to :controller => '/money', :action => "index", :id => mpa.account_setting.user.id
  end

  private
  def load_owner
    params[:id] = current_actor.id if params[:id].nil?
    @user = (params[:id].to_i == current_actor.id ? current_actor : User.find_by_id(params[:id]))
    raise Kroogi::NotPermitted unless @user && @user.active?
  end
end
