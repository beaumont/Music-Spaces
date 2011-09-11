=begin #(fold)
++
This script parses html and reformats <tt><kroogi ... /></tt> markup language
Author:: Kabari Hendrick (mailto:threedozen@gmail.com)
Copyright:: Copyright (c) 2008 Your Net Works inc.
Refactored by Stephane Arcos July 5 2010
- Splitted long rexep into multipart
- Added <kroogi-cut> tag support.
- Added ability to bypass (ignore) a tag.
--
=end

require_dependency File.join(RAILS_ROOT,"app","models","user")

class KroogiFormat < String
  attr_writer :linked_tracks
  attr_accessor :text_minus_html_count

  attr_reader :kroogicut_tag_matched
  alias :kroogicut_tag_matched? :kroogicut_tag_matched

  attr_accessor :nocut_tag_matched
  alias :nocut_tag_matched? :nocut_tag_matched

  # All HTML tags
  HTMLTAGS = /<(.|\n)+?>/

  #special <nocut> tag
  # when present orginal text will not be excerpt
  NOCUT_TAG = /.*<nocut>.*/
  
  # kroogi user type tag, form are :
  # <kroogi #{method_name}="#{user_id | user_name}"/>
  # or
  # <kroogi #{method_name}="#{user_id | user_name}"> content text, any size </kroogi>
  OPENING_TAG       = /(?:<kroogi\s+)/
  METHOD            = /([a-z]+)/               # ex: 'user'   stored in $1
  USER_ID_OR_NAME   = /\="([A-Za-z0-9\-\s]+)"/ # ex: 'kto-to' stored in $2
  END_SIMPLE_TAG    = /(?:\s?\/>)/                # ex />
  CLOSING_START_TAG = /(?:>{1})/               # ex >
  CONTENT           = /(.*)/                   # anything     stored in $3
  END_FULL_TAG      = /(?:>{1})(.+)<\/kroogi>/
  KROOGI_USER_FULL_REGEX = /#{OPENING_TAG}#{METHOD}#{USER_ID_OR_NAME}(?:#{END_SIMPLE_TAG}|#{END_FULL_TAG})/

  # kroogi-cut type tag, form are :
  # text before cut <kroogi-cut /> text after cut
  # or
  # my text <kroogi-cut text="I have more" /> more text more text more
  # or
  # text before cut <kroogi-cut> text after cut </kroogi-cut>
  # or
  # my text <kroogi-cut text="I have more"> more text more text more </kroogi-cut>
  KC_OPENING_TAG     = /(?:<kroogi-([a-z]*)+)/                      #ex: suffix method (ie: cut) in <kroogi-cut stored in $1
  KC_LINK_TEXT       = /(?:(?:\stext\=")(?:([а-яА-ЯёЁA-Za-z0-9\-\s\.]*)))*/ #ex: Read More ...text="Read More">.... stored in $2
  KC_CLOSING_TAG     = /"*>/
  KC_CL_SHORT_TAG    = /"*\s*\/>/
  KC_CONTENT         = /([^\^]*)/                                   # anything, including newlines     stored in $3
  KC_END_TAG         = /(?:<\/kroogi-cut>+)/

  # short version. ie: Without a closing tag
  KC_SHORT_REGEX    = /#{KC_OPENING_TAG}#{KC_LINK_TEXT}#{KC_CL_SHORT_TAG}#{KC_CONTENT}/

  # full version. ie: with a closing tag
  KC_FULL_REGEX      = /#{KC_OPENING_TAG}#{KC_LINK_TEXT}#{KC_CLOSING_TAG}#{KC_CONTENT}#{KC_END_TAG}/
  
  AUTO_LINK_RE = %r{
                  (                          # leading text
                    <\w+.*?>|                # leading HTML tag, or
                    [^=<>!:'"/]|             # leading punctuation, or
                    ^                        # beginning of line
                  )
                  (
                    (?:https?://)|           # protocol spec, or
                    (?:s?ftps?://)|
                    (?:www\.)                # www.*
                  )
                  (
                    (\S+?)                   # url
                    (\/)?                    # slash
                  )
                  ([^\w\=\/;\(\)]*?)               # post
                  (?=<|\s|$)
                 }x unless const_defined?(:AUTO_LINK_RE)

  def initialize(html, options = {}) #:nodoc:
    ignore = options.delete(:ignore)
    ignore = ignore.gsub('-','_') if ignore
    result = ""

    @bodywithout_html = html.dup.strip
    @bodywithout_html.gsub!(HTMLTAGS, "")
    @text_minus_html_count = @bodywithout_html.chars.length


    @linked_tracks = []
    
    if  html =~ NOCUT_TAG
      @nocut_tag_matched = true
    end
    
    if html =~ /#{KROOGI_USER_FULL_REGEX}/
      result = html.gsub!( /#{KROOGI_USER_FULL_REGEX}/ ) do | match |
        all = $&
        method, id = $~[1..2]
        content = $~[3]
        if method
          if respond_to? "format_#{method}"
            send("format_#{method}", id, content)
          else
            send("mark_content", method, id, content)
          end
        end
       end
    end
    if html =~ /#{KC_FULL_REGEX}/
      result = html.gsub!( /#{KC_FULL_REGEX}/ ) do | match |
        all = $&
        method = "kroogi_#{$~[1]}"
        id  = $~[2]
        content = $~[3].gsub(/(<\/kroogi-cut>)/, '')
        if method
          @kroogicut_tag_matched = true
          if respond_to? "format_#{method}"
           if method == ignore
            all
           else
            send("format_#{method}", id, content)
           end
          else
            send("mark_content", method, id, content)
          end
        end
      end
    end
    if html =~ /#{KC_SHORT_REGEX}/
      result = html.gsub!( /#{KC_SHORT_REGEX}/ ) do | match |
        all = $&
        method = "kroogi_#{$~[1]}"
        id  = $~[2]
        content = $~[3]
        if method
          @kroogicut_tag_matched = true 
          if respond_to? "format_#{method}"
           if method == ignore
            all
           else
            send("format_#{method}", id, content)
           end
          else
            send("mark_content", method, id, content)
          end
        end
      end
    end
    result = html

    inline_auto_link(result)
    result.gsub!("\n", "<br />")
    result.gsub!( /(.)\n(?!\Z| *([#*=]+(\s|$)|[{|]))/, "\\1<br />" )

    super(result)
  end
  
  def linked_track_list #:nodoc:
    @linked_tracks ||= {}
  end

  # Turns all urls into clickable links (code from Rails).
  def inline_auto_link(text)
    text.gsub!(AUTO_LINK_RE) do
      all, leading, proto, url, post = $&, $1, $2, $3, $6
      if leading =~ /<a\s/i || leading =~ /![<>=]?/
        # don't replace URL's that are already linked
        # and URL's prefixed with ! !> !< != (textile images)
        all
      else
        # Idea below : an URL with unbalanced parethesis and
        # ending by ')' is put into external parenthesis
        if ( url[-1]==?) and ((url.count("(") - url.count(")")) < 0 ) )
          url=url[0..-2] # discard closing parenth from url
          post = ")"+post # add closing parenth to post
        end
        %(#{leading}<a href="#{proto=="www."?"http://www.":proto}#{url}">#{proto + url}</a>#{post})
      end
    end
  end

  def have_flash_embeds?
    self['<object']
  end

=begin
  TODO refactor these rescue methods
=end

  protected
    
  def strip_paragraph!(text)
    if text[0..2] == "<p>" then text[0..2] = '' end
    if text[-4..-1] == "</p>" then text[-4..-1] = '' end
  end

  def format_kroogi_cut(text, content)
   text_link = text ? text : 'More...'.t
   "<a href='#' id='link#{content.object_id}' onclick='toggleDiv(#{content.object_id}, \"link#{content.object_id}\");return false'>#{text_link}</a><div id='#{content.object_id}' style='display:none'>#{content}</div>"
  end

  def format_user(name_or_id, content, blog = false)
    u = find_user(name_or_id)
    login = u.login
    %Q{<a href="http://#{login.downcase}.#{APP_CONFIG[:hostname]}#{blog ? '/blog' : ''}"><img src="#{u.project? ? '/images/project.png' : '/images/kruser.png'}" /> #{(content.nil? || content.empty?) ? login : content}</a>}
  rescue Exception => e
    ::RAILS_DEFAULT_LOGGER.warn "*****Kroogi Formatter"
    ::RAILS_DEFAULT_LOGGER.warn "searching for nil user #{name_or_id}" if u.nil?
    ::RAILS_DEFAULT_LOGGER.warn e.message
    %Q{ <a href="#" title="User no longer exists"><img src="/images/project.png" /> #{content || name_or_id}</a>}
  end
  
  # formats all generic content
  def mark_content(method, id, content)
    %Q{ <a href="http://#{content.author.login.downcase}.#{APP_CONFIG[:hostname]}/content/show/#{id}">#{content}</a> } if content && method.match(/track|announcement/)
  end
  
  def format_blog(name_or_id, pretext, content, tag)
    format_user name_or_id, content, true
  end
    
  def find_user(name_or_id)
    if name_or_id =~ /^\d+$/
      u = User.find_by_id(name_or_id)
    else
      u = User.find_by_login(name_or_id)
    end
    (u && u.active?) ? u : nil
  end
  
  def save_nil_content(nil_content, message) #:nodoc:
    ::RAILS_DEFAULT_LOGGER.warn "searching for nil content #{nil_content}" if u.nil?
    %Q{ <a href="#" title="Content no longer exists">#{message}</a>}    
  end

end