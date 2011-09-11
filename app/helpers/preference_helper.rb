module PreferenceHelper

  def edit_setting_breadcrumbs(user, entry = nil)
    separator = ' &nbsp;&nbsp;&gt;&nbsp;&nbsp; ' 
    txt = link_to(user.project? ? 'Project Settings'.t : 'User Settings'.t,
                          :controller => 'preference', :action => 'show', :id => user)
    unless entry.nil?
      txt << "<span class='default'><b>" + separator + entry + "</b></span>"
    end
    txt
  end
end
