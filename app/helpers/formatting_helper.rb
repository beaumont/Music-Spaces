=begin
++
Use this to format html text containing the kroogi markup tags
--
=end
module FormattingHelper  
  # formats normal text
  def formatted_text(html, options = {})
    return '' if html.blank?
    html = h(html) if options[:escape]
    sanitize(KroogiFormat.new(html))
  end

  def formatted_description(content, opts = {})
    result = formatted_text(content.description, :escape => escape_description?(content))
    if opts[:length]
      result = AutoExcerpt.new(result, :characters => opts[:length])
    end
    result
  end
  
  # excerpts text using lib/auto_excerpt
  def excerpted_text(html, opts = {})
    AutoExcerpt.new(formatted_text(html, opts), opts )
  end
  
  def formatting_help(message = nil)
    %{<span class="formatting_help"><a href="/home/help#markup" target="_blank">#{message || "How to format your post".t}</a></span>}
  end
  
  def utf2win1251 (incoming_string)
    # http://wiki.webmoney.ru/wiki/show/%D0%98%D0%BD%D1%82%D0%B5%D1%80%D1%84%D0%B5%D0%B9%D1%81+X1?q=%D0%BA%D0%BE%D0%B4%D0%B8%D1%80%D0%BE%D0%B2%D0%BA%D0%B0
    # this is the closest piece of info I could find on the issue
    out = ""
    secondpass = 0
    incoming_string.each_byte do |ascii|
      if ((ascii>>5 == 6) || (secondpass != 0))
        if secondpass == 0
          secondpass = ascii
          next
        else
        end      
        secondpass &= 31
        ascii &= 63
        ascii |= ((secondpass & 3) << 6)
        secondpass >>= 2
        word = (secondpass<<8) + ascii
        if (word==1025)
          out += 168.chr
        elsif (word==1105)
          out += 184.chr
        elsif (word>=1040 && word<=1103)
          out += ("%c" % (word-848))
        else
          a = secondpass.to_i
          b = ascii.to_i
          out += "&#x" + ("%02d" % a).to_s + ("%02d" % b).to_s + ";"
        end
        secondpass = 0
      else
        out += ("%c" % ascii)
      end
    end
       
    return out
  end
    
end