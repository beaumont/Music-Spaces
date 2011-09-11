class
UserObserver < ActiveRecord::Observer
  def after_create(user)
    if [BasicUser, AdvancedUser].include?(user.class) && user.respond_to?("activation_code") && !user.recently_activated?
      UserNotifier.async_deliver_signup_notification(user) 
    end
  end

end