class Browser
  ROBOTS = /b(Baidu|Gigabot|Googlebot|libwww-perl|lwp-trivial|msnbot|SiteUptime|Slurp|WordPress|ZIBB|ZyBorg)b/i
  def self.is_megatron?(request)
    request.user_agent =~ ROBOTS
  end
  
  # returns a hash with broswer type and version
  def self.browser_info(user_agent)
    browser = {
      :type => nil,
      :version => nil
    }
    #Internet Exlorer
    if user_agent =~ /MSIE/i && user_agent.scan(/AOL|America Online Browser/i).empty?
      browser[:type] = "MSIE";
      browser[:version] = user_agent.scan(/MSIE ([\d\.]+)/i).to_s
    #Firefox/Firebird/Phoenix
    elsif user_agent =~ /Firefox|Firebird|Phoenix/i
      browser[:type] = "Firefox";
      browser[:version] = user_agent.scan(/[Firefox|Firebird|Phoenix].\/(\d.+)/i).to_s
    #Galeon
    elsif user_agent =~ /Galeon/i
      browser[:type] = "Galeon";
      browser[:version] = user_agent.scan(/Galeon\/([\d\.]+)/i).to_s
    #Safari
    elsif user_agent =~ /Safari/i
      browser[:type] = "Safari";
      browser[:version] = user_agent.scan(/Version\/([\d\.]+)/i).to_s || nil
    #Opera
    elsif user_agent =~ /Opera/i
      browser[:type] = "Opera";
      browser[:version] = user_agent.scan(/Opera[ |\/]([\d\.]+)/i).to_s
    #AOL/America Online Browser
    elsif user_agent =~ /AOL|America Online Browser/i
      browser[:type] = "AOL"
      browser[:version] = if user_agent =~ /AOL/i
          user_agent.scan(/AOL[ |\/]([\d.]+)/i).uniq.to_s
        else
          user_agent.scan(/America Online Browser ([\d\.]+)/i).to_s
       end
    #Camino
    elsif user_agent =~ /Camino/i
      browser[:type] = "Camino";
      browser[:version] = user_agent.scan(/Camino\/([\d\.]+)/i).to_s
    #Konqueror
    elsif user_agent =~ /Konqueror/i
      browser[:type] = "Konqueror";
      browser[:version] = user_agent.scan(/Konqueror\/([\d.]+)/i).to_s
    #K-Meleon
    elsif user_agent =~ /K-Meleon/i
      browser[:type] = "K-Meleon";
      browser[:version] = user_agent.scan(/K-Meleon\/([\d.]+)/i).to_s
    #Firefox BonEcho
    elsif user_agent =~ /BonEcho/i
      browser[:type] = "Firefox BonEcho";
      browser[:version] = user_agent.scan(/BonEcho\/([\d.]+)/i).to_s
    #Netscape
    elsif user_agent =~ /Netscape/i
      browser[:type] = "Netscape";
      browser[:version] = user_agent.scan(/Netscape\/([\d.]+)/i).to_s
    #PSP
    elsif user_agent =~ /PlayStation Portable/i
      browser[:type] = "PlayStation Portable (PSP)";
      browser[:version] = user_agent.scan(/PlayStation Portable\); ([\d\.]+)/i).to_s
    #PlayStation 3
    elsif user_agent =~ /PlayStation 3/i
      browser[:type] = "PlayStation 3";
      browser[:version] = user_agent.scan(/PlayStation 3; ([\d\.]+)/i).to_s
    #Lynx
    elsif user_agent =~ /Lynx/i
      browser[:type] = "Lynx";
      browser[:version] = user_agent.scan(/Lynx\/([\d\.]+)/i).to_s
    else
      browser[:type] = "Other";
      browser[:version] = nil
    end
    return browser
  end
     
  #  returns browser OS
  def self.get_platform(user_agent)
    platform = nil
    if user_agent =~ /Win/i
      platform = "Windows"
    elsif user_agent =~ /Mac/i
      platform = "Macintosh"
    elsif user_agent =~ /Linux/i
      platform = "Linux";
    elsif user_agent =~ /SunOS/i
      platform = "Sun Solaris";
    elsif user_agent =~ /BSD/i
      platform = "FreeBSD";
    else
      platform = "Other"
    end
    return platform
  end
end
