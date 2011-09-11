class AdvancedUser < User

  def self.default_circles
    [1,2,5]
  end

  def default_circle_names
    #lambda needed to have it translated to particular language later
    [lambda{'Family'.t}, lambda{'Friends'.t}, lambda{'Interested'.t}]
  end

  def advanced_user?
    true
  end

  def facebook_id
    self.fb_details.fb_user_id
  end

end
