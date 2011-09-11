module Admin::SiteActivityLogsHelper

  def who_visited(log)
    user = log.user || Guest.new
    actor = log.actor || user
    unless user.guest?
      return user_link(user, :icon => true), user_link(actor, :icon => true)
    else
      return "Guest (#{log.robot? ? "robot [#{log.robot}]" : log.session_id.to_s[0,10]})", ""
    end
  end

  def activity_log_users_list(users)
    html = []

    for user in users
      html << content_tag(:div,
        content_tag(:span, user.login, :class => "user_login") +
        content_tag(:span, 
          link_to_remote(
            "x",
            {
              :url => admin_site_activity_log_path(:id => user.id),
              :method => :delete,
              :confirm => "Are you sure you want to delete this user?",
              :before => "jQuery('<img src=\"/images/ajax-loader.gif\">').insertAfter($(this));$(this).remove();"
            },
            :style => "display:none;"
          ),
          :class => "remove_user"),
        :class => "user")
    end

    html.join(" ")
  end


  def browser_color(browser = 0)
    require 'digest/md5'
    Digest::MD5.hexdigest("#{browser}")[0,6]
  end

end