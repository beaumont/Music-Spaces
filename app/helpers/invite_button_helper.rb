module InviteButtonHelper
  def wait_indicator(id)
    %Q[ <span style="display: none;" class="overlay_waitindicator" id="#{id}"><img src="/images/ajax-loader.gif" /></span> ]
  end
  
  def invoke_widget_button(button_text, wait_indicator_id, dest_ovr_id, action, options = {})
    return wait_indicator(wait_indicator_id) +
      ( options[:form_id].blank? ?
            link_to_remote('<span>' + button_text + '</span>',
                  :update => dest_ovr_id,
                  :url => { :controller => '/invite', :action => action },
                  :html => { :class => 'button', :onclick => %Q{ jQuery('##{wait_indicator_id}').show(); create_new_div("#{dest_ovr_id}")} }) :
            link_to_remote('<span>' + button_text + '</span>',
                  :update => dest_ovr_id,
                  :submit => options[:form_id],
                  :url => { :controller => '/invite', :action => action },
                  :html => { :class => 'button', :onclick => %Q{ jQuery('##{wait_indicator_id}').show(); create_new_div("#{dest_ovr_id}")} })
      )
  end
end
