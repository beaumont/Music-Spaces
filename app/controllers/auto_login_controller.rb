class AutoLoginController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:switch_user]
  before_filter :admin_required
  
  def switch_user
    unless RAILS_ENV[/production/]
      u = User.find_by_id(params[:login_id])
      self.super_user = current_user unless super_user
      u.update_attribute(:sid, User::SID_STUB)
      self.current_user = u
      redirect_to params[:return_url]
    end
  end
  
  def switchable_users_list
    respond_to do |wants|
      wants.json { }
    end
  end
  
  def clear
    self.current_user = super_user
    self.super_user = nil
    redirect_to userpage_path(self.current_user)
  end
end
