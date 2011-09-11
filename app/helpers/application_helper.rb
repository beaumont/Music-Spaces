# translation ver 1 pass 1 -- AK

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper

  #facebook profile url
  @@facebook_profile_url = "http://www.facebook.com/profile.php?id="

  #some urls MUST be absolute for Facebook development
  def facebook_absolute_url(url)
    url = '/' + url unless url.starts_with?('/')
    image_path(url)
  end

  def fb_connect_admin_meta_tag
    if RAILS_ENV == 'production'
      %Q{<meta property="fb:app_id" content="#{FB_CONNECT_CONFIG[:app_id]}" />}
    end
  end

  # Prevent errors from nil concats
  def build_title(*args)
    args.compact.join(' :: ')
  end

  # HACK! This should be automagic with globalize, and usually is. But sometimes it's not, can't figure out why...
  def force_bulktext_render(file)
    if I18n.base_locale?
      log.debug "force_bulktext_render: it's base locale - returning %s" % file
      return file
    end
    
      ['rhtml', 'html.erb'].each do |suffix|
        nfile = "#{file}.#{I18n.language_code}.#{suffix}"
        no_underscore = nfile
        nfile_parts = nfile.split('/')
        absolute_path = (nfile_parts.size > 1)
        nfile_parts.last.gsub!(/^/, '_')
        with_underscore = nfile_parts.join('/')

        path = File.join(RAILS_ROOT, 'app', 'views', absolute_path ? '' : params[:controller], with_underscore)
        #returning no_underscore because force_bulktext_render is used with render :partial which adds underscore itself
        if File.file?(path)
          log.debug "force_bulktext_render: found %s" % no_underscore
          return no_underscore
        end
      end
    log.warn "localized version of '%s' not found" % file
    return file
  end

  def circle_preset_values(kroog)
    msg  = 'Circle is'.t + ' '
    msg += kroog.open? ? 'open for anyone to join'.t : 'invitation-only'.t
    unless kroog.open?
      msg += ', ' + (kroog.can_request_invite? ? 'users can request invites'.t : 'no invitation requests allowed'.t)
    end
    return msg
  end
  
  # Content-specific class for the gallery_item wrapper div
  def gallery_class(item, large = false)
    cname = case item.class.to_s
    when Image.name then 'img'
    when BasicUser.name, AdvancedUser.name  then 'img'
    when Track.name then large ? 'audio_outer_lg' : 'audio_outer_sm'
    else 'text2'
    end
    return "gallery_#{cname} gallery_item"
  end

  # Content-specific styling for the gallery_item wrapper div
  def gallery_style(item, large = false)
    s = if item.is_a?(Image) then css_cropping_for(item.thumb( large ? :big : :thumb), :image_border, large)
    #elsif  item.is_a?(Track) || item.is_a?(Textentry) then css_cropping_for(item, :track_border, large)
    elsif  item.is_a?(Project) then item.profile.userpic ? css_cropping_for(item.profile.userpic.thumb( large ? :big : :thumb), :image_border, large) : css_cropping_for(nil, :image_border, large, large ? [200, 132] : [100, 66])
    elsif  item.is_a?(User) then item.profile.userpic ? css_cropping_for(item.profile.userpic.thumb( large ? :big : :thumb), :image_border, large) : css_cropping_for(nil, :image_border, large, large ? [146, 220] : [80, 120])
    else ''
    end
    return s
  end


  # Confusing... using CSS to crop and place images and borders shown in fixed size frames
  def css_cropping_for(image, context, is_large, dims = [])
    limit = case context
    when :image then is_large ? 221 : 121
    when :image_border then is_large ? 221 : 121
    when :track then is_large ? 179 : 98
    when :track_border then is_large ? 183 : 102
    when :album_image then is_large ? 150 : 80
    else nil
    end
    
    # Don't bother cropping if no limit
    return '' unless limit

    # For track we're not resizing based on image, just return set width
    return "width: #{limit}px;" if context == :track || context == :track_border

    # Proportionally set height/width
    if dims.blank?
      #an edge case - having prod error for it now
      return "width: #{limit}px; height: #{limit}px;" unless image && image.width && image.height

      sorted = [image.width, image.height].sort
      hw_array = if sorted.max < limit then [image.height, image.width]
      else 
        bigger = sorted.last
        smaller = sorted.first
        ratio = (limit.to_f / (sorted.max))
      
        new_big = limit
        new_small = (smaller*ratio).to_i
      
        (image.width >= image.height) ? [new_small, new_big] : [new_big, new_small]
      end
      h = hw_array[0]; w = hw_array[1]
    else # Allow dimensions to be passed in explicitly
      h = dims[1]; w = dims[0]
    end
    # Little buffer for image borders
    if context == :image_border
      w += 4
      h += is_large ? 20 : 5
    end
    
    return "width: #{w}px; height: #{h}px;"
  end

  # For gallery items - select a partial based on content type
  def gallery_partial(item)
    base = '/content/gallery/'
    suffix = case item.class.to_s
      when CoverArt.name then 'image'
      when Image.name then 'image'
      when Track.name then 'track'
      when Video.name then 'video'
      when Textentry.name then 'text'
      when Inbox.name then 'album'
      when Album.name then 'album'
      when FolderWithDownloadables.name then 'album'
      when MusicAlbum.name then 'album'
      when MusicContest.name then 'album'
      when BasicUser.name, AdvancedUser.name, Project.name, CollectionProject.name then 'user'
      when ProjectAsContent.name then 'user'
      else 'text'
    end
    
    return base + suffix + ".html.erb"
  end

  def open_graph_type(item)
    og_type = ''
    og_type = case item.class.to_s
      when MusicAlbum.name, FolderWithDownloadables.name, MusicContest.name then 'album'
    end
    og_type
  end

  def open_graph_entity?(item)
    return true unless open_graph_type(item).nil?
  end

  def create_fb_admins_list
    fb_admins = ["100001911146078", "#{FB_CONNECT_CONFIG[:app_id]}"]
    fb_admins.push(current_fb_connected_user.id) if current_fb_connected_user
    fb_admins.uniq.join(',')
  end

  # Returns icons to indicate which sorts of content this album contains
  def album_content_icons(album)
    if album.is_a?(Inbox)
      count = album.inbox_contents.count
      if album.archived?
        label = 'Archived'.t
      elsif count.zero?
        label = 'No Submissions'.t
      else
        label = '%s Items' / [count]
      end
      return link_to('<div style="color:white; text-align: center;">' + label + '</div>', content_url(album))
    end
    
    children = album.album_contents
    
    icon_types = children.collect{|x| x.entity_name_for_human.capitalize}.uniq
    to_display = children.map {|c| "<span class=\"iconized #{icon_class(c)}\" style=\"padding-left: 14px !important;\">&nbsp;</span>"}.uniq
    
    if album.is_a?(MusicAlbum)
      to_display = ["<span class=\"iconized #{icon_class(MusicAlbum.name)}\" style=\"padding-left: 14px !important;\">&nbsp;</span>"]
    end

    if album.is_a?(MusicContest)
      to_display = ["<span class=\"iconized #{icon_class(MusicContest.name)}\" style=\"padding-left: 14px !important;\">&nbsp;</span>"]
    end

    if album.downloadable?
      if album.is_a?(MusicContest)
        label = 'View'.t
      else
        label = 'Download'.t
      end
    elsif icon_types.size == 1
      # Add informative label if only one item type in album
      label = icon_types.first.pluralize.t
      label = "#{label} (#{children.size})"
    end
    to_display << '<span style="color:white;">' + label + '</span>' if label
    
    link_to(to_display.join(' '), content_url(album))
  end

  # Show the kroogi picture for the given user/project/profile (make it fix within a certain sized frame)
  def profile_picture(thing, opts = {})
    return '' unless thing
    profile = thing.is_a?(Profile) ? thing : thing.profile
    user = thing.is_a?(User) ? thing : thing.user
    
    # Set sizes for default picture (note - max_height currently ONLY implemented for default picture)
    if profile.nil? || profile.userpic.nil?
      wi = user.project? ? 300 : 200
      he = user.project? ? 200 : 300
      max_width = opts.delete(:max_width)
      max_height = opts.delete(:max_height)
      max_width ||= 200
      
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
      if user.project?
        return image_tag("project_placeholder.jpg", 
                          :alt => 'Default Kroogi image', :style => "width: #{wi}px; height: #{he}px;")
      else 
        
      return image_tag("user_placeholder#{user.gender == "M" ? '_man' : ''}.jpg", 
                        :alt => 'Default Kroogi image', :style => "width: #{wi}px; height: #{he}px;")
      end
      
    else # Calculate real width offsets
      img = profile.userpic.thumb(:big)

      # Project images get a larger max width
      max_width = opts.delete(:max_width)
      max_width ||= 200
      
      width = thumb_dim(profile.userpic, :big, :width)
      height = thumb_dim(profile.userpic, :big, :height)
      if width > max_width
        height = (height * (max_width.to_f / width)).to_i
        width = max_width
      end
      
      return [width, height] if opts[:just_dimensions]
      
      image = image_tag(img.public_filename, :style => "width: #{width}px; height: #{height}px;", :alt => profile.userpic.title)
      
      return image unless opts[:zoom] || opts[:content_link]
      return link_to(image, content_url(profile.userpic)) if opts[:content_link]
      link_to(image, userpage_path(user))
    end
  end

  def picture_border(str, width, opts = {})
    %{<div style="width: #{width}px;#{ 'margin: 0 auto;' if opts.delete(:center)}">
      <div class="gallery_r_border3">
        <div class="gallery_r_border2">
          <div class="gallery_r_border1" style="background: #FFF;">
            #{str}
          </div>
        </div>
      </div>
    </div>}
  end
  
  def picture_profile(str, width, opts = {})
    %{ <div>
          #{str}
      </div>}
  end

  # html_escape has h, escape_javascript now has js
  def js(thing)
    escape_javascript(thing)
  end

  # Decide whether or not to highlight the current circle in kroogi_fluff
  def highlight_circle(circle_idx)
    circle_idx == params[:type].to_i
  end
  
  # Decide whether or not to consider highlight the current circle in kroogi_fluff (e.g. are in /kroogi/show type pages)
  def consider_highlighting
    params[:controller] == 'kroogi' && params[:action] == 'show'
  end

  def manual_render_to_string(options = nil, &block)
    render(options, &block)
  end

  # For view translations
  def ru?
    I18n.language_code == 'ru'
  end
  
  def show_copyright?(content)
    return false if [Blog, Album, ProjectAsContent].any? {|klass| content.is_a?(klass)}
    return false if content.music_contest_item? 
    true
  end

  # Show the copyright string for the given content
  def copyright(content)
    return '' unless content.is_a?(Content)
    datestamp = content.created_at.to_s(:date_with_time)
    who = user_link(content.user)
    if content.user.project? && permitted?(content.user, :profile_edit) && !content.submitter.nil? 
      who += " (#{user_link(@entry.submitter)})"
    end
    
    unless show_copyright?(content)
      return content.is_a?(Inbox) ? ('Created by %s at %s' / [who, datestamp]) : ('Posted by %s at %s' / [who, datestamp])
    end
    
    str = '&copy; '      
    if content.owner != content.user.login
      str += h(content.owner) + ', posted by %s at %s' / [who, datestamp]
    else
      str += who + ', ' + datestamp
    end
    return str
  end
  
  # Handles logic to see if new founder messages exist (to show messages icon)
  def new_founder_msgs(user)
    return false unless user.project?
    return false unless founder_kroog = user.kroogi_settings.detect{|x| x.relationshiptype_id == Relationshiptype.founders}
    return false unless founder_kroog.comment_count > 0
    return false unless current_actor.is_self_or_owner?(user) || user.project_founders_include?(current_actor)
    true
  end
  
  def classes_for_tab(name, tabs)
    return 'logod' if tabs.first.first == name
    return ''
  end
  
  def content_additional_class(content)
    return '' unless content.is_view_permitted?
    
    case content.class.name.to_s
    when 'Track'     then 'gallery_sound'
    when 'Textentry' then 'gallery_text'
    when 'Album'     then 'gallery_album'
    else ''
    end
  end

  def icon_class(content)
    name = content.is_a?(String) ? content : content.class.name.to_s
    
    case name
    when Track.name      then 'i_music'
    when Image.name      then 'i_image'
    when Blog.name       then 'i_blog'
    when Board.name      then 'i_announcement'
    when Textentry.name  then 'i_text'
    when Album.name      then 'i_album'
    when Project.name    then 'i_project'
    when BasicUser.name  then 'i_user'
    when AdvancedUser.name  then 'i_user'
    when Video.name      then 'i_video'
    when MusicAlbum.name then 'i_music_album'
    when MusicContest.name then 'i_contest'
    when PublicQuestion.name then 'i_question'
    else ''
    end
  end

  # Generate a login link
  def login_link_params(opts = {})
    params = { :controller => 'home', :action => 'login', :host => user_domain, :contribution => opts[:contribution] }
    params.merge!(:flash => true) if opts[:flash]
    params.merge!(:return_to => opts[:return_to]) if opts[:return_to]
    params
  end

  def login_link (txt, opts = {}, html_opts = {})
    link_to(txt, login_link_params(opts), html_opts)
  end


  # Extract the basic logic on whether to skip activity notification or not
  def skip_activity(activity)
    skip = false
    skip = true if activity.content.nil?
    skip = true if activity.content.respond_to?(:is_view_permitted?) && !activity.content.is_view_permitted?
    skip = true unless Activity.partial_exists?(activity)
    return skip
  end
  
  # Owner needs warning if announcement isn't published
  def owners_announcement_not_on_kroogi_page(content)
    if current_actor == content.user && content.is_a?(Board) && !content.is_in_startpage?
      '<strong>[ ' + 'not on Kroogi Page'.t + ' ]</strong>'
    end
  end

  # outer album > inner album
  def album_breadcrumbs(entry)
    return '' unless entry.is_a?(Content)
    separator = ' &nbsp;&nbsp;&gt;&nbsp;&nbsp; ' 
    return '' if entry.is_a?(Board) # Announcements aren't in showcase
    return nil unless entry.respond_to?(:albums)
    return link_to("In %s's Blog" / [entry.user.login], :controller => 'blog', :action => 'index', :id => entry.user) if entry.is_a?(Blog)
    return "#{link_to('Submitted by friends of'.t, {:controller => 'user', :action => 'inboxes', :id => entry.user})} #{user_link(entry.user, :icon => true)}" if entry.is_a?(Inbox)
    return [user_link(entry.user, :title => "Main ((page))".t), "Contests".t].join(separator) if entry.is_a?(MusicContest)
    return [user_link(entry.user, :title => "Main ((page))".t), "Contests".t, content_link(entry.container_album, :length => 30)].join(separator) if entry.music_contest_item?
    return user_link(entry.user, :title => 'In %s' / entry.user.display_name) if entry.is_a?(ProjectAsContent)
    this = entry.albums.find_by_id(params[:album_id]) if params[:album_id]
    if this && this.featured_album?
      return [user_link(entry.user, :title => "Main ((page))".t), "Featured Content".t].join(separator)      
    end
    
    txt = []
    this ||= entry.albums.to_a.reject {|a| a.featured_album?}.first
    while this
      str = content_link(this, :length => 30)
      str += " (#{'Downloadable'.t})" if this.downloadable? && !this.is_a?(MusicContest)
      txt << str
      this = this.albums.first
      this = nil if this && this.featured_album?
    end

    anchor = "In %s's Content" / [entry.is_a?(User) ? entry.login : entry.user.login]
    id = entry.is_a?(User) ? entry.id : entry.user.id

    txt << (logged_in? ? link_to(anchor, {:controller => '/user',
          :action => 'gallery', :id => id}) : anchor)

    return txt.reverse.join(separator)
  end
  
  
  def display_album_icon(album, display_large = false)
    # Calculate offsets
    background_width = display_large ? 120 : 70
    background_height = display_large ? 120 : 70
    background_offset_x = display_large ? 14 : 8
    background_offset_y = display_large ? 9 : 6
    
    wrapper_width = background_width + (2*background_offset_x)
    wrapper_height = background_height + (2*background_offset_y)

    base = image_tag("AlbumThumb#{display_large ? 'Large' : 'Small'}.png")
    
    inner_wrapper = if album.blank? then ''
    else    
      # Which image are we using?
      thumbnail = album.has_image? ? image_for_item(album).thumb(display_large ? :small : :tiny) : nil

      image_width = thumbnail ? thumbnail.width.to_i : (display_large ? 94 : 47)
      image_height = thumbnail ? thumbnail.height.to_i : (display_large ? 77 : 32)

      if image_width >= image_height
        if image_width > (background_width-2)
          image_width = (background_width-2) 
          ratio = background_width.to_f / image_width
          image_height = (ratio * image_height)
        end
      else
        if image_height > (background_height-4)
          image_height = (background_height-4) 
          ratio = background_height.to_f / image_height
          image_width = ratio * image_width
        end
      end

      inner = if album.has_image? then image_tag(thumbnail.public_filename, :height => image_height, :width => image_width)
      else image_tag("AlbumNoPicture#{display_large ? 'Large' : 'Small'}.png")
      end

      
      # Apply styling
      l = ((background_width - image_width) / 2) + background_offset_x - 2
      t = ((background_height - image_height) / 2) + background_offset_y - 2
      styling = "position: absolute; left: #{l}px; top: #{t}px;"
      content_tag('div', inner, :style => styling)
    end    
    
    # Wrap it all up and deliver
    content = content_tag('div', base + inner_wrapper, 
      :class => "album_wrapper #{display_large ? 'large' : 'small'}"#,
      #        :style => "width: #{wrapper_width}px; height: #{wrapper_height}px;"
    )
    content_tag('div', link_to(content, content_url(album)), :class => 'album_wrapper_wrapper')
  end

  def image_for_item(user_or_content)
    if user_or_content.is_a?(User)
      user_or_content.profile.userpic
    elsif user_or_content.respond_to?(:cover_art) && user_or_content.cover_art
        user_or_content.cover_art
    elsif user_or_content.respond_to?(:random_image)
      user_or_content.random_image
    end
  end
  
  def kf_simple(full_string, opts = {})
    return "" if full_string.blank?
    opts.reverse_merge!(:bigger_truncation => 3000)
    full_string = full_string.chars[0..opts[:bigger_truncation]].to_s if opts[:bigger_truncation]
    opts.delete(:truncate)

    tags = ActionView::Base.sanitized_allowed_tags.to_a
    tags = tags - opts.delete(:skip_tags){ Array.new }
    tags << opts.delete(:tags)

    attributes = ActionView::Base.sanitized_allowed_attributes.to_a
    attributes << opts.delete(:attributes)

    kroogi_formated_text = KroogiFormat.new(full_string, {:ignore => opts.delete(:ignore)})

    opts[:characters] ||= opts.delete(:truncate_length)
    opts[:characters] = nil if kroogi_formated_text.have_flash_embeds?    
    opts[:characters] ||= 100000000000
    opts[:ending] ||= opts.delete(:truncate_extra){ "..." }

    conditional_excerpt = opts.delete(:conditional_excerpt)
    inplace_link        = opts.delete(:inplace_link)

    if should_excerpt?(conditional_excerpt, kroogi_formated_text, opts)
      if inplace_link
        excerpted_text = AutoExcerpt.new(sanitize(kroogi_formated_text,
                                                :tags => tags.compact.flatten,
                                                :attributes => attributes.compact.flatten), opts.merge!(:ending => ''))
        inplace_link_for_excerpt(excerpted_text, full_string, opts)
      else
        AutoExcerpt.new(sanitize(kroogi_formated_text,
                                                :tags => tags.compact.flatten,
                                                :attributes => attributes.compact.flatten), opts)
      end
    else
      sanitize(kroogi_formated_text,
                    :tags => tags.compact.flatten,
                    :attributes => attributes.compact.flatten)
    end
  end

  #TODO: move it to KroogiFormat - less coupling, more encapsulation
  def should_excerpt?(conditional_excerpt, pre_formated_text, opts = {})
    if conditional_excerpt && pre_formated_text.kroogicut_tag_matched?
      false
    elsif pre_formated_text.have_flash_embeds? && pre_formated_text.text_minus_html_count < opts[:characters]
      false
    elsif pre_formated_text.nocut_tag_matched?
      false
    else
      true
    end
  end

  def inplace_link_for_excerpt(text, full_string, settings = {})
    return text.body if text.body.chars.length < settings[:characters]
    id = full_string.object_id
    "<span id='link#{id}'>#{text}&nbsp; (<a href='#' onclick='toggleDiv(#{id}, \"link#{id}\");return false'>#{'...'}</a>)</span><div id='#{id}' style='display:none'>#{text.body}</div>"
  end

  def kf_title(content, options = {})
    strip_tags(content) # tod - move title_short here
  end

  def kf_content(content, opts = {})
    kf_simple content, opts.reverse_merge(:tags => %w(embed object param),
                       :attributes => %w(width height name value type allowscriptaccess allowfullscreen flashvars)
    )
  end
  

  def simple_format_no_p(tx)
    return nil if tx.nil?
    tx = tx.to_s
    tx.gsub!(/\r\n?/, "\n")              # \r\n and \r -> \n
    tx.gsub!(/\n\n+/, "<br /><br />")        # 2+ newline  -> paragraph
    tx.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />')  # 1 newline   -> br
    return tx
  end

  def me_only_icon
    image_tag('eye.png')
  end
  
  def security_icon(content)
    return '' if !content.is_a?(Content) || content.public?
    if [0,-1].include?(content.restriction_level) then me_only_icon
    else image_tag('lock.gif', :style => 'margin-bottom: -2px;')
    end
  end

  def security_string(content, opts = {})
    return (opts.delete(:hide_if_public) ? '&nbsp;' : 'Public'.t) if content.public?
    str = if [0,-1].include?(content.restriction_level) then ' ' + ("%s only" / h(content.user.login))
    else ' ' + ("%s and closer" / [content.user.circle_name(content.restriction_level)] )
    end

    image = security_icon(content)
    
    return image + str
  end

  def base_language_only
    yield if I18n.base_locale?
  end

  def not_base_language
    yield unless I18n.base_locale?
  end

  # Avatar Helper that renders a specific type of avatar, a small one
  #  :see def avatar for parameter documentation and usage
  #
  def avatar_md(user_or_avatar, options = {})
    options[:height] ||= '30'
    options[:avatar_size] = :tiny
    return avatar(user_or_avatar, options)
  end

  # Avatar Helper that renders a specific type of avatar, a medium one
  #  :see def avatar for parameter documentation and usage
  #
  def avatar_md(user, options = {})
    options[:height] = '50'
    return avatar(user, options)
  end

  def avatar_lg(user, options = {})
    options[:height] = '80' 
    return avatar(user, options)
  end


  # Profile Image Helper that renders a profile image, parameters similar to avatar
  #  :see def avatar for parameter documentation and usage
  #
  def profile_img(profile, options = {})
    options[:outer_class] = "profile_img_outer" unless options[:outer_class]
    options[:height] = 200 unless options[:height]
    height = (profile.userpic.thumb(:big).height.to_i >= options[:height].to_i) ? options[:height].to_i : profile.userpic.thumb(:big).height
    top_offset = (options[:height].to_i > profile.userpic.thumb(:big).height.to_i) ? ((options[:height].to_i - profile.userpic.thumb(:big).height.to_i) / 2).to_s + 'px': 'auto';

    iid = options[:id] || 'krugi_existing'
    profile_img = image_tag(profile.userpic.thumb(:big).public_filename, :height => height, :id => iid, :aa => options[:height].to_i, :bb => profile.userpic.thumb(:big).height.to_i,:style => 'margin-top:'+ top_offset +';')
      
    profile_img_w_link = link_to(profile_img, profile.userpic.thumb(:preview).public_filename, :rel => 'lightbox')
    return '<div class="'+ options[:outer_class] +'">' + profile_img_w_link + '</div>'
  end
    
      
  # Main Helper that renders an avatar
  #  all avatars should be drawn using this helper
  #
  # - :user_or_avatar -
  #     can be either an instance of user (in which case default avatar will be used), or an avatar itself
  # - :options - two types -
  #      html_options that are passed though to <img> tag
  #      custom options to specify various avatar bevafiour
  #
  # Usage:
  #    avatar(user)  - default - will render a basic default user avatar
  #    avatar(avatar)  default - will render a basic  avatar from an image object
  #    avatar(user, {:avatar_size => :tiny, :style => "border:1px solid red"}) same but tiny size and red border
  #  and so on, you get the picture
  #
  def avatar(user_or_avatar, options = {})
    options[:outer_class] ||= "founder_avatar"
    avatar = nil
    user = nil
    # If we were given a user, find the avatar
    if user_or_avatar && (user_or_avatar.is_a?(User) || user_or_avatar.is_a?(Guest))
      user = user_or_avatar
      avatar = user_or_avatar.profile.avatar if user_or_avatar.profile 
    elsif user_or_avatar # Otherwise, find the user from the given avatar
      avatar = user_or_avatar
      user = avatar.user
    end

    have_avatar = avatar

    if have_avatar
      options[:avatar_size] ||= :small
      thumb = avatar.thumb(options[:avatar_size]) if avatar
      options.merge!({:border => 0, :alt => user.nil? ? 'Default avatar' : h(user.login)})
      if thumb.new?
        thumb = avatar.thumb(:small) if options[:avatar_size] == :tiny
        thumb = avatar.thumb(:tiny) if options[:avatar_size] == :small
      end
      unless options[:size] || options[:height]
        options[:size] = thumb.image_size
      end
      if options[:height]
        # check real dimensions of image and swap height to width
        # if horizontal orientation if image much wider than higher to prevent upscaling
        if (thumb.width || 0) > (thumb.height || 0)
          options = options.dup
          options[:width] = options.delete(:height)
        end
      end
      avatar_img = image_tag(thumb.public_filename, options)
    else
      options[:size] = '80x80' unless options[:size] || options[:height]
      options.merge!({:border => 0, :alt => (user ? user.login : '')})
      avatar_img = image_tag( no_avatar_image_path(user) , options)
    end
    
    if user_or_avatar.nil? || (user_or_avatar.respond_to?('guest?') && user_or_avatar.guest?) || options[:no_link]
      avatar_link = avatar_img
    else
      if options[:activity_id]
        avatar_link = link_to(avatar_img, {:controller => 'activity', :action => 'read_and_frwd', :id => options[:activity_id], :type => options[:frwrd_type]})
      elsif avatar.nil? && user.id == current_actor.id
        # if no avatar and its user's own
        avatar_link = link_to avatar_img, {:controller => 'profile', :action => 'edit_avatar', :id => user.profile.id}
      else
        avatar_link = link_to avatar_img, {:host => user_host(user.login), :only_path => false, :controller => '/'}
      end
    end

    if !options[:outer_class]
      options.merge!({:outer_class => 'summary_avatar'})
    end

    no_avatar_link = ''

    if !have_avatar && user == current_actor && !options[:skip_add_link]
      no_avatar_link = link_to 'Add Avatar'.t, {:controller => 'profile', :action => 'edit_avatar', :id => user.profile.id}
      no_avatar_link = '<div class="profile_img_add_'+ ((options[:height].to_i < Image.attachment_options[:thumbnails][:small].to_i) ? "sm" : "med") +'">'+no_avatar_link+'</div>'
    end

    '<div class="'+ options[:outer_class] +'">' + no_avatar_link + avatar_link + '</div>'
  end

  def no_avatar_image_path(user)
    "/images/noavatar_med#{user.gender == "M" ? '_man' : ''}.gif"
  rescue
    "/images/noavatar_med.gif"
  end

  # Helper that renders a link to the user
  def user_link(user, options ={})
    return if user.nil?
    title = options.delete(:title)
    unless title
      title = "You".t if options.delete(:detect_you) && user == current_actor
      title = user.display_name if options.delete(:use_display_name)
      title ||= (user.kd_user? ? "Facebook" : user.login)

      limit = 30 unless options.has_key?(:length) || options.has_key?(:limit)
      limit ||= (options.delete(:length) || options.delete(:limit))
      if limit
        title = truncate_with_hint(title, :length => limit)
      else
        title = h(title)
      end

      if options.delete(:use_both)
        titles = [user.display_name.strip, (user.login || '').strip].map {|x| limit ? truncate_with_hint(x, :length => limit) : x}
        titles.reverse! if options.delete(:reversed)
        title = (titles[0] != titles[1] ? ("%s (%s)" % titles) : titles[0]) 
      end
      title += options[:suffix] if options[:suffix]
    end
    options.delete(:suffix)

    caption = title
    if icon = options.delete(:icon)
      unless icon.is_a?(String)
        icon = user_icon_filename(user, icon)
      end
      icons = image_tag(icon, :class => 'userlink_icon')
      if options.delete(:extra_icon)
        icons << '&nbsp;' + image_tag('f_logo.jpg', :size => "10x10", :class => 'userlink_icon') if user.facebook_connected?
      end
      caption = icons + '&nbsp;' + caption
      caption = "<span class=\"user_name #{options.delete(:class)}\">" + caption + '</span>'
    end

    options[:no_link] = true if user.is_a?(User) && user.anonymous?
    if options.delete(:no_link)
      return caption
    end

    if user.is_a?(User) && user.kd_user?
      return link_to(caption, "#{@@facebook_profile_url}#{user.facebook_id}", :target => '_blank')
    end

    if options[:activity_id] && !options.delete(:public_context)
      link_to( caption,
        {:controller => 'activity', :action => 'read_and_frwd', :id => options[:activity_id], :type => options[:frwrd_type], :locale => options[:locale]},
        options.delete_if{|key, value| key == :activity_id || key == :frwrd_type})
    else
      url_options = {:locale => options.delete(:locale)}.reverse_merge(options.delete(:url_options) || {})
      link_to(caption, user_path_options(user, url_options), options)
    end
  end

  def user_icon_filename(user, kind = true)
    suffix = "_#{kind}" unless kind == true
    return 'kd_16.png' if user.facebook_user? && user.kd_user?
    return "kruser_bsc#{suffix}.png" if (user.basic_user? || user.anonymous?)
    return "folder#{suffix}.gif" if user.collection?
    return "project#{suffix}.png" if user.project?
    "kruser#{suffix}.png"
  end
  
  def wizard_link(user, options)
    action = if user.project?
      'basic_info_project'
    elsif user.basic_user?
      'for_basic_user'
    else
      'add_avatar'
    end
    user_link(user, options.reverse_merge(:url_options => {
            :controller => 'wizard',
            :action => action,
    }))
  end
  
  def user_name(user, options = {})
    user_link(user, options.merge(:no_link => true, :use_display_name => true))
  end

  def content_link(item, options ={}, url_options = {})
    return if item.nil?
    unless options[:title]
      options[:title] = item.title_long
      limit = options.delete(:length)
      options[:title] = truncate_with_hint(options[:title], :length => limit) if limit 
      options[:title] += "#{options.delete(:suffix)}"
    end

    if options.delete(:icon)
      options[:title] = "<span class=\"iconized #{icon_class(item)}\">" + options[:title] + '</span>'
    end
      
    suffix = options.delete(:userlink) ? " (#{user_link(item.user, :icon => true)})" : ''
    lnk = link_to(options.delete(:title), content_url(item, url_options), options)
    "#{lnk}#{suffix}"
  end
    
    
  # Helper that renders a link to a project's settings page
  #
  # essentially, a copypaste of user_link
  #
  def project_settings_link(user, options ={})
    return if user.nil?
    unless options[:title]
      options[:title] = options.delete(:detect_you) ? (user == current_actor ? "You".t : user.display_name) : user.login
      options[:title] = options.delete(:use_display_name) ? user.display_name : user.login
      options[:title] = options.delete(:use_both) ? "#{user.login} (#{user.display_name})" : options[:title]
      options[:title] += options[:suffix] if options[:suffix]
    end
    options.delete(:suffix)

    if options.delete(:icon)
      options[:title] = image_tag(user_icon_filename(user), :style => 'margin-right: 3px;') + options[:title]
      options[:title] = '<span style="white-space: nowrap;">' + options[:title] + '</span>'
    end

    if options[:activity_id]
      link_to( options.delete(:title),
        {:controller => 'activity', :action => 'read_and_frwd', :id => options[:activity_id], :type => options[:frwrd_type]},
        options.delete_if{|key, value| key == :activity_id || key == :frwrd_type})
    else
      # host = user_host(user.login.downcase)
      link_to(options.delete(:title), {:controller => 'preference', :action => 'show', :id => user}, options)
    end
  end

  def is_edit?
    return false if params[:new]
    !!controller.action_name.scan(/edit|create/).first || (@content && !@content.new_record?)
  end


  def tranny(translatable, method_name, options = {})
    render :partial => "/translation/tr_btn", :locals => {:translatable => translatable, :method_name => method_name , :options => options}
  end

  def tropen(index, mod_numb)
    return if index.nil? || mod_numb.nil?
    if index % mod_numb == 0
      '<tr>'
    end
  end

  def brclose(index, mod_numb, size)
    return if index.nil? || mod_numb.nil? || size.nil?

    if ((index - mod_numb).next) % mod_numb == 0
      '<br class="clear"/>'
    end
  end


  def trclose(index, mod_numb, size)
    return if index.nil? || mod_numb.nil? || size.nil?

    if ((index - mod_numb).next) % mod_numb == 0
      '</tr>'
      # + "-- #{index}-#{mod_numb.next}-#{mod_numb}-#{index - mod_numb.next}-#{(index - mod_numb.next) % mod_numb}"
    elsif index.next == size
      out = ''
      (mod_numb - (size % mod_numb)).times do
        out += '<td>&nbsp;</td>'
      end
      out += '</tr>'
      # + "-- #{index}-#{size}-#{mod_numb}-#{size % mod_numb}-#{mod_numb - (size % mod_numb)}"
      return out
    end
  end
    
  def in_development(can_view = true)
    if !RAILS_ENV["production"] && can_view # && !RAILS_ENV["rc"]
      yield
    end
  end
  
  def wonder_menu_url(id)
    (id == current_user.id) ? "#" : "#{request.request_uri}/user/switch?url=#{request.request_uri}"
  end
  
  def wonder_menu_class(id)
    (id == current_actor.id) ? %{class="selected"} : nil
  end

  def datetime(time, split = false)
    split ? time.to_s(:date_with_time_split) : time.to_s(:date_with_time)
  end

  def bundle_titles(bundles, options = {})
    return '' if !bundles
    if bundles.is_a?(Bundle)
      if options[:links]
        link_to bundle_titles(bundles), bundles.s3_url
      else
        bundles.size.blank? ? "#{bundles.filename}" : "#{bundles.filename} (#{number_to_human_size(bundles.size)})"
      end
    elsif bundles.is_a?(Array)
      str = "<strong>#{'Items available to download'.t}:</strong>"
      str << '<ul>'
      if bundles.empty?
        str << "<li><em>#{'No attached files'.t}</em></li>"
      else
        bundles.each do |bundle|
          if bundle.is_a?(Bundle)
            str << (options[:links] ? "<li style=\"font-weight: bold; padding-bottom:4px; list-style-type:none; \">#{bundle_links(bundle)}</li>" : "<li>#{bundle_titles(bundle)}</li>")
          end
        end
      end
      str << '</ul>'
    end
  end

  # Return a link, or a <ul> of links, given bundle items (attached to FolderWithDownloadables).
  def bundle_links(bundles)
    bundle_titles(bundles, :links => true)
  end
  
  # Return Upload Track, Upload Image, etc. links based on what content the given inbox is allowed to add
  def inbox_post_opts(inbox, opts = {})
    return '' if inbox.nil? || !inbox.is_a?(Inbox) || (inbox.archived? && opts[:link])
    
    add_opts = [
      ['image', 'Image'.t, 'upload_image'],
      ['track', 'Track'.t, 'upload_music'],
      ['video', 'Video'.t, 'video'],
      ['writing', 'Writing'.t, 'writing']
    ]
    
    links = []
    add_opts.each do |item, label, action|
      if inbox.send("#{item}s?")
        if opts[:link]
          links << link_to(label, {:controller => 'submit', :action => action, :user_id => current_actor.id, :for_inbox => inbox.id}, {:class => "iconized i_#{item}"})
        else
          if opts[:no_icon]
            links << item.capitalize.pluralize.t
          else
            links << %Q{<span class="iconized i_#{item}">#{item.capitalize.pluralize.t}</span>}
          end
        end
      end
    end
    
    if links.size == 1 && !opts[:link] && !opts[:no_icon]
      ("Only %s" / [links.first])
    elsif opts[:no_icon]
      links.join(', ')
    else
      links.join('')
    end
  end

  
  def submitted_to_inboxes(content)
    inboxes = content.inboxes.reject {|inbox| inbox.user_id == content.user_id}
    return '' if inboxes.blank?
    
    boxes = inboxes.collect{|inbox| "#{content_link(inbox)} (#{user_link(inbox.user, :icon => true)})"}
    
    "#{'Submitted to:'.t} &nbsp; &nbsp; #{boxes.join(', &nbsp;&nbsp; ')}"
  end
  
  def reqmark
    ' <span class="required">*</span>'
  end
  
  # To render HTML in an RSS feed context - http://stackoverflow.com/questions/339130/how-do-i-render-a-partial-of-a-different-format-in-rails
  def with_format(format, &block)
    old_format = @template_format
    @template_format = format
    result = block.call
    @template_format = old_format
    return result
  end

  def track_displayname
    if params[:for_album].blank?
      'Content Track'.t
    else
      # 'Folder Track'.t
      # 'Music Album Track'.t
      ('%s Track' % Content.find(params[:for_album]).entity_name_for_human.titleize).t
    end
  end
  
  MAGIC_WIDTH = 490
  def thumb_dim(entry, thumb_kind, dim_kind)
    size = entry.thumb(thumb_kind).send(dim_kind)
    if size
      if thumb_kind == :preview && dim_kind == :width && size > MAGIC_WIDTH
        size = MAGIC_WIDTH
      end
      if thumb_kind == :preview && dim_kind == :height && entry.thumb(:preview).send(:width) > MAGIC_WIDTH
        ratio = MAGIC_WIDTH.to_f / entry.thumb(:preview).send(:width).to_f
        size = (ratio * size).to_i
      end
      return size.to_i
    end
    predef = {:big => [300, 300]}
    dim_index = {:height => 0, :width => 1}[dim_kind]
    (predef[thumb_kind] || {})[dim_index] || 150
  end

  # For facebook
  def tab_selected?(c, a=nil)
    (c == params[:controller]) && (a.nil? ? true : a == params[:action])
  end

  def fbimage_tag(p) # all paths must be absolute
    image_tag p
  end

  def gallery_content_title_link(content, url = nil, options = {})
    truncate_to = options.delete(:truncate_to) || 16
    url = url_for(url) if url.is_a?(Hash)
    url ||= content_url(content)
    (url = url + (url.include?("?") ? "&from_related=1" : "?from_related=1") ) if (options.delete(:from_related) && !url.include?("from_related") )
    link_to kf_title(content.title_short(truncate_to)), url, {:title => h(content.title)}.merge(options) 
  end

  def local_referer
    result = request.env['HTTP_REFERER']
    unless result && result[user_domain]
      result = '/explore'
    end
    result
  end

  def kroogi_tos_link(title)
    link_to title, {:host => user_domain, :controller => '/home', :action => 'policy'}, :target => '_blank'
  end

  def kroogi_tos_link_attributes
    link = kroogi_tos_link('no matter')
    link_attributes = link[2..link.index('>')-1]
    link_attributes
  end

  def ie_request?
    request.env['HTTP_USER_AGENT'] =~ /msie/i
  end

  def truncate_with_hint(value, *args)
    t = truncate(value, *args)
    t = h(t)
    #we always return span here because we want it to be titled anyway: sometimes (like in #3546) truncation needs to
    #be done on CSS level
    "<span title=\"#{h(value)}\">#{t}</span>"
  end


  def include_jquery_tabs(include_css = true)
    return '' if @jquery_tabs_js_included
    #{javascript_include_tag 'jquery.history_remote.pack'}
    result = %Q{
      #{javascript_include_tag 'jquery.tabs.pack'}
    }
    if include_css
      result += %Q{
        <link rel="stylesheet" href="/stylesheets/jquery.tabs.css" type="text/css" media="print, projection, screen" />
        <!--[if lte IE 7]>
        <link rel="stylesheet" href="/stylesheets/jquery.tabs-ie.css" type="text/css" media="projection, screen">
        <![endif]-->
      } #with Additional IE/Win specific style sheet (Conditional Comments)
    end
    @jquery_tabs_js_included = true
    result
  end

  def include_swf_loader
    return '' if @swfobject_included
    result = %Q{
      #{javascript_include_tag 'swfobject'}
    }
    @swfobject_included = true
    result
  end

  def ratings_count_caption(count)
    "{{count}} votes((for rating))" / count
  end

  def votes_count_caption(count)
    "{{count}} votes" / count
  end

  def escape_description?(content)
    return false if !content.user.escape_content_descriptions?
    true
  end

  def root_directories
    [['music-directory', 'Music'.t, 'music_sc.gif'], ['artdesign-directory', 'Art'.t, 'art_sc.gif'],
     ['photo-directory', 'Photos'.t, 'photo_sc.gif'], ['video-directory', 'Videos'.t, 'video_sc.gif'],
     ['literature-directory', 'Writing ((directory))'.t, 'writing_sc.gif'], ['other-directory', 'More'.t, 'other_sc.gif']]
  end

  def invite_more_path_options(user, type)
    {:controller => '/invite', :action => 'find', :id => user, :circle_id => type}
  end

  def iconized_class(klass)
    'iconized ' + icon_class(klass.name)
  end

  def all_post_options(user_id, for_album = nil)
    {
      :music_album => link_to('Music Album'.t, {:controller => 'submit', :action => 'music_album', :user_id => user_id, :for_album => for_album}, {:class => iconized_class(MusicAlbum)}),
	  :track => link_to('Track'.t, {:controller => 'submit', :action => 'upload_music', :user_id => user_id, :for_album => for_album}, {:class => iconized_class(Track)}),
	  :video => link_to('Video'.t, {:controller => 'submit', :action => 'video', :user_id => user_id, :for_album => for_album}, {:class => iconized_class(Video)}),
	  :image => link_to('Picture'.t, {:controller => 'submit', :action => 'upload_image', :user_id => user_id, :for_album => for_album}, {:class => iconized_class(Image)}),
      :writing => link_to('Writing'.t, {:controller => 'submit', :action => 'writing', :user_id => user_id, :for_album => for_album}, {:class => iconized_class(Textentry)}),
      :folder => link_to('Folder'.t, {:controller => 'submit', :action => 'album', :user_id => user_id, :for_album => for_album}, {:class => iconized_class(Album)}),
      :project => link_to('Add User or Project'.t, {:controller => 'submit', :action => :project, :user_id => user_id, :for_album => for_album}, {:class => iconized_class(Project), :title => 'Add User or Project'.t}),
      :multiple_tracks => link_to('Multiple Tracks'.t, "javascript:void(0)", {:class => iconized_class(Track), :onclick => "showMultipleTracksUploader();"}),
      :multiple_images => link_to('Multiple Pictures'.t, "javascript:void(0)", {:class => iconized_class(Image), :onclick => "showMultipleImagesUploader();"}),
    }
  end


  def uploader_all_post_options(user_id, for_album = nil)
    {
      :track => link_to('basic uploader'.t, {:controller => 'submit', :action => 'upload_music', :user_id => user_id, :for_album => for_album}, {:class => iconized_class(Track)}),
      :image => link_to('basic uploader'.t, {:controller => 'submit', :action => 'upload_image', :user_id => user_id, :for_album => for_album}, {:class => iconized_class(Image)}),
    }
  end

   def fb_connect_logout_link(text,url, opts = {}, *args)
     function= "FB.logout(function() {window.location.href = '#{url}';})"
    if opts.delete(:reload)
      function= "FB.logout(function() {document.location.reload(false);})"
    end
    link_to_function text, function, *args
  end

   def current_fb_linked_user
     return nil unless current_fb_connected_user
     Facebook::UserDetails.active.find_connected_user(current_fb_connected_user.id, {:is_fb_connected => 1})
   end

   def current_fb_linked_user?
     return nil unless current_fb_connected_user
     current_fb_linked_user
   end

     def smart_truncate(s, opts = {})
       opts = {:words => 12}.merge(opts)
       if opts[:sentences]
         return s.split(/\./)[0, opts[:sentences]].map{|s| s.strip}.join('. ') + '.'
       end
       
       if opts[:letters]
         size =0
           s.split().reject do |token|
           size+=token.size()
           size>opts[:letters]
         end.join(" ")+(s.size()>opts[:letters]? " " + "..." : "" )
        return
       end
       
       a = s.split(/\s/) # or /[ ]+/ to only split on spaces
       n = opts[:words]
       a[0...n].join(' ') + (a.size > n ? '...' : '')
     end

  def uniq_content_for(name, content = nil, &block)
    ivar = "@content_for_#{name}"
    content = capture(&block) if block_given?
    block_content = instance_variable_get(ivar) || ""
    unless block_content.include?(content)
      instance_variable_set(ivar, "#{block_content}#{content}")
    end
    nil
  end

  def javascript_email_for(email, options = {})
    email_parts = email.split('@')
    bold = options.delete(:bold) || false
    id = "email_#{rand(1000)}"

    content_tag(:span, "", :id => id, :class => "#{'bold' if bold}") +
    javascript_tag("
      jQuery(document).ready(function() {
        jQuery('##{id}').html('<a href=\"mailto:' + '#{email_parts.first}' + '@' + '#{email_parts.last}' + '\">' +
                             '#{email_parts.first}' + '@' + '#{email_parts.last}' + '</a>');
      });
    ") + "<NOSCRIPT>(#{'Please enable JavaScript to see the e-mail address'.t})</NOSCRIPT>"
  end

  def kroogi_narrow_bluetabs(user)
    links = []
    links << maybe_selected_user_link((user.collection? ? 'Directory'.t : 'Home'.t), user, {:controller => '/user', :action => 'index'})

    if user.collection?
      links << maybe_selected_user_link('Visitors Center'.t, user, {:controller => "/user",:action => 'about'})
    end

    if user.project? && should_see_founders_link?(user)
      links << (should_see_founders_link?(user, :me_only_icon => true) ? me_only_icon : "") +
               maybe_selected_user_link('Hosts'.t, user, {:controller => "/user", :action => 'founders'})
    end

    unless user.collection? || user.basic_user?
      links << maybe_selected_user_link('Content'.t, user, {:controller => "/user", :action => 'gallery'})
      if user.livejournal_account
        links << maybe_selected_user_link('LJ'.t, user, {:controller => '/blog', :action => 'index'})
      end
    end

    if user.basic_user? && folder = user.folder_for_pictures_from_notes
      links << maybe_selected_user_link('Pics ((from Notes))'.t, user, {:controller => '/content', :action => 'show', :id => folder})
    end

    if user.questions_enabled?
      if current_user.is_self_or_owner?(user) || !PublicQuestion.with_user(user).published_and_archived.empty?
        links << maybe_selected_user_link(h('Forum'.t), user, {:controller => '/public_question', :action => 'index'})
      end
    end

    links << maybe_selected_user_link('Followers'.t + " (#{user.followers_count_sum.to_i})", user, {:controller => '/kroogi', :action => 'show'})
    links.join('<span class="separator">&nbsp;</span>')
  end

  def top_nav_select_home_box
    truncate_to = 20
    unless current_user.projects.blank?
      my_name = "#{truncate(current_user.display_name, :length => truncate_to)}#{' - Admin' if current_user.admin?}"
      items = [[my_name, current_user.id]]
      items += current_user.projects(:sorted => true).map(&:for_projects_select).map {|name, id| [truncate(name, :length => truncate_to), id]}
    
      content_tag(:span, select_tag(
          :projects, 
          options_for_select(items, current_actor.id),
          :onchange => "document.location.href='#{url_for(:controller => '/user', :action => 'switch')}/' + this.value + '?url=#{sanitize(current_uri) }';"),
          :class => "persona")
    end
  end

  def top_nav_user_link
    params = maybe_selected_class(:controller => "user", :action => "index") ? {:no_link => true, :class => "selected"} : {}
    user_link(current_user, {:icon => true}.merge(params))
  end

  def top_nav_messages_link
    anchor = image_tag('mail_icon.gif')
    mcount = current_actor.unread_message_count
    anchor += content_tag(:span, content_tag(:b, " (#{mcount})")) unless mcount.zero?
    content_tag(:span, maybe_selected_top_nav_link(anchor, {:controller => '/activity', :host => user_host(current_actor.login), :action => 'list'}))
  end

  def maybe_selected_top_nav_link(caption, options = {})
    url = options.delete(:url)
    klass = maybe_selected_class(options)
    if klass
      '<span class="%s">%s</span>' % [klass, caption]
    else
      link_to caption, url || url_for(options)
    end
  end

  def include_vkontakte_api
    html = ""
    html << javascript_include_tag("http://vkontakte.ru/js/api/share.js?9", :charset => "windows-1251")
    html << javascript_include_tag("http://vkontakte.ru/js/api/openapi.js", :charset => "windows-1251")
    html
  end

  def vkontakte_sharing(entry, content_title, artist_name)
    title = "{{title}} by {{artist}}" / ["\"#{content_title.gsub("'", "`")}\"", artist_name.gsub("'", "`")]
    javascript_tag("document.write(VK.Share.button(
      {
        url: '#{share_url(entry)}',
        title: '#{title}',
        description: '#{meta_description}',
        image: '#{entry.cover_art_url}',
        noparse: true
      },
      {
        type: 'custom',
        text: '#{
          content_tag(:div, image_tag('icon_vk.png'), :class => "sharing_icon vk")}'
      }
    ))")
  end

  def vkontakte_like_js(entry, title)
    unless vk_api_id.blank?
      title = title.gsub("'", "`")
      content_tag(:div, "", :id => "vk_like") +
      javascript_tag("
        jQuery(document).ready(function(){
          VK.init({apiId: #{vk_api_id}, onlyWidgets: true});
          VK.Widgets.Like('vk_like', {width: 100, type: 'button', pageTitle: '#{title}', 
                          pageDescription: '#{meta_description}', pageUrl: '#{share_url(entry)}'}, #{entry.id});
        })
      ")
    end
  end

  def mailru_like_js(entry, content_title, artist_name)
    href = {
      :url => "#{share_url(entry)} by #{artist_name}",
      :title => content_title,
      :description => meta_description,
      :imageurl => entry.cover_art_url
    }
    link_to("Нравится", "http://connect.mail.ru/share?#{href.map {|k,v| "#{k}=#{CGI::escape(v)}"}.join("&amp;")}", :target => "_blank", :"data-mrc-config" => "{'type' : 'button', 'width' : '150'}", :class => "mrc__plugin_like_button") + 
    javascript_include_tag("http://cdn.connect.mail.ru/js/loader.js", :charset => "UTF-8")
  end

  def odkl_like_js(entry)
    content_for(:js) {javascript_include_tag("http://stg.odnoklassniki.ru/share/odkl_share.js")}
    content_for(:css) {stylesheet_link_tag("http://stg.odnoklassniki.ru/share/odkl_share.css")}

    link_to("Класс!", share_url(entry), :class => "odkl-klass", :onclick => "ODKL.Share(this);return false;")
  end

  def meta_description
    @meta_description.blank? ? "Showcase your talent, explore music and art, find and show support, get rewarded for doing what you love. Kroogi is home to those who create. Welcome!" : h(@meta_description.gsub("'", "`"))
  end

  def vk_api_id
    # Production .com domain 2046120
    # Production .ru domain 2046956
    # RC (brainmaggot.net) 2046955
    # Staging (brainmaggot.org) 2046951
    # localy (kroogi.al) 2046981
    unless APP_CONFIG.vk_api_id.blank?
      subdomain = user_subdomain
      domain = subdomain.blank? ? request.host : request.host.gsub("#{subdomain}.", "")
      domain = domain.gsub("www.", "")
      APP_CONFIG.vk_api_id[domain]
    end
  end

  def open_multiple_uploader_onload(entry, params)
    type = params[:type]
    if params && params[:method] == "uploader"
      if !type.blank? && ['tracks', 'images'].include?(type) && entry.multiple_uploader_needed?(type.to_sym)
        javascript_tag("jQuery(document).ready(function() { showMultiple#{type.titleize}Uploader(); })")
      end
    end
  end

  def file_field(object_name, method, options = {})
    html = ""
    options[:autocomplete] = "off"
    options[:class] ||= "file_field_input"
    id = "#{object_name.to_s.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")}_#{method.to_s.sub(/\?$/,"")}"
    html << text_field_tag("#{id}_field", "", {:readonly => true}.merge(options))
    html << wrap_file_field(ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object)).
        to_input_field_tag("file", options.update({:size => nil})), id)
    html << javascript_for_file_field(id)
    html
  end

  def file_field_tag(name, options = {})
    html = ""
    options[:autocomplete] = "off"
    options[:class] ||= "file_field_input"
    id = sanitize_to_id(name)
    html << text_field_tag("#{id}_field", "", {:readonly => true}.merge(options))
    html << wrap_file_field(text_field_tag(name, nil, options.update("type" => "file")), id)
    html << javascript_for_file_field(id)
    html
  end

  def javascript_for_file_field(id)
    javascript_tag("
      jQuery(document).ready(function() {
        jQuery('##{id}').change(function() {
          var file_name = jQuery('##{id}').val();
          var position = file_name.lastIndexOf('\\\\');
          if (position == -1) position = file_name.lastIndexOf('\\/');
          var file_name = file_name.substring(position + 1, file_name.length);
          jQuery('##{id}_field').val(file_name)
        })
      })")
  end

  def wrap_file_field(tag, id)
    content_tag(:div,
      content_tag(:button,
        content_tag(:span, "&nbsp;#{'Select File'.t}&nbsp;"),
        :type => "button", :class => "button", :id => "#{id}_button") +
        content_tag(:div, tag, :class => "button_contaner"),
      :class => "select_file_button_wrapper")
  end

  def prepare_title(str)
    h(str).gsub("&amp;", "&").gsub("&quot;", "\"")
  end

  def set_ownership_other
    javascript_tag("function setOwnershipOther() {jQuery('#ownership_other').trigger('click');}")
  end

  def wait_up_homie(options = {})
    class_name = options.delete(:class) || 'wait_up_homie'
    valign = options.delete(:valign) || 'middle'
    id = options.delete(:id)
    display = options.delete(:display) || false
    class_name = nil unless id.blank?

    content_tag(:span,
      image_tag("/images/ajax-loader.gif", :alt => "spinner"),
      :class => class_name, :id => id, :style => "#{'display:none;' unless display} vertical-align: #{valign};")
  end

  def form_border(options = {})
    subhead_title = options.delete(:subhead_title) || nil
    content_extra_class = options.delete(:content_extra_class) || ''

    concat(content_tag('div', subhead_title, :class => 'main_body_subhead')) if subhead_title
    concat(content_tag('div', image_tag('form_top.gif')))
    concat("<div class='form_side_sdw'>")
      concat("<div class='form_content #{content_extra_class}'>")
        yield
      concat("</div>")
    concat("</div>")
    concat(content_tag('div', image_tag('form_btm.gif'), :class => 'shadow'))
  end

=begin
  <%#column_content starts here %>
  <div id=""><%# will be different id (most of them we have already), not always %>
    <%# header starts here %>
      <div class="headers_left"></div>
      <div class="headers_body">
        <div class="headers_content">
          <div class="headers_title">
            <%# header content - title %>
          </div>
        </div>
      </div>
      <div class="headers_right"></div>
      <%# header ends here %>
    <%# body starts %>
    <div class="main_container" id="">
    <%# could be different id, not always %>
      <%# content %>
    </div>
    <%# body ends here %>
  </div>
  <%#column_content ends here %>
=end

  def right_column_block(options = {})
    title = options.delete(:header_title) || ''
    white_top = options.delete(:white_top) || false
    body_content = options.delete(:body_content) || nil

    content_for :right_column do
      concat(header_title(title))
      concat("<div class='main_container'>")
        if body_content
          concat(body_content)
        else
          yield
        end
      concat("</div>")
    end
  end

  def wizard_right_column
    link_title = "<button class='button' style='float:right; margin:3px auto 10px;'><span>#{'Edit Settings'.t}</span></button>"
    body_content = content_tag('div', 'Click here to fully customize your profile settings. You can come back to this simplified setup guide at any time by choosing one of the options in the “Setup Guide” field to the right of the Edit Settings section.'.t, :class => 'default') +
                   link_to(link_title, {:controller => 'preference', :action => 'show', :id => @user.id})

    right_column_block(:header_title => 'Edit Settings'.t, :body_content => body_content)
  end

  def main_block(options = {})
    title = options.delete(:header_title) || ''
    left_block = options.delete(:left_block) || nil
    tab_container = options.delete(:tab_container) || nil
    content_head = options.delete(:content_head) || nil

    content_head = '&nbsp;' if !content_head.nil? && content_head.empty?

    concat(header_title(title))
    concat("<div class='main_container content_body'>")
      if content_head
        concat("<div class='content_head'>")
          concat(content_head)
        concat("</div>")
      end
      concat("<div id='#{tab_container}'>") if tab_container
        unless left_block.blank?
          concat("<div class='main_left'>")
            concat(left_block) 
          concat("</div>")
        end
        concat("<div class='main_body'>") unless left_block.blank?
          yield
        concat("</div>") unless left_block.blank?
      concat("</div>") if tab_container
    concat("</div>")
  end

  def wizard_main_block(breadcrumb_title)
    main_block(:header_title => wizard_breadcrumbs(breadcrumb_title), :left_block => render(:partial => '/wizard/left_menu')) do
      yield
    end
  end

  def preference_main_block(header_title, content_head = nil)
    left_block = render(:partial => 'shared/project_selector', :locals => {:projects_info => @projects_info, :user => @user})
    main_block(:header_title => header_title, :left_block => left_block, :content_head => content_head) do
      yield
    end
  end

  def header_title(title)
    res = ""
    unless title.blank?
      res = content_tag('div', '', :class => 'headers_left') + 
            content_tag('div',
              content_tag('div',
                content_tag('div', title, :class => 'headers_title'),
              :class => 'header_content'),
            :class => 'headers_body') + 
            content_tag('div', '', :class => 'headers_right')
    end
    res
  end

  def another_locale
    I18n.locale == 'en' ? 'ru' : 'en'
  end

  def start_following_when_i_follow(user, i_follow_relationship)
    res = ""
    invitation_request = current_actor.last_pending_invitation_request_to(user)
    user_icon = user_link(user, :icon => true)

    if current_actor.is_child?(user)
      res << "{{user_name}} is a host of {{project_name}}" / [user_icon, user_link(current_actor, :icon => true)]
    else
      if i_follow_relationship
        circle_icon = circle_link(user, i_follow_relationship)
        unless current_actor.project?
          res << 'You are in <b>{{circle_name}}</b> circle of {{someone}}' / [circle_icon, user_icon]
        else
          res << "{{project}} is in <b>{{circle_name}}</b> circle of {{someone}}" / [user_icon, circle_icon, user_icon]
        end
      else
        unless current_actor.project?
          res << "You are not in any circles of {{someone}}" / user_icon
        else
          res << "{{project}} is not in any circles of {{someone}}" / [user_link(current_actor, :icon => true), user_icon]
        end
      end
      if invitation_request
        res << ", asked to be in <b>{{circle_name}}</b>" / requested_circle_link(user, invitation_request)
      end
    end
    res
  end

  def start_following_when_im_followed(user, im_followed_relationship)
    res = ""
    user_icon = user_link(user, :icon => true)
    invitation = current_actor.last_pending_invitation_of(user)

    if im_followed_relationship
      circle_icon = circle_link(current_actor, im_followed_relationship)
      unless current_actor.project?
        res << "{{someone}} is in your <b>{{circle_name}}</b> circle" / [user_icon, circle_icon]
      else
        res << "{{someone}} is in <b>{{circle_name}}</b> circle of {{project}}" / [user_icon, circle_icon, user_link(current_actor, :icon => true)]
      end
    else
      unless current_actor.project?
        res << "{{someone}} is not in any of your circles" / user_icon
      else
        res << "{{someone}} is not in any of the circles of {{project}}" / [user_icon, user_link(current_actor, :icon => true)]
      end
    end
    if invitation
      res << ", invited to <b>{{circle_name}}</b>" / invited_circle_link(current_actor, invitation)
    end
    res
  end
  
  def leave_private_message(user)
    res = ""
    if permitted?(user, :contact) && current_user.is_self_or_owner?(user) == false
      res << me_only_icon
      res << link_to('Send message'.t, user_path_options(user, {:controller => '/activity', :action => 'dialogue',
                  :with => current_actor.id, :show_form => true}))
    end
    res
  end

  def add_content_dropdown(user)
    unless user.collection? || user.basic_user?
      concat(link_to("<span>#{'Add Content'.t}</span>", '#', {:class => 'button dropdown', :rel=>"dropmenu1_e"}))
      if current_user.is_self_or_owner?(user)
        list = [MusicAlbum, Track, Video, Image, Textentry, Album]
        list << MusicContest if current_actor.is_a?(Project)
        list << Tps::Content if current_actor.tps_setup_enabled?
        info_list = list.map { |type| info = content_type_info(type); [info[:submit_action], info[:post_tool_caption], info[:icon_filename]] }

        concat("<div class='dropmenudiv_e' id='dropmenu1_e'>")
          info_list.each do |action, caption, icon_filename|
            concat(link_to(image_tag(icon_filename) + caption,
                        {:controller => 'submit', :action => action,
                         :host => user_host(current_actor.login), :user_id => current_actor},
                         :class => "keep_together", :id => "#{action}_link"))
          end

          concat(render(:partial => '/layouts/shared/select_album_for_multiuploads'))
          concat(javascript_include_tag('dropdowntabs.js') + javascript_tag("tabdropdown.init('moonmenu', 3);"))
        concat("</div>")
      end
    end
  end

  def invite_closer_button(user)
    if permitted?(user, :can_invite_closer)
      link_to("<span>#{'Invite Closer'.t}</span>", {:controller => '/invite', :action => 'find', :id => current_actor, :invitee_id => user.id}, {:class => 'button'})
    end
  end

  def format_duration(duration)
    minutes, seconds = duration.divmod(60)
    if minutes < 60
      "#{minutes.to_s}:#{format('%02d', seconds.to_s)}"
    else
      hours, minutes = minutes.divmod(60)
      "#{hours.to_s}:#{format('%02d', minutes.to_s)}:#{format('%02d', seconds.to_s)}"
    end
  end

  def ajax_loader(id = nil)
    content_tag(:span, image_tag('ajax-loader.gif'), :class => "update_progress", :id => id, :style => 'display:none;')
  end
end
