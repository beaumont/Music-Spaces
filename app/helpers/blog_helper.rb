module BlogHelper
  
  # Provides a LJ style link back to either community or personal LJ page depending on account type
  def link_to_livejournal(account)
    returning ' ' do |ret|
      ret << "<a href=\"#{@account.link}\" target=\"_blank\">"
      if account.is_community?
        ret << "<img src=\"/images/community.gif\" border=\"0\" style=\"vertical-align:top\">"
      else
        ret << "<img src=\"/images/userinfo.gif\" border=\"0\" style=\"vertical-align:top\">"
      end
      ret << "</a><b><a href=\"#{@account.link}\" target=\"_blank\">#{@account.display_name}</a></b>"
    end
  end
  
end
