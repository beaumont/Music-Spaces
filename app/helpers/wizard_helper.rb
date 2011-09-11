module WizardHelper

  def next_wizard_step(user, current_step)
    case current_step
    when 0 then 'add_avatar'
    when 2 then (current_user.projects.count > 1 ? 'agreement' : 'basic_info')
    when 4 then (user.project? ? 'agreement' : 'add_content')
    end
  end

  def skip_step_link(step, user=nil)
    controller = 'wizard'
    action = ''
    case step
    when 0 then action = 'add_avatar'
    when 1 then action = 'add_picture'
    when 2 then action = (user.project? && current_user.projects.count > 1) ? 'agreement' : 'basic_info'
    when 4 then action = user.project? ? 'agreement' : 'add_content'
    when 5 then action = 'add_content'
    when 6 then
      controller = 'user'
      action = 'index'
    end
    link = '<span class="default" style="float:right;">'
    link << link_to('Skip this step'.tdown + ' >>', :controller => controller, :action => action, :id => (user.id if user))
    link << '</span>'
  end
  
  require 'digest/md5'

  def generate_buttons_wizard_id
    Digest::MD5.hexdigest("#{rand()} #{Time.current}")[0,5]
  end

  def overlay_for(id, title = '', content = '')
    content_tag(:div,
      content.blank? ? content_tag(:div, "Please Wait...".t, :class => "loading_wizard") : content,
      :id => id, :style => "display:none;", :title => title)
  end

  def show_dialog(id, options = {})
    content_for :js do
      javascript_tag("jQuery(document).ready(function(){#{dialog_js(id, options)}})")
    end
  end

  def dialog_js(id, options = {})
    width = options.delete(:width) || '400px'
    clear = options.delete(:clear) || false
    position = options.delete(:position) || "'middle'"
    "jQuery('##{id}').dialog({
        modal: true,
        resizable: false,
        height: 'auto',
        position: #{position},
        width: '#{width}',
        close: function() {
          jQuery('##{id}').dialog('destroy');
          #{"jQuery('##{id}').empty();" if clear}
        }
     });"
  end

  def get_dialog_data(method)
    javascript_tag("
      jQuery(document).ready(function() {
        jQuery.ajax({url:'/wizard/#{method}', dataType: 'script'})
      })
    ")
  end

  def something_broke
    content_tag(:div, "Sorry, Something Broke.".t, :class => "something_broke")
  end

  def wizard_breadcrumbs(entry = nil)
    separator = '&nbsp;&nbsp;&gt;&nbsp;&nbsp;'
    txt = 'Setup Guide'.t

    unless entry.nil?
      txt << "<span class='default'><b>" + separator + entry + "</b></span>"
    end
    txt
  end
end