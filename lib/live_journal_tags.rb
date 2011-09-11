# This module handles translation of livejournal specific tags
module LiveJournalTags
  include Globalize
  
  # class EntryWithoutAccountException < Exception ; end
  # class EntryWithoutBlogEntryException < Exception ; end
  
  ## Slightly modified extraction from http://svn.techno-weenie.net/projects/plugins/white_list/lib/white_list_helper.rb
  module WhiteList
    mattr_accessor :bad_tags, :tags, :attributes, :protocols
    @@protocol_attributes = Set.new %w(src href)
    @@protocol_separator  = /:|(&#0*58)|(&#x70)|(%|&#37;)3A/
    mattr_reader :protocol_attributes, :protocol_separator
    
    def self.contains_bad_protocols?(white_listed_protocols, value)
      value =~ protocol_separator && !white_listed_protocols.include?(value.split(protocol_separator).first)
    end
    
    def white_list(html, options = {}, &block)
      return html if html.blank? || !html.include?('<')
      options = {
        :attributes => @@attributes,
        :tags => @@tags
      }.merge(options)
      attrs   = (options[:attributes])
      tags    = (options[:tags]      )
      block ||= lambda { |node, bad| @@bad_tags.include?(bad) ? nil : node }
      returning [] do |new_text|
        tokenizer = HTML::Tokenizer.new(html)
        bad       = nil
        while token = tokenizer.next
          node = HTML::Node.parse(nil, 0, 0, token, false)
          new_text << case node
            when HTML::Tag
              node.attributes.keys.each do |attr_name|
                value = node.attributes[attr_name].to_s
                if !attrs.include?(attr_name) || (protocol_attributes.include?(attr_name) && contains_bad_protocols?(value))
                  node.attributes.delete(attr_name)
                else
                  node.attributes[attr_name] = CGI::escapeHTML(value)
                end
              end if node.attributes
              if tags.include?(node.name)
                bad = nil
                node
              else
                bad = node.name
                block.call node, bad
              end
            when HTML::Text
              if node.to_s =~ /^<!--.*?-->$/
                '' # We dont like comments being transposed, lets just remove them....
              else
                block.call node, bad
              end
            else
              block.call node, bad
          end
        end
      end.join
    end
    
    protected
      def contains_bad_protocols?(value)
        WhiteList.contains_bad_protocols?(protocols, value)
      end
  end

  
  class << self
        
    include WhiteList
    
    # Parses LiveJournal tags and replaces them with the proper HTML and
    # returns a hash with :full and :cut content
    # content_id is the blog id which we use for cuts
    def parse(entry, content_id)
      return '' unless entry.respond_to?(:event)
      # clean the html
      html = white_list(entry.event)
      
      # parse all standard lj tags first
      html = parse_lj_embed_tags(html,entry)
      html = parse_lj_user_tags(html)
      html = parse_lj_comm_tags(html)
      
      # create a cut version of the entry data
      cut = self.parse_lj_cut_tags(html.dup, content_id)

      # anchor the cuts in the main entry
      html = anchor_lj_cut_tags(html, content_id)

      # viola!
      {:cut => cut, :full => html}
    end
    
    protected
    
    # Chops content and creates links back to the /content/show/:content_id with anchor to the cut 
    def parse_lj_cut_tags(html, content_id)
      return '' if html.blank?
      siteurl = '/content/show/'
      tag_regex = /((<lj-cut( text=[\"\'](.*)[\"\'])?\/?>)(.*?)(<\/lj-cut>|\z))/im
      (html).scan(tag_regex).each_with_index do |x,i|
        text = x[1].match(/text=[\'\"](.*?)[\'\"]/im)
        text = text.nil? ? 'Read More...' : text[1]
        res  = "<b>(&nbsp;<a href=\"#{siteurl}#{content_id}#cut#{content_id}_#{i+1}\">#{text}</a>&nbsp;)</b>"
        html.gsub!(x[0].to_s, res)
      end
      html.gsub('</lj-cut>','')
    rescue RegexpError  # FIXME: regex too big error (again? sigh....)
      return html
    end
    
    # Replace cuts with anchors for main content reference
    def anchor_lj_cut_tags(html, content_id)
      return '' if html.blank?
      tag_regex = /((<(lj-cut).*?(text)?.*?>)(.*?)(<\/\3>)?).*?$/ism
      (html).scan(tag_regex).each_with_index do |x,i|
        res = "<a href=\"#cut#{content_id}_#{i+1}\"></a>#{x[4]}"
        html.gsub!(x[1], res)
      end
      html.gsub('</lj-cut>','')
    rescue RegexpError # FIXME: regex too big error (again? sigh....)
      return html
    end

    # Change <lj user="username"> tags to link to proper livejournal.com profile
    def parse_lj_user_tags(html)
      return '' if html.blank?
      tag_regex = /(<lj\ {1,}user\ {0,}=\ {0,}[\"\'](.+?)[\"\']\ {0,}?[\/]?>)/ism
      html.scan(tag_regex).each do |x|
        name = x[1]
        html.gsub!(x[0],
          "<a href=\"http://#{name}.livejournal.com/profile\" target=\"_blank\"><img src=\"/images/userinfo.gif\" border=\"0\" alt=\"[info]\" style=\"vertical-align:middle\"/></a><a href=\"http://#{name}.livejournal.com/\" target=\"_blank\"><b>#{name}</b></a>")
      end
      html
    end
  
    # Change <lj comm="group"> tags to link to proper livejournal.com group page
    def parse_lj_comm_tags(html)
      return '' if html.blank?
      tag_regex = /(<lj\ {1,}comm\ {0,}=\ {0,}[\"\'](.+?)[\"\']\ {0,}?[\/]?>)/is
      html.scan(tag_regex).each do |x|
        name = x[1]
        html.gsub!(x[0], 
          "<a href=\"http://community.livejournal.com/#{name}\" target=\"_blank\"><img src=\"/images/community.gif\" border=\"0\" alt=\"[info]\" style=\"vertical-align:middle\"/></a><a href=\"http://community.livejournal.com/#{name}\" target=\"_blank\"><b>#{name}</b></a>")
      end
      html
    end
    
    # Replaces <embed> tags with a link to the real livejournal content.
    def parse_lj_embed_tags(html, entry)
      # raise EntryWithoutAccountException if entry.account.blank?
      # raise EntryWithoutBlogEntryException if entry.blogentry.blank?
      return '' if html.blank?
      tag_regex =/(<lj-embed\ {1,}id\ {0,1}=\ {0,}[\"\'](.+?)[\"\']\ {0,}?[\/]?>)/ism
      html.scan(tag_regex).each do |x|
        id = x[1]
        url = "#{entry.account.url}#{entry.blogentry.filename}" rescue '#'
        str = "This post contains embedded media, click here to view.".t
        html.gsub!(x[0], "<a href=\"#{url}\">#{str}</a>")
      end
      html
    end
    
  end
end

# Tag parser whitelist configuration
LiveJournalTags::WhiteList.bad_tags   = %w(script)
LiveJournalTags::WhiteList.tags       = %w(lj-embed center embed object param lj lj-cut strong strike em b i p code pre tt output samp kbd var sub sup dfn cite big small address hr br div span h1 h2 h3 h4 h5 h6 ul ol li dt dd abbr acronym a img blockquote del ins fieldset legend)
LiveJournalTags::WhiteList.attributes = %w(user alt id text comm href target src width height alt type cite datetime title class border name value allowscriptaccess allowfullscreen)
LiveJournalTags::WhiteList.protocols  = %w(ed2k ftp http https irc mailto news gopher nntp telnet webcal xmpp callto feed)
