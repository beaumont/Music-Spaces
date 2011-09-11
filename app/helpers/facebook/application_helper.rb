module Facebook::ApplicationHelper

  def fb_google_analytics_tag(opts = {})
    if RAILS_ENV == 'production'
      fb_google_analytics(opts[:uacct])
    end
  end

  def self.url_for_canvas(options = {})
    options ||= {}
    rewritten_url = ""
    rewritten_url << "http://apps.facebook.com"
    rewritten_url << Facebooker.facebook_path_prefix + "/"
    if options[:controller]
      rewritten_url << options[:controller] + "/"
    end
    if options[:action]
      rewritten_url << options[:action] + "/"
    end
    if options[:id]
      rewritten_url << options[:id].to_s
    end
    if options[:expand]
      rewritten_url << "?expand=#{options[:expand]}"
    end
    if options[:fb_referrer_id]
      rewritten_url << "?fb_referrer_id=#{options[:fb_referrer_id]}"
    end
    rewritten_url
  end

  def url_for_canvas(*args)
    Facebook::ApplicationHelper.url_for_canvas(*args)
  end

  def viewer_first_name(user, options = {})
    options.merge!(:first_name_only => true, :linked => false)
    fb_name(user.facebook_id, options)
  end

  def pluralize_with_style(count, singular, style)
    case count
    when 0 then "<span class='#{style}'>#{count} #{singular.pluralize}</span>"
    when 1 then "<span class='#{style}'>#{count} #{singular}</span>"
    else "<span class='#{style}'>#{count} #{singular.pluralize}</span>"
    end
  end

  def albums_count(count, singular)
    case count
    when 0 then ""
    when 1 then "#{count} #{singular} is"
    else "#{count} #{singular.pluralize} are"
    end
  end

  def send_album_link(text,id, options = {})
    url = {:controller=>'invite', :action=>'new', :id => id}
    if options[:absolute]
      url = url_for_canvas(url)
    end
    link_to text, url, :requirelogin=> options[:requirelogin] ? options[:requirelogin] : 0
  end

  def bookmark_album_link(text,id, options = {})
    link_to text, {:controller=>'content', :action=>'bookmark', :id => id}, :requirelogin=> options[:requirelogin] ? options[:requirelogin] : 0
  end

  def publish_album_link(link_text,entry)
    unless current_fb_user.nil?
      current_user_name = current_fb_user.facebook_display_name

      publish_url = fb_content_link(entry, :action => 'publish')
      album_url = url_for_canvas(:controller => "content", 
                                 :action => "show",
                                 :id=> entry.id)
      album_url << "?fb_referrer_id=#{current_fb_user.facebook_id}&fb_referral_type=profile" if current_fb_user
      image_link = current_fb_user ? fb_content_link(entry,
                                                     :fb_referrer_id=>current_fb_user.facebook_id,
                                                     :fb_referral_type=>'profile') : fb_content_link(entry)
      image_path =  entry.respond_to?(:cover_art) && entry.cover_art ? entry.cover_art.thumb(:thumb).public_filename : image_path('AlbumNoPictureLarge.png')
      text = "Check out #{entry.title} from #{entry.user.display_name}"

      on_click = "showPublishFeedForm('#{text}','#{album_url}','#{image_path}','#{image_link}', '#{publish_url}')"
      link_to link_text,'#', {:onclick => on_click, :requirelogin=> 1}
    else
      link_to link_text,album_url, {:requirelogin=> 1}
    end
  end

  def sent_history_count(content)
    return '' unless content
    if current_fb_user && content
      @sent_num = current_fb_user.content_sent_to_friends_count(content)
    end
    @sent_num
  end

  def friend_status(friend,content)
    last_act =  Facebook::User.friend_last_activities_on_content(content,friend)
    str = ""
    str << "#{time_ago_in_words(last_act.created_at)} ago" if last_act
    str
  end

  def received_history(content)
    return '' unless content
    if current_fb_user && content
      str = ""
      friend_list = current_fb_user.content_receive_from_friends(content, :group=>true)
      unless friend_list.empty?
        str << "<div class='innerFooterTitle'>This album was sent to you by</div>"
        str << "<div class='greyLine'></div>"
        str << "<div class='friends'>"
        friend_list.each_with_index do |item, index|
          friend = User.find_by_id(item.from_user_id)
          str << "<div class='sentFrom'>"
          str << "<div class='friendUserpic'>"
          str << fb_profile_pic(friend.facebook_id, :size => :square, :width => "34px")
          str << "</div>"
          str << "<div class='name'>"
          str << link_to(fb_name(friend.facebook_id, :linked => 'false'), :controller => 'user', :action =>'friend_albums_list', :id => friend.facebook_id)
          str << "</div>"
          str << "<div class='date'>"
          str << item.created_at.strftime("%d %B, %Y")
          str << "</div>"
          str << "</div>"
        end
        str << "</div>"
      end
    end
    str
  end

  def sent_to_friends_count
    return '' unless current_fb_user
    count = current_fb_user.sent_to_friends_count
    to_friend = 0
    count.each do |key, value|
      to_friend += value
    end
    str = ""
    str << "You sent "
    str << "#{pluralize(count.size, 'Album')} to "
    str << "#{pluralize(to_friend, 'friend')}"
  end

  def sent_artist_to_friends_count(artist)
    return '' unless current_fb_user
    count = current_fb_user.sent_artist_to_friends_counts(artist)
    to_friend = 0
    count.each do |key, value|
      to_friend += value
    end
    str = ""
    str << "You sent "
    str << "#{pluralize(count.size, 'Album')} to "
    str << "#{pluralize(to_friend, 'friend')}"
  end

  def download_link_div(content)
    return '' if content.nil? || current_fb_user.nil?
    artist = content.user.display_name
    album_link = "<span>#{download_links(content.bundles)}</span>"
    message = ""
    if current_fb_user
      if current_fb_user.has_donated_to_content?(content)
        message << "#{album_link}"
        message << "<div class='thankYou'>Thank you for your contribution!</div>"
      elsif @has_donated #0$ donation
        message = "#{album_link}"
      else
        if content.min_contribution_amount
          donation_message = "Minimum necessary contribution is #{content.min_contribution_amount} USD"
        else
          donation_message = "Enter any amount, even if it is 0."
        end
        message = "<div>"
        message << "Contribute to <b>"
        message << "<span class='artistName'>"
        message << artist
        message << "</span>"
        message << " </b> before downloading. <br/>#{donation_message}"
        message << "</div>"
      end
    end
    str = "<div class='item' style='clear:both;'>"
    str << message
    str << "</div>"
  end

  def download_links(bundles)
    return '' unless bundles
    if bundles.is_a?(Bundle)
      link_to bundle_titles(bundles), bundles.s3_url
    elsif bundles.is_a?(Array)
      str = ""
      if bundles.empty?
        str << "#{'No attached files'.t}"
      else
        bundles.each do |bundle|
          str << "<span class='downloadFile'>#{bundle_links(bundle)}</span>" if bundle.is_a?(Bundle)
        end
      end
      str << '</ul>'
    end
  end

  def bundle_titles(bundles, options = {})
    return '' if !bundles
    if bundles.is_a?(Bundle)
      if options[:links]
        link_to bundle_titles(bundles), bundles.s3_url
      else
        bundles.size.blank? ? "#{bundles.filename}" : "(#{number_to_human_size(bundles.size)})"
      end
    elsif bundles.is_a?(Array)
      str = "<strong>#{'Items available to download'.t}:</strong>"
      str << '<ul>'
      if bundles.size == 0
        str << "<li><em>#{'No attached files'.t}</em></li>"
      else
        bundles.each do |bundle|
          if bundle.is_a?(Bundle)
            str << (options[:links] ? "<li style=\"font-weight: bold; font-size: 14px;\">#{bundle_links(bundle)}</li>" : "<li>#{bundle_titles(bundle)}</li>")
          end
        end
      end
      str << '</ul>'
    end
  end

  def create_download_dialog(entry)
    current_user_name = current_fb_user.facebook_display_name
    url_async = facebook_absolute_url("/facebook/save_as/#{entry.id}")
    
    album_url = url_for_canvas(:controller => "content", :action => "show", :id=> entry.id)
    album_url = album_url + "?fb_referrer_id=#{current_fb_user.facebook_id}&fb_referral_type=profile" if current_fb_user

    image_link = current_fb_user ? fb_content_link(entry,:fb_referrer_id=>current_fb_user.facebook_id,:fb_referral_type=>'profile') : fb_content_link(entry)
    image_path =  entry.respond_to?(:cover_art) && entry.cover_art ? entry.cover_art.thumb(:thumb).public_filename : image_path('AlbumNoPictureLarge.png')
    
    text = "#{current_user_name} downloaded #{entry.title} "
    params[:payment_status] == "Completed" ? text << "and made a contribution to" : text << "from"
    text << " #{entry.user.display_name} using Kroogi Downloads."

    filename = "#{entry.bundles.first.filename} (#{number_to_human_size(entry.bundles.first.size)})"
    dialog_content = "Click on the Download Button to start downloading : #{filename}"

    <<-HTML
    var download_dialog = new Dialog().showChoice('Start Downloading', '#{dialog_content}', button_confirm='Download', button_cancel='Skip')
    download_dialog.onconfirm = function() {
      setTimeout(function F1() {showDownloadFeedForm("#{escape_javascript(text)}","#{album_url}","#{image_path}","#{image_link}");return true;}, 100);
      setTimeout(function F2() {xhr_call();}, 3000);
      return true;}
    download_dialog.oncancel = function() {}
    function xhr_call() {
      var ajax = new Ajax();
      ajax.responseType = Ajax.RAW;
      ajax.requireLogin = true;
      ajax.ondone = function(data) {
          document.setLocation(data)
      };
      ajax.post('#{url_async}');
    }
    HTML
  end

  # Return a link, or a <ul> of links, given bundle items (attached to FolderWithDownloadables).
  def bundle_links(bundles)
    return '' if bundles.nil? || current_fb_user.nil?
    if bundles.is_a?(Bundle)
      if (current_fb_user.has_donated_to_content?(bundles.bundle_for) || @has_donated)
        link_to("Click here to download",'#', {:onclick => "#{create_download_dialog(bundles.bundle_for)}"})
      else
        bundle_titles(bundles)
      end
    elsif bundles.is_a?(Array)
      str = "<strong>#{'Items available to download'.t}:</strong>"
      str << '<ul>'
      if bundles.empty?
        str << "<li><em>#{'No attached files'.t}</em></li>"
      else
        bundles.first do |bundle|
          str << "<li class='downloadFile'>#{bundle_links(bundle)}</li>" if bundle.is_a?(Bundle)
        end
      end
      str << '</ul>'
    end
  end

  def fb_content_link(item, opts = {})
    opts[:controller] ||=  "content"
    opts[:action] ||=  "show"
    opts[:id] = item.id
    payment_gross = opts.delete(:payment_gross)
    fb_referrer_id = opts.delete(:fb_referrer_id)
    fb_referral_type = opts.delete(:fb_referral_type)
    link = url_for_canvas(opts)
    link << "?payment_gross=#{payment_gross}" if payment_gross
    link << "?fb_referrer_id=#{fb_referrer_id}" if fb_referrer_id
    link << "&fb_referral_type=#{fb_referral_type}" if fb_referral_type
    link
  end

  def fb_canvas_content_url(item, opts = {})
    opts[:controller] ||=  "content"
    opts[:action] ||=  "show"
    opts[:id] = item.id
    url_for({:host => "apps.facebook.com#{Facebooker.facebook_path_prefix}", :only_path => false}.merge(opts)).sub(/\/facebook/,"")
  end

  def link_to_toggle(item, opts = {})
    link_txt = opts.delete(:link_txt)
    show = opts[:show]
    url =  params[:fb_sig_added] == 1 ? "#" : "#{fb_content_link(item)}?expand=#{show ? show : opts[:expand]}"
    str = "<a href='#{url}' clicktotoggle='#{show},#{show}_img_down,#{show}_img_up' requirelogin='1'>#{link_txt}</a>"
    if opts[:icon]
      str << "<span>"
      str << image_tag(opts[:icon], :class=>"icon")
      str << "</span>"
    end
    str
  end


  def toggle_box(entry, opts = {})
    return "none" if entry.nil?
    box = opts[:box]
    if current_fb_user
      if box == "download"
        if expand_download_box?(entry)
          "block"
        else
          "none"
        end
      elsif box == "donate"
        if expand_donate_box?
          "block"
        else
          "none"
        end
      end
    else
      "none"
    end
  end

  def expand_download_box?(entry)
    current_fb_user.has_donated_to_content?(entry) || @has_donated || (params[:expand] == 'downloadboxContent')
  end

  def expand_donate_box?
    params[:expand] == 'donateboxContent'
  end

  def toggle_arrows(entry, opts = {})
    return "none" if entry.nil?
    box = opts[:box]
    reverse = opts[:reverse]
    if current_fb_user
      if box == "download"
        if expand_download_box?(entry)
          reverse == 'true' ? "block" : "none"
        else
          reverse == 'true' ? "none" : "block"
        end
      elsif box == "donate"
        if expand_donate_box?
          reverse == 'true' ? "block" : "none"
        else
          reverse == 'true' ? "none" : "block"
        end
      end
    else
      "none"
    end
  end

  def help_content_box_visibility(title,text,id)
    txt = ""
    txt << "<div class='technology'>"
    txt << image_tag('arrow_down.gif', :class => 'helpArrow', :clicktotoggle=>"text#{id},arrow_down#{id},arrow_right#{id}", :style=>'display:none', :id=>"arrow_down#{id}")
    txt << image_tag('arrow_right.gif', :class => 'helpArrow', :clicktotoggle=>"text#{id},arrow_down#{id},arrow_right#{id}", :id=>"arrow_right#{id}")
    txt << link_to(title,'#',:clicktotoggle=>"text#{id},arrow_down#{id},arrow_right#{id}")
    txt << "</div>"
    txt << "<div class='thelanguage' id='text#{id}' style='display:none'>"
    txt << text
    txt << "</div>"
  end

  def activity_link(activity)
    if current_fb_user.has_sent_content?(activity.content)
      txt = ""
      txt << "Contributions"
    else

    end
    send_album_link("Send to more friends", activity.content_id, false)
  end

  ###############
  @@downloaded = Activity::ACTIVITIES[:content_downloaded][:id]
  @@invite_sent = Activity::ACTIVITIES[:content_invite_sent][:id]
  @@purchased = Activity::ACTIVITIES[:content_purchased][:id]
  @@published = Activity::ACTIVITIES[:content_published_to_wall][:id]
  @@save_to_my_albums = Activity::ACTIVITIES[:content_saved_to_my_albums][:id]

  def donations_status(activity)
    paid_status = ""
    if current_fb_user.has_donated_to_content?(activity.content)
      paid_status << "You contributed $ #{activity.amount_total} for this album. Thank you! "
    elsif current_fb_user.has_downloaded?(activity.content)
      paid_status << "Did you enjoy this album? "
      paid_status << link_to('Please contribute',{:controller => 'content', :action => 'show', :id => activity.content.id, :expand => 'donateboxContent'})
    end
    paid_status
  end

  def activity_last_action_message(activity,friend_id)
    if friend_id
      last_act = Facebook::User.friend_last_activities_on_content(activity.content,friend_id)
    else
      last_act = current_fb_user.last_activities_on_content(activity.content)
    end
    unless last_act.nil?
      act_type_id = last_act.activity_type_id
      if act_type_id == @@downloaded
        "Dowloaded #{time_ago_in_words(last_act.created_at)} ago"
      elsif act_type_id == @@purchased
        "Contributed #{time_ago_in_words(last_act.created_at)} ago"
      elsif act_type_id == @@invite_sent
        "Sent #{time_ago_in_words(last_act.created_at)} ago"
      elsif act_type_id == @@published
        "Published #{time_ago_in_words(last_act.created_at)} ago"
      elsif act_type_id == @@save_to_my_albums
        "Added #{time_ago_in_words(last_act.created_at)} ago"
      end
    end
  end

  def facebook_sidebar_partial(item)
    base = 'shared/facebook/sidebar/'

    return base + item + ".fbml.erb"
  end

  # Show the kroogi picture for the given user/project/profile (make it fix within a certain sized frame)
  def fb_profile_picture(thing, opts = {})
    return '' unless thing
    profile = thing.is_a?(Profile) ? thing : thing.profile
    user = thing.is_a?(User) ? thing : thing.user

    # Set sizes for default picture (note - max_height currently ONLY implemented for default picture)
    if profile.nil? || profile.userpic.nil?
      wi = user.project? ? 300 : 200
      he = user.project? ? 200 : 300
      max_width = opts.delete(:max_width)
      max_height = opts.delete(:max_height)

      # First resize so the width fits, if needed
      unless max_width.blank? || wi < max_width
        ratio = max_width.to_f / wi
        wi = max_width
        he = (ratio * he).to_i
      end

      # Then resize so the height fits, if still needed
      unless max_height.blank? || he < max_height
        ratio = max_height.to_f / he
        he = max_height
        wi = (ratio * wi).to_i
      end

      return [wi, he] if opts[:just_dimensions]
      return image_tag("#{user.project? ? 'project' : 'user'}_placeholder.jpg", :alt => 'Default Kroogi image', :style => "width: #{wi}px; height: #{he}px;")
    else # Calculate real width offsets
      #TODO : remove this check when all existing images has been cropped.
      if profile.userpic.thumb(:square).public_filename.eql?('/images/missing_image.png')
        img = profile.userpic.thumb(:big)
        
        # Project images get a larger max width
        max_width = opts.delete(:max_width)
        max_width ||= user.project? ? 300 : 200
          
        max_height = opts.delete(:max_height)

        width = thumb_dim(profile.userpic, :big, :width)
        height = thumb_dim(profile.userpic, :big, :height)
        if width > max_width
          height = (height * (max_width.to_f / width)).to_i
          width = max_width
        end
      
        if height > max_height
          width = (width * (max_height.to_f / height)).to_i
          height = max_height
        end
        
      else
        img = profile.userpic.thumb(:square)
        width = 100
        height = 100
      end

      return [width, height] if opts[:just_dimensions]

      image = image_tag(img.public_filename, :style => "width: #{width}px; height: #{height}px;", :alt => profile.userpic.title)

      return image unless opts[:zoom] || opts[:content_link]
      return link_to(image, content_url(profile.userpic)) if opts[:content_link]
      link_to(image, userpage_path(user))
    end
  end


  #Helper that renders a link to the user at kroogi
  def ext_kroogi_user_link(user, options ={})
    return if user.nil?
    unless options[:title]
      options[:title] = "You".t if options.delete(:detect_you) && user == current_actor
      options[:title] = user.display_name if options.delete(:use_display_name)
      titles = [(user.login || '').strip, user.display_name.strip] if options.delete(:use_both)
      titles.reverse! if options.delete(:reversed)
      options[:title] = "%s (%s)" % titles if titles && titles[0] != titles[1]
      options[:title] ||= user.login
      options[:title] += options[:suffix] if options[:suffix]
    end
    options.delete(:suffix)

    if options[:limit]
      html_title = options[:title]
      options[:title] = truncate(options[:title], :length => options[:limit]) if options[:title].chars.size > options[:limit]
    end

    if options.delete(:icon)
      options[:title] = image_tag(user.project? ? 'project.png' : 'kruser.png', :style => 'margin-right: 3px;') + options[:title]
      options[:title] = '<span style="white-space: nowrap;">' + options[:title] + '</span>'
    end

    if options.delete(:no_link)
      return options[:title]
    end

    caption = options.delete(:title)
    if html_title
      options[:title] = html_title
    end
    if options[:activity_id] && !options.delete(:public_context)
      link_to( caption,
        {:controller => 'activity', :action => 'read_and_frwd', :id => options[:activity_id], :type => options[:frwrd_type], :locale => options[:locale]},
        options.delete_if{|key, value| key == :activity_id || key == :frwrd_type})
    else
      link_to(caption, user_path_options(user, {:locale => options.delete(:locale)}), options)
    end
  end

  def kdf_simple(content, opts = {})
    return "" if content.blank?
    opts.delete(:truncate)
    tags = ActionView::Base.sanitized_allowed_tags.to_a
    tags = tags - opts.delete(:skip_tags){ Array.new }
    tags << opts.delete(:tags)
    logger.info "************************8 tags #{tags}"

    opts[:characters] ||= opts.delete(:truncate_length){ 100000000000 }
    opts[:ending] == nil

    content =  content.blank? ? '' : sanitize(KroogiFormat.new(content,
                                                               :tags => tags.compact.flatten))
    truncated_text = (content.chars.length > opts[:characters] ? content.chars[0...opts[:characters]] : content).to_s

    parts = truncated_text.split(" ")
    if parts.length > 1
      parts.pop
      truncated_text = parts.join(" ").chars
    end
    parts = truncated_text.split("<")
    if parts.length > 1
      parts.pop if !parts.last.include?(">")
      truncated_text = parts.join("<").chars
    end

    str =  "<span id='truncated'>#{truncated_text}&nbsp;</span>"
    str << "<span id='full' style='display:none'>#{content}&nbsp;</span>"
    str << "<a id='show_text' href='#' clicktohide='show_text,truncated' clicktoshow='full,hide_text'>Read More ></a>" if content.chars.length > opts[:characters]
    str << "<a id='hide_text' href='#' clicktohide='full, hide_text' clicktoshow='show_text,truncated' style='display:none'>< Read less</a>" if content.chars.length > opts[:characters]
    str
  end

  #impact
  def download_impact_on_artist(music_albums)
    count = 0
    music_albums.each do |ma|
      count += current_fb_user.download_impact_on_content_counter(ma)
    end
    pluralize_with_style(count, 'Person', 'quantity')
  end

  def donate_impact_on_artist(music_albums)
    count = 0
    music_albums.each do |ma|
      count += current_fb_user.donate_impact_on_content_counter(ma)
    end
    pluralize_with_style(count, 'Contribution', 'quantity')
  end

  def invite_impact_on_artist(music_albums)
    count = 0
    music_albums.each do |ma|
      count += current_fb_user.invite_impact_on_content_counter(ma)
    end
    count
  end

end
