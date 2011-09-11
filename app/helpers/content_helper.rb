module ContentHelper

  def track_length(seconds)
    seconds = 0 if seconds.nil?
    return (seconds.to_i/60).to_s + ':' + ("%02d" % (seconds % 60)).to_s
  end
  
  def dump(object)
    "<pre>" << object.to_yaml << "</pre>" 
  end
  
  def generic_modal_window(&block)
    raise "I need a block!" unless block_given?
  end

  def download_label 
    label = unless current_user.is_a?(Guest)
      "You can find the download link on your {{messages}} page, or click the link below" / link_to("Messages".tdown , :controller => 'activity', :action => 'messages')
    else
      'Click on the link below'.t
    end
    label + '.<br/>'
  end

  def download_bundle_path(bundle_id, options = {})
    expires = (Time.now + 30.minutes).to_i
    sig = download_signature(bundle_id, expires)
    url_for(options.merge(:controller => '/content', :action => 'download_bundle', :id => bundle_id, :expires=> expires, :sig => sig))
  end
  
  def content_type_info(klass, activity_type = nil)
    hash = {MusicAlbum => ['music_album', 'Music Album'.t, 'album.png'],
            Track => ['upload_music', 'Track'.t, 'sound.png'],
            Video => ['video', 'Video'.t, 'video.png'],
            Image => ['upload_image', '((add)) Picture'.t, 'image.png'],
            CoverArt => ['upload_image', nil],
            Textentry => ['writing', 'Writing'.t, 'text.png'],
            Album => ['album', '((add)) Folder'.t, 'folder.png'],
            Board => ['announcement', 'Announcement'.t],
            Blog => [nil, nil, 'livejournal.gif'],
            MusicContest => ['music_contest', 'Music Contest'.t],
            Tps::Content => ['fundbox', 'FundBox'.t],
    }

    activities_hash = {
            :published_usernote => ['usernote', 'Note'.t, 'writing_th.gif'],
    }

    info = activities_hash[activity_type] || hash[klass]
    info = hash[Album] if !info && klass.ancestors.include?(Album)
    info ||= hash[Textentry]
    submit_action, post_tool_caption, icon_filename = info
    icon_filename = submit_action + '_th.gif' if !icon_filename && submit_action
    result = {:submit_action => submit_action, :post_tool_caption => post_tool_caption, :icon_filename => icon_filename}
    result
  end

  #UI concept of editability
  def editable?(content)
    content.editable?
  end

  def can_be_submitted_to_inbox?(content)
    return false unless %w(Image Track Textentry Video).include?(content.class.name)
    return false if content.music_contest_item?
    return false if content.is_folder_for_pictures_from_notes?
    return permitted?(content.user, :content_edit, :content => content)
  end

  def contest_item_info(level)
    {-1 => ['All Tracks'.t], 0 => ['Entry ((contest item level))'.t],
     1 => ['Favorites ((contest item level))'.t, image_tag('icons/contest/favorite_item.gif')],
     2 => ['Short-list ((contest item level))'.t, image_tag('icons/contest/shortlist_item.gif')],
     3 => ['Final ((contest item level))'.t, image_tag('icons/contest/final_item.gif')]}[level]
  end
  
  def contest_item_level_name (level)
    contest_item_info(level)[0]
  end

  def contest_item_level_icon(level)
    contest_item_info(level)[1] || ''
  end

  def maybe_level_link(level, contest, options = {})
    options.reverse_merge!(:count => true)
    body = contest_item_level_name(level)
    level_link = (level == 0 ? -1 : level) #we don't have separate Entry filter at contest page     
    current = (level_link == options[:current])
    disabled = current
    if options[:count]
      count = contest.tracks_at_level(level_link).count
      body += " (#{count})"
      disabled = true if count == 0
    end
    body = content_link(contest, {:title => body}, params_without_paging(:keep_size => true).merge(:select_level => level_link)) unless disabled
    body = contest_item_level_icon(level_link) + ' ' + body
    "<span class=\"level_link #{'current' if current}\">" + body + '</span>'
  end

  def maybe_contest_sorting_link(kind, contest, caption, options = {})
    current = (params[:order] == kind)
    current = true if !params[:order] && kind == default_contest_tracks_order
    return caption if current
    content_link(contest, {:title => caption}, params.merge(:order => kind))
  end

  def ask_for_login_or_signon_before_downloading?
    !logged_in? && !created_user
  end

  def promote_contest_item_link(item)
    label = {0 => 'Promote to Favorites'.t, 1 => 'Promote to Short List'.t,
                2 => 'Make a Finalist'.t}[item.contest_submission.level]
    if label
      yield(label, {:controller => 'submit', :action => "promote_contest_item", :id => item},
       {:confirm => 'Once this track will be promoted to the next level of contest you will not be able to demote it. Click OK to promote the track.'.t,
       :style => "text-decoration:none", :method => :post})
    else
      ''
    end
  end

  def next_item_exist?(navigation)
    navigation[:position] < navigation[:size]
  end

  def in_successful_payment_handler?
    DonationProcessors.in_successful_payment_handler?(controller)
  end

  def after_signin_on_guest_zero_contrib?
    !flash[:signin_on_zero].blank? && flash[:signin_on_zero].to_i == @donation_dialog_number
  end

  def after_signup_on_guest_zero_contrib?
    !flash[:signup_on_zero].blank? && flash[:signup_on_zero].to_i == @donation_dialog_number    
  end

  def after_loggedin_zero_contrib?
    !flash[:zero_dl_by_loggedin].blank? && flash[:zero_dl_by_loggedin].to_i == @donation_dialog_number    
  end

  def show_download_links_widget?(content)
    content.downloadable? && (in_successful_payment_handler? || after_signin_on_guest_zero_contrib? || after_signup_on_guest_zero_contrib? || after_loggedin_zero_contrib?)
  end

  def return_to_content_page_link(hat)
    link_to 'Return to "{{content_title}}" page' / hat.title, content_url(hat)
  end

  def content_post_options(entry, post_options)
    return if entry.nil?
    links = all_post_options(entry.user_id, entry.id)

    post_options.map {|po|
      if [:track, :image].include?(po) && entry.multiple_uploader_needed?("#{po}s".to_sym)
        links["multiple_#{po}s".to_sym]
      else
        links[po]
      end
    }
  end
end
