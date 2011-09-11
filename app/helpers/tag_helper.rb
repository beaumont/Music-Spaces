module TagHelper

  def search_tabs(user_count = 0, content_count = 0, type = "users", query = "")
    html = ""
    
    html << content_tag(:div,
      link_to("People and Projects".t + " (#{user_count})", search_results_url(query, 'users')),
      :class => "main_left_tabs spaced_out #{'selected' if type == 'users'}")

    html << content_tag(:div,
      link_to("Content Items".t + " (#{content_count})", search_results_url(query, 'content')),
      :class => "main_left_tabs spaced_out #{'selected' if type == 'content'}")

    html
  end

end