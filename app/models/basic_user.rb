class BasicUser < User
  after_create :wizard_needs_to_be_shown

  def basic_user?
    true
  end

  def facebook_id
    self.fb_details.fb_user_id
  end
  
  def self.default_circles
    [1,2,5]
  end

  def default_circle_names
    #lambda needed to have it translated to particular language later
    [lambda{'Family'.t}, lambda{'Friends'.t}, lambda{'Interested'.t}]
  end

  def need_to_show_wizard?
    result = (rare_user_settings ? rare_user_settings.need_to_show_wizard? : nil)
    result
  end

  def wizard_needs_to_be_shown
    toggle_rare_setting!(:need_to_show_wizard)
  end

  def wizard_not_needed!
    rare_user_settings.update_attribute(:need_to_show_wizard, false) if rare_user_settings
  end
  
end
