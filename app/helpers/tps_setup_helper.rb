module TpsSetupHelper

  def preview(title = "", content = nil, options = {})
    return unless flash[:show_preview]
    flash.delete(:show_preview)
    width = options.delete(:width) || '560px'

    content_for :js do
      javascript_tag("
        jQuery(document).ready(function() {
          jQuery('#preview_overlay').dialog({
            modal: true,
            width: '#{width}',
            resizable: false,
            buttons: {
              Ok: function() {
                jQuery( this ).dialog('close');
              }
            }
        })
      })")
    end

    content_tag(:div,
      content,
      :id => "preview_overlay", :style => "display:none;", :title => 'Preview'.t + ': ' + title)
  end

  def preview_button
    content_for :js do
      javascript_tag("
        jQuery(document).ready(function() {
          jQuery('#preview_button').click(function() {
            jQuery('#preview_content').val('true');
            jQuery('#tpsSetupForm').trigger('submit');
            jQuery(this).html('<span>#{ 'Please Wait...'.t }</span>').next().show();
            jQuery('#tpsSetupForm .button').addClass('button_gr').attr('disabled', 'disabled');
          })
        })")
    end

    content_tag(:div,
      content_tag(:button,
        content_tag(:span, 'Preview'.t),
        :class => "button", :style => "margin-top:5px;", :id => "preview_button",  :onclick => "return false;") +
        wait_up_homie,
      :class => "widget_button_left")
  end

  def translatable_fields(items)
    content_tag(
      :table,
      content_tag(:tr, content_tag(:td,
        render(
          :partial => "shared/translatable_fields2",
          :locals => {:english_body => Proc.new {translatable_lines(items, :en)},
           :russian_body => Proc.new {translatable_lines(items, :ru)}}
        ),
        :colspan => 2, :style => "padding-bottom:0;")
      ),
      :cellpadding => 8, :cellspacing => 0, :border => 0, :class => "edit_basic_info",
      :style =>"padding-bottom:0;", :width => "100%"
    )
  end

  def translatable_lines(items, locale)
    items = [items] if items.is_a?(Hash)
    trs = ""

    items.each do |item|
      object = item[:object]
      method = locale.to_sym == :en ? "_#{item[:field]}" : "#{item[:field]}_ru"
      trs << content_tag(:tr,
        content_tag(:td, content_tag(:b, "#{item[:title]}:"), :class => "left title dontbold") +
        content_tag(:td, object.send(method), :class => "center")
      )
    end

    content_tag(:table, trs)
  end

end