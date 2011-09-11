=begin #(fold)
++
Author:: Kabari Hendrick (mailto:threedozen@gmail.com)
Copyright:: Copyright 2008 Kabari Hendrick

AutoExcerpt
based on the rss_auto_excerpt plugin for Textpattern by the great Rob Sable
more info <http://www.wilshireone.com/textpattern-plugins/rss_auto_excerpt>

Creates Automatic excerpts of html formatted text.

Use like: <tt>AutoExcerpt.new("<span>This is <strong>some</strong> fancy html formatted text homie</span>", {:words => 5})</tt>

Redistribution and/or modification of this code is 
governed by the GPLv2.

--
=end #(end)

class String
  def clean # remove all double-spaces, tabs, and new lines from string
    strip.gsub(/\s{2,}|[\n\r\t]/, ' ')
  end
  
  def clean! # ditto, but replaces the original string
    replace(clean)
  end
end

class AutoExcerpt < String
  VERSION = '0.6'
  
  DEFAULTS = {
     :characters => 0,
     :words => 0,
     :sentences => 0, 
     :paragraphs => 0,
     :skip_length => 0,
     :skip_words => 0,
     :skip_sentences => 0,
     :skip_paragraphs => 0,
     :ending => '...',
     :strip_tags => false,
     :strip_breaks_tabs => false ,
     :strip_paras => false
  }
  
  HTMLTAGS = /<(.|\n)+?>/
  PUNCTUATION_MARKS = /\!\s|\.\s|\?\s/
  NO_CLOSE = %w( br hr img input ) # tags that do not have opposite closing tags

  attr_reader :charcount, :wordcount, :sencount, :pghcount
  attr_accessor :settings, :body, :excerpt
  
  def initialize(text, settings = {})
    @settings = DEFAULTS.merge(settings)
    
    # make our copy
    @body = text.dup.strip
    @excerpt = ""
    @body.gsub!(HTMLTAGS, "") if @settings[:strip_tags]
    @body.clean! if @settings[:strip_breaks_tabs]
    # TODO replace this with better regex
    @body.replace(@body.gsub(/<(\/|)p>/,'')) if @settings[:strip_paras]
    # @charcount = @body.gsub(HTMLTAGS, "").length
    @charcount = @body.chars.length
    @wordcount = @body.gsub(HTMLTAGS, "").scan(/\w+/).size
    @sencount  = @body.split(PUNCTUATION_MARKS).size
    @pghcount  = @body.split("</p>").size
    @settings[:characters] = 150 if @settings.values_at(:characters, :words, :sentences, :paragraphs).all?{|val| val.zero?  }
    
    create_excerpt
    super(@excerpt)
  end
      
  
  protected
  
 # close html tags
 # TODO complete broken html entities
  def close_tags(text)
    tagstoclose = ""
    tags = []
    opentags = text.scan( /<(([A-Z]|[a-z]).*?)(( )|(>))/is ).transpose[0] || []
    opentags.reverse!
    closedtags = text.scan(/<\/(([A-Z]|[a-z]).*?)(( )|(>))/is).transpose[0] || []
  
    opentags.each do |ot|
      if closedtags.include?(ot)
        closedtags.delete_at(closedtags.index(ot))
      else
        tags << ot
      end
    end
    
    tags.each do |tag|
      tagstoclose << "</#{tag.strip.downcase}>" unless NO_CLOSE.include?(tag)
    end
    
    text << (@settings[:ending] || "") + tagstoclose
    @excerpt = text
  end
    
  def create_excerpt #:nodoc:
    return characters unless @settings[:characters].zero?
    return words      unless @settings[:words].zero?
    return sentences  unless @settings[:sentences].zero?
    return paragraphs unless @settings[:paragraphs].zero?  
  end

  def non_excerpted_text
    @settings[:ending] = nil
    close_tags(@body)
  end
  
  # limit by characters
  def characters
    return non_excerpted_text if @charcount < @settings[:characters]
    text = @body.chars[@settings[:skip_length]...@settings[:characters]] 
    parts = text.split(" ")
    if parts.length > 1
      parts.pop
      text = parts.join(" ").chars
    end  
    parts = text.split("<")
    if parts.length > 1
      parts.pop if !parts.last.include?(">") 
      text = parts.join("<").chars
    end
    close_tags(text)
  end
  
  # limit by words
  def words
    return non_excerpted_text if @wordcount < @settings[:words]
     text = @body.split(" ").slice(@settings[:skip_words], @settings[:words]).join(" ")
     close_tags(text)
  end

  # limit by sentences
  def sentences
    return non_excerpted_text if @sencount < @settings[:sentences]
    text = @body.split(PUNCTUATION_MARKS).slice(@settings[:skip_sentences], @settings[:sentences]).join(". ")
    close_tags(text)
  end

  # limit by paragraphs
  def paragraphs
    return non_excerpted_text if @pghcount < @settings[:paragraphs]
    text = @body.split("</p>").slice(@settings[:skip_paragraphs], @settings[:paragraphs])
    text.last.replace(text.last.rstrip.concat(@settings.delete(:ending)))
    text = text.join("</p>")
    close_tags(text)
  end
end