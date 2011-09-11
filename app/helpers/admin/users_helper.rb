module Admin::UsersHelper
  
  def user_state_css(user)
    if user.deleted?
      'background: #990000;'
    elsif user.blocked?
      'background: #FF9999;'
    else ''
    end
  end

  def cycle_color
    cycle("light", "dark")
  end

  def get_questions_kit_name(kits, user)
    settings = user.rare_user_settings
    if settings.blank? || settings.questions_kit_id.blank?
      "Not Assigned".t
    else
      kit = kits.detect {|k| k[:id] == settings.questions_kit_id}
      kit.blank? ? "" : kit[:name]
    end
  end

  def options_for_questions_kit(kits, selected)
    options = []

    kits.each do |kit|
      options << [kit[:name], kit[:id]]
    end

    options_for_select(options, selected)
  end

end
