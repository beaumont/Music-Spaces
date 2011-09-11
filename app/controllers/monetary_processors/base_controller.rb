class MonetaryProcessors::BaseController < ApplicationController
  require "uri"

  skip_before_filter :run_basic_auth
  skip_before_filter :verify_authenticity_token,
                     :set_locale, :login_from_cookie, :set_model_user,
                     :ensure_valid_user
  before_filter :check_invitation

  protected
  
  def check_invitation
    if params[:invite_code]
      @invite = Invite.find_by_activation_code(params[:invite_code])
      if @invite.nil?
        u_id, acc_id, nothing = LegacyIdHash.decode(params[:custom] || "")
        sender = User.find_by_id(u_id.to_i)
        account_setting = AccountSetting.find(acc_id.to_i)
        kroog = sender.circles.detect{|x| x.relationshiptype_id == params[:invite_code].to_i}
        @invite = Invite.create(
          :inviter_id => account_setting.user,
          :user_id => sender.id,
          :display_name => sender.display_name,
          :circle_id => kroog.relationshiptype_id
        )      
        Relationship.create_kroogi_relationship(:invite => @invite)
      end
      # Auto sets expiration date in one month if invite is paid
      @invite.accept!
    end
    @invite_kroogi = @invite ? @invite.inviter.kroogi_settings.kind(@invite.circle_id) : nil
  end
end
