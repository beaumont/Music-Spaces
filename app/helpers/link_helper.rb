module LinkHelper
  include ControllerSharedHelper

  def comment_permalink(comment)
    content_url(comment)
  end	

  # Show comment link (and delete link if applicable)
  def leave_comment_link(item_or_comment, options = {}, url_options = {})
    return '' if item_or_comment.is_a?(Blog)
    user = options[:user]
    options.reverse_merge! :artifacts => {} #a place to collect some data from here

    title = options[:title] || image_tag('comments.png') + "&nbsp;" + 'Leave Comment'.t
    title = answers_count_label(item_or_comment.answers.count) if item_or_comment.is_a?(PublicQuestion)     
    general_link = if item_or_comment.is_a?(Comment)
      link_to(title, content_url(item_or_comment, :anchor => "comment_reply_#{item_or_comment.id}"))
    elsif item_or_comment.is_a?(User)
      link_to(title, :controller => '/user', :action => 'index', :id => item_or_comment, :anchor => 'user-wall')
    else 
      link_to(title, content_url(item_or_comment, url_options.merge(:anchor => "comment_form")))
    end

    return general_link if item_or_comment.is_a?(PublicQuestion)
#    ccount = leave_comment_comment_count(item_or_comment, options[:artifacts])
    ccount = calc_comment_count(item_or_comment)
    unless ccount.blank?
      comment_num_link = if item_or_comment.is_a?(Comment)
        content_link(item_or_comment, :title => ccount)
      elsif item_or_comment.is_a?(User)
        link_to(ccount, :controller => '/user', :action => 'index', :id => item_or_comment, :anchor => 'user-wall')
      else
        link_to(ccount, content_url(item_or_comment))
      end
    end
    
    return "#{general_link} #{comment_num_link}"
  end
  
  def comment_deletion_link(comment)
    return "" if comment.deleted? || !comment.can_delete?

    link = link_to_remote('Delete'.t, 
                        :url => {:controller => 'comment', :action => 'delete', :id => comment},
                        #TODO: change confirmation for answer on public question
                        :confirm => "Are you sure you want to delete this comment?".t, 
                        :before => "jQuery('##{dom_id(comment)} .update_progress').show()")

    ajax_loader + content_tag(:span, link, :class => "iconized i_delete", :id => "delete_#{dom_id(comment)}")
  end

  # was (1), now (1 comment). if any more, merge back in with normal comment link helper
  def tiny_comment_count_link(item)
    return '' if item.is_a?(Blog)
    item = item.profile if item.is_a?(User)
    count = if item.nil? then 0
    elsif item.respond_to?(:comment_count)      then item.comment_count.to_i
    elsif item.respond_to?(:leaves) then item.leaves.count
    else 0
    end
    return '' if count.zero?
    title = if count == 1 then "(1 comment)".t
    else "(%d comments)" / [count]
    end
    
    general_link = if item.is_a?(Comment)
      link_to(title, :controller => 'user', :action => 'thread', :id => user.id, :thread_id => item.id, :anchor => "reply-to=#{item.id}")
    elsif item.is_a?(User)
      link_to(title, :controller => '/user', :action => 'index', :id => item, :anchor => 'user-wall')    
    elsif item.is_a?(Profile)
      link_to(title, :controller => '/user', :action => 'index', :id => item.user, :anchor => 'user-wall')
    else 
      link_to(title, content_url(item) + '#comment_form')
    end
    return general_link
  end

  def comment_action_links(commentable)
    count = calc_comment_count(commentable)
    show_link_caption = image_tag('comments.png') + "&nbsp;" + (count.zero? ? 'Leave a comment'.t : 'Leave a comment ({{count}})' / count)
    hide_link_caption = image_tag('comments.png') + "&nbsp;" + 'Hide Comments'.t

    show_link = link_to_function(show_link_caption, "show_comments_block('comments_#{dom_id(commentable)}')")
    hide_link = link_to_function(hide_link_caption, "hide_comments_block('comments_#{dom_id(commentable)}')")

    content_tag(:span, hide_link, :class => "hide_link", :style => "display:none;") + 
    content_tag(:span, show_link, :class => "show_link")
  end

  def calc_comment_count(item)
    raise "Can't calculate count for Comment instance!!!" if item.is_a?(Comment)
    item = item.profile if item.is_a?(User)
    item && item.respond_to?(:comment_count) ? item.comment_count : 0
  end
  
  def sms_payment_link(title, to_user, thing = nil, custom_opts = {})
    opts = {:user_id => to_user.is_a?(User) ? to_user.id : to_user.to_i}
    if thing
      opts[:payment_for_type] = thing.class.to_s
      opts[:payment_for_id] = thing.id
    end
    opts[:controller] = 'donate/movable_broker'
    opts[:action] = 'send_sms_payment'
    if custom_opts[:button]
      link_to('<span>'+title+'&nbsp;</span>', opts, :class => 'button')
    else
      link_to(title, opts)
    end
  end
  
  # Show AddThis button
  def addthis_button(entry)
    title = "Kroogi :: #{h(entry.title_long.gsub("'", ''))}"
    url = content_url(entry)
    return '' if title.blank? || url.blank?
    
    html = []
    html << "<!-- AddThis Button BEGIN -->"
    html << %Q{<script type="text/javascript">addthis_pub='kroogi'; addthis_logo='http://#{APP_CONFIG[:hostname]}/images/logo.gif';addthis_logo_background='F5F4F0';addthis_brand='Kroogi.com';</script>}
    html << %Q{<a href="http://www.addthis.com/bookmark.php" onmouseover="return addthis_open(this, '', '#{url}', '#{title}')" onmouseout="addthis_close()" onclick="return addthis_sendto()"><img src="http://s7.addthis.com/button1-share.gif" width="125" height="16" alt="" /></a><script type="text/javascript" src="http://s7.addthis.com/js/152/addthis_widget.js"></script>}
    html << "<!-- AddThis Button END -->"
    html.join("\n")
  end

  # Show ShareThis button
  def sharethis_button(entry = nil)
    return '' if entry.nil?
    return '' unless entry.is_a?(Content) || entry.is_a?(User)

    # Only allow this to run once per page (it embeds content in page HEAD section)
    if @this_page_already_shared_via_sharethis.nil?
      @this_page_already_shared_via_sharethis = true
      content_for(:content_metadata) do
        %q{<script type="text/javascript" src="http://w.sharethis.com/widget/?tabs=web%2Cpost%2Cemail&amp;charset=utf-8&amp;style=default&amp;publisher=e238de8f-3b4e-453c-b5ce-fff5f6bfa536&amp;linkfg=%23993300"></script>}
      end
    end
    
    title = "#{'Kroogi'.t} :: #{safe_for_tag(entry.title_long)}"
    description_text = if entry.is_a?(User) then 'A user in the Kroogi Network'.t
    else entry.description.blank? ? (entry.user.project? ? ("A posting on the Kroogi Network by project %s%s" / [entry.user.login, (entry.user.display_name == entry.user.login ? "" : " (#{entry.user.display_name})")]) : ("A posting on the Kroogi Network by user %s%s" / [entry.user.display_name, (entry.user.display_name == entry.user.login ? "" : " (#{entry.user.display_name})")])) : entry.description
    end
    page_url = if entry.is_a?(User) then url_for({:host => user_host(entry.user.login.downcase), :only_path => false, :controller => '/'})
    else url_for(:controller => 'content', :action => 'show', :id => entry.id, :only_path => false, :host => user_host(entry.user.login))
    end
    icon_url = if entry.is_a?(Image) then entry.thumb(:small).public_filename
    elsif entry.is_a?(User) && entry.profile.userpic then entry.profile.userpic.thumb(:small).public_filename
    else ''
    end

    %Q{
      <script language="javascript" type="text/javascript">
      var object = SHARETHIS.addEntry({
          title: encode_utf8("#{title}"),
          summary: encode_utf8("#{description_text}"),
          url: encode_utf8("#{page_url}"),
          published: encode_utf8("#{entry.created_at.iso8601}"),
          author: encode_utf8("#{entry.is_a?(User) ? entry.title_long : entry.user.title_long}"),
          icon: encode_utf8("#{icon_url}")
        }, {button:false} );
        //Output our customized button
        document.write('<span id="sharethis"><a class="stbutton stico_default" href="javascript:void(0);"><span class="stbuttontext" st_page="home">#{'Share This'.t}</span></a></span>');
        //Tie customized button to ShareThis button functionality.
        var element = document.getElementById("sharethis");
        object.attachButton(element);
      </script>
    }
  end
  
  def safe_for_tag(str)
    return '' if str.blank?
    str.gsub(/["><]/, '')
  end
  
  def grab_url_link(item)
    return '' unless item.is_a?(Content) && item.public?
    
    str =  %Q{<a onclick="$('grab-url-box').toggle();" style="cursor:pointer;">#{'Grab URL'.t}</a>}
    str += '<div id="grab-url-box" style="display: none;">'
      str += 'URL'.t + ':'
      str += text_field_tag('grab_url', current_uri, :onclick => 'this.focus();this.select();', :readonly => true) + '<br/><br/>'
      str += 'HTML Link'.t + ':'
      html_link = %Q{<a href="#{current_uri}">#{item.title_short}</a>}
      str += text_field_tag('grab_link', h(html_link), :onclick => 'this.focus();this.select();', :readonly => true) + '<br/>'
    str += '</div>'
    str
  end
  
  # Extracted from current_page? -- returns the current URI
  def current_uri
    "#{request.protocol}#{request.host_with_port}#{request.request_uri}"
  end

  def comments_count_link_or_label(count, options = {})
    no_link = false
    c = image_tag('comments.png') + "&nbsp;" + if options[:readonly]
      if count.zero?
        no_link = true
        'No comments yet'.t
      else
        options[:some_comments_label] || '{{count}} Comments' / count
      end
    else
      count.zero? ? 'Leave Comment'.t : options[:some_comments_label] || ('Leave Comment ({{count}})' / count)
    end
    no_link ? c : yield(c) 
  end

  def circle_link(user, relationship)
    link_to(h(user.circle_name(relationship.relationshiptype_id)),
            :host => user_host(user.login), :controller => 'kroogi', :action => 'show', :id => user,
            :type => relationship.relationshiptype_id)
  end

  def invited_circle_link(user, invitation)
    link_to(h(user.circle_name(invitation.circle_id)),
            :host => user_host(user.login), :controller => 'kroogi', :action => 'show_pending', :id => user,
            :type => invitation.circle_id)
  end
  def requested_circle_link(user, inviterequest)
    link_to(h(user.circle_name(inviterequest.circle_id)),
            :host => user_host(user.login), :controller => 'kroogi', :action => 'show', :id => user,
            :type => inviterequest.circle_id)
  end
end
