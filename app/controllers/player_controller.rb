class PlayerController < ApplicationController
  layout nil
  
  skip_before_filter :run_basic_auth, :login_from_cookie
  caches_action :embedded_play_list, :expires_in => 30.minutes, :cache_path => proc{|c| c.cache_key_with_locale_by_request_params}
  before_filter :correct_incorrectly_escaped_param_names, :only => :embedded_play_list
  before_filter :set_player_width
  skip_before_filter :choose_system_message

  def embedded_play_list
    params[:format] = 'xml'
    if params[:opts].is_a?(Hash)
      params[:opts] = Hash[(params[:opts] || {}).select {|key, value| %w(info_icon).include?(key.to_s)}] #we don't want to put just anything to XML
    end
    params[:only_public] = true
    vars = calc_playlist_vars_by_options(params)
    render(:text => '') and return if vars[:tracks].blank?
    vars[:escape_track_urls] = false
    if content = vars[:content]

    check_out_phrase = CGI::escape("Check out: {{content_title}}" / content.title)
    vars[:more_attribs] = {
              :kroogi_url => share_url(content), # dont pass the user here, it is appeneded in the SWF.
              :content_url => share_url(content),
              :year => content.year,
              :user => content.user.display_name,
              :title => content.title,
              :support_button => if content.is_a?(BasicFolderWithDownloadables) && content.downloadable?
                                      'Download This Album'.t
                                    elsif content.is_a?(Album)
                                      'See this Album at Kroogi'.t
                                    elsif content.is_a?(Track)
                                      'See this Track at Kroogi'.t
                                    end,
              :embed_label => 'Embed'.t,
              :tag_line_label => 'Meet the artists. Download. Contribute.'.t,
              :contribute_url => content_url(content, :contribute => true),
              :download_url => content_url(content, :download => true),
              :embed_id => "kroogi_player_#{content.id}",
              :facebook_share => facebook_share_url(content),
              :download_btn_label => "Download".t,
              :donate_btn_label => "Contribute".t,
              :thank_btn_label => "Thank".tup,
              :download_music_label => "You can download this music directly from Kroogi.".t,
              :thank_artist_label => "You can thank the artist by contributing any amount directly to him.".t,
              :share_label => "Share".t + ':',
              :text_copied_label => "Text Copied to Clipboard".t,
              :tweeter_share => "http://twitter.com/home?status=#{CGI::escape('Just found {{kroogi_content}}' / content_url(content))}",
              :vkontakte_share => "http://vkontakte.ru/share.php?url=#{CGI::escape(content_url(content))}",
              :digg_share => "http://digg.com/submit?url=#{CGI::escape(content_url(content))}" +
                      "&title=#{CGI::escape(check_out_phrase)}&bodytext=#{CGI::escape(check_out_phrase)}&topic=music",
              :play_counter_url => "http://#{APP_CONFIG.hostname}/content/played",
              :played_count_label => 'plays ((count))'.t,
      }

      vars[:more_attribs][:player_mode] = params[:player_mode] unless params[:player_mode].blank?

      ca = content.cover_art_url
      vars[:more_attribs][:thumb_url] = ca if ca
      
      referring_user = User.find_by_id(params[:ref_uid])
      if referring_user
        karma_point = KarmaPoint.create!(
          :content      => content,
          :referrer     => referring_user,
          :referral_url => request.referer,
          :action       => 'listen')
        session[:karma_point_id] = karma_point.id
      end
    end
    @vars = vars
  end
  
  def embed_player_dialog
    @vars = calc_playlist_vars_by_options(params)
  end

  private
  include PlayerHelper
  include ActionView::Helpers::TextHelper

  #due to some mess flash player hans us params prepended with '&amp;', and we need to strip them 
  def correct_incorrectly_escaped_param_names
    add = {}
    remove = []
    params.each do |key, value|
      if key.starts_with?("amp;")
        remove << key
        add.merge!(key[4..-1] => value)
      end
    end
    params.merge!(add)
    remove.each {|key| params.delete(key)}
    set_locale if add['locale']
  end

  def set_player_width
    @player_width = 406
  end
  
end
