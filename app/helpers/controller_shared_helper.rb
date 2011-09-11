module ControllerSharedHelper

  def local_domain?(domain = request.domain)
    return true if APP_CONFIG.force_single_domain
    return false if domain.nil? #ip address
    domain.to_s.starts_with?('localhost') || domain.to_s.index('.local') != nil
  end

  def content_user_bound_url(content, options, id_hash = nil)
    options.reverse_merge!(:locale => I18n.locale)
    options = options.symbolize_keys
    id_hash = id_hash.symbolize_keys if id_hash

    content = Content.find(content) if content.is_a?(String) || content.is_a?(Numeric)
    raise "Content is expected here! got #{content.inspect}" unless content.is_a?(Content)

    unless id_hash
      content_id = content.to_verbose_param
      id_hash = {:id => content_id}
    end

    host = user_domain  #default
    if content
      user = content.me if content.is_a?(Pvtmessage)
      user ||= content.user
    end
    host = user_host(user.login) if user
    options = {:only_path => false}.merge(options).merge(id_hash).merge(:host => host.downcase)
    log.debug "options are #{options.inspect}"
    if options[:action] == 'show' && (!options[:controller] || options[:controller]['content'])
      options.reverse_merge!(:format => 'html')
      if options.delete(:force_downloadable) || content.downloadable?
        url_for(downloadable_content_path(options))
      else
        url_for(basic_content_path(options))
      end
    else
      url_for(options)
    end
  end
  
  # Doing this outside of config/routes, since the :host params needs access to the content param
  def content_url(c, url_options = {})
    url_options = url_options.symbolize_keys
    return comment_url(c, url_options) if c.is_a?(Comment)
    return public_question_url(c, url_options) if c.is_a?(PublicQuestion)
    return public_answer_url(c, url_options) if c.is_a?(PublicAnswer)
    return (c.tps_ticket? ? tps_goodies_url(c.content, url_options) : project_goodies_url(c.artist, url_options)) if c.is_a?(Tps::GoodieTicket)
    return url_for({:controller => 'goodies', :action => 'submit_info', :id => c.id}.merge(url_options)) if c.is_a?(Tps::ParticipantInfoRequest)
    content_user_bound_url(c, url_options.merge(:controller => '/content', :action => 'show'))
  end

  def comment_url(comment, url_options = {})
    if comment.commentable.is_a?(Profile) || comment.commentable.is_a?(UserKroog)
      {:controller => 'user', :action => 'thread', :id => comment.commentable.user_id,
        :thread_id => comment.top.id, :anchor => "comment_item_#{comment.id}"}.merge(url_options)
    else
      content = comment.commentable
      content_url(content, {:anchor => "comment_item_#{comment.id}"}.merge(url_options))
    end
  end

  def tps_goodies_url(content, url_options = {})
    url_for(url_options.merge(:host => user_host(content.user), :controller => '/tps', :action => 'goodies', :id => content.id))
  end

  def project_goodies_url(project, url_options = {})
    url_for(url_options.merge(:host => user_host(project), :controller => '/goodies'))
  end

  def public_question_url(question, url_options = {})
    url_for(url_options.merge(:host => user_host(question.user), :controller => '/public_question', :id => question.id))
  end

  def public_answer_url(answer, url_options = {})
    url_for(url_options.merge(:host => user_host(answer.question.user), :controller => '/public_question',
                              :id => answer.question.id, :show_comments => answer.id))
  end

  def user_path_options(login, options = {})
    login = login.login if login.is_a?(User)
    options[:locale] ||= I18n.locale #reverse_merge! is not enough here - locale comes as nil from above for some reason  

    # Switching away from subdomains.
    host = user_host(login.downcase)
    result = unless local_domain?(user_domain)
      unless options[:controller]
        action  = options.delete(:action)
        {:host => host, :only_path => false, :controller => "/#{action}"}.merge(options)
      else
        {:host => host, :only_path => false}.merge(options)
      end
    else
      options[:action] = 'index' if options[:action].blank?
      {:controller => '/user', :id => login.downcase}.merge(options)
    end
    result
  end

  def share_url(content)
    content_url(content)
  end

  def facebook_share_url(content)
    "http://www.facebook.com/sharer.php?u=#{CGI::escape(share_url(content))}"
  end
  
  include ControllerCachingMixin

  private
  include UserLocation
end