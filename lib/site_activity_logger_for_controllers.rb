module SiteActivityLoggerForControllers

  require 'uri'

  def write_site_activity_log
    return if donot_log?
    SiteActivityLog.create(
      :ip => request.remote_ip,
      :url => request.url,
      :path => request.request_uri,
      :referrer => request.referrer,
      :user_agent => request.user_agent,
      :accept_language => request.accept_language,

      :session_id => session[:csrf_id] ? session[:csrf_id] : nil,

      :system_message_type => @system_message.blank? ? nil : @system_message.class.to_s,
      :admin_flash_id => @admin_flashmsg.blank? ? nil : @admin_flashmsg.id,

      :login => current_user.login,
      :user_id => current_user.id,
      :actor_login => current_actor.login,
      :actor_id => current_actor.id
    )
  rescue => e
    AdminNotifier.async_deliver_admin_alert("#{SiteActivityLoggerForControllers.name}'s filter failed: #{e.inspect}")
  end

  def donot_log?
    configs = log_configs
    return true if !APP_CONFIG.enable_site_activity_log
    return true if configs.blank?
    return true unless configs.monitoring
    return true if current_user.guest? && !configs.guests
    return true if current_user.guest? && !configs.bots && !SiteActivityLoggerForControllers::Parser::Robot.name(request.user_agent).blank?
    return true if !current_user.guest? && !configs.all_users &&
                  !(log_users.include?(current_user.id) || log_users.include?(current_actor.id))
  end

  def log_configs
    @log_configs ||= SiteActivityLogConfig.first
  end

  def log_configs=(configs)
    @log_configs = configs
  end

  def log_users
    @log_users ||= SiteActivityLogUser.all.map(&:user_id)
  end

  def log_users=(users)
    @log_users = users.map(&:user_id)
  end

  def self.table_columns(table)
    table.timestamps
    table.string  :ip, :default => '', :limit => 16
    table.string  :url, :default => ''
    table.string  :path, :default => ''
    table.string  :referrer, :default => ''
    table.string  :user_agent, :default => ''

    table.string  :session_id, :default => '', :limit => 50

    table.string  :login, :default => ''
    table.integer :user_id
    table.string  :actor_login, :default => ''
    table.integer :actor_id

    table.string  :system_message_type, :default => ''
    table.integer :admin_flash_id

    table.string  :content_type, :default => '', :limit => 50
    table.integer :content_id
    table.text    :content
  end

  module Parser

    class UserAgent

      # Process the user agent string and returns
      # the users's platform:
      #
      # ControllerActivityLogger::Parser::UserAgent.platform("(Macintosh U PPC Mac OS X en)")
      # => "Macintosh"
      #
      def self.platform(user_agent)
        platform = nil
        if user_agent =~ /Win/i && user_agent.scan(/Powermarks/i).empty?
          platform = "Windows"
        elsif user_agent =~ /Mac/i
          platform = "Macintosh"
        elsif user_agent =~ /Linux/i
          platform = "Linux"
        elsif user_agent =~ /SunOS/i
          platform = "Sun Solaris"
        elsif user_agent =~ /BSD/i
          platform = "FreeBSD"
        else
          platform = "Other"
        end
        return platform
      end

      # Process the user agent string and returns
      # the user's browser info as a hash:
      #
      # user_agent = "Mozilla/5.0 (Windows; U; Windows NT 5.1; nl; rv:1.8) Gecko/20051107 Firefox/1.5"
      # ControllerActivityLogger::Parser::UserAgent.browser_info(user_agent)
      # => {:type => 'Firefox', :version => '1.5'}
      #
      def self.browser_info(user_agent)
        browser = {
          :type => "",
          :version => "",
          :short_version => ""
        }
        #Internet Exlorer
        if user_agent =~ /MSIE/i && user_agent.scan(/AOL|America Online Browser/i).empty? && user_agent.scan(/StackRambler/i).empty?
          browser[:type] = "MSIE"
          browser[:version] = user_agent.scan(/MSIE ([\d\.]+)/i).to_s
        # Iceweasel
        elsif user_agent =~ /Iceweasel/i
          browser[:type] = "Iceweasel"
          browser[:version] = user_agent.scan(/Iceweasel\/([\d\.]+)/i).to_s
        #Firefox/Firebird/Phoenix
        elsif user_agent =~ /Firefox|Firebird|Phoenix/i
          browser[:type] = "Firefox"
          browser[:version] = user_agent.scan(/(Firefox|Firebird|Phoenix)\/([\d\.]{1,10})/i).last.last.to_s
        #Galeon
        elsif user_agent =~ /Galeon/i
          browser[:type] = "Galeon"
          browser[:version] = user_agent.scan(/Galeon\/([\d\.]+)/i).to_s
        # Chrome
        elsif user_agent =~ /Chromium|Chrome/i
          browser[:type] = "Chrome"
          browser[:version] = user_agent.scan(/(Version|Chromium|Chrome)\/([\d\.]+)/i).last.last.to_s
        #Safari
        elsif user_agent =~ /Safari/i
          browser[:type] = "Safari"
          browser[:version] = user_agent.scan(/Version\/([\d\.]+)/i).to_s
        #Opera Mini
        elsif user_agent =~ /Opera Mini/i
          browser[:type] = "Opera Mini"
          browser[:version] = user_agent.scan(/(Version|Opera)[\s|\/]([\d\.]+)/i).last.last.to_s
        #Opera
        elsif user_agent =~ /Opera/i
          browser[:type] = "Opera"
          browser[:version] = user_agent.scan(/(Version|Opera)[\s|\/]([\d\.]+)/i).last.last.to_s
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
          browser[:type] = "Camino"
          browser[:version] = user_agent.scan(/Camino\/([\d\.]+)/i).to_s
        #Konqueror
        elsif user_agent =~ /Konqueror/i
          browser[:type] = "Konqueror"
          browser[:version] = user_agent.scan(/Konqueror\/([\d.]+)/i).to_s
        #K-Meleon
        elsif user_agent =~ /K-Meleon/i
          browser[:type] = "K-Meleon"
          browser[:version] = user_agent.scan(/K-Meleon\/([\d.]+)/i).to_s
        #Firefox BonEcho
        elsif user_agent =~ /BonEcho/i
          browser[:type] = "Firefox BonEcho"
          browser[:version] = user_agent.scan(/BonEcho\/([\d.]+)/i).to_s
        #Netscape
        elsif user_agent =~ /Netscape/i
          browser[:type] = "Netscape"
          browser[:version] = user_agent.scan(/Netscape\/([\d.]+)/i).to_s
        #PSP
        elsif user_agent =~ /PlayStation Portable/i
          browser[:type] = "PlayStation Portable (PSP)"
          browser[:version] = user_agent.scan(/PlayStation Portable\) ([\d\.]+)/i).to_s
        #PlayStation 3
        elsif user_agent =~ /PlayStation 3/i
          browser[:type] = "PlayStation 3"
          browser[:version] = user_agent.scan(/PlayStation 3 ([\d\.]+)/i).to_s
        #Lynx
        elsif user_agent =~ /Lynx/i
          browser[:type] = "Lynx"
          browser[:version] = user_agent.scan(/Lynx\/([\d\.]+)/i).to_s
        elsif user_agent =~ /Microsoft Outlook/i
          browser[:type] = "Microsoft Outlook"
          browser[:version] = user_agent.scan(/Microsoft Office\/([\d\.]+)/i).to_s
        # Old Netscape
        elsif user_agent =~ /Mozilla\/(\d{1,2}\.\d{1,2})/ && user_agent.scan(/Yandex|Googlebot|Yahoo|Rambler|Powermarks|AppleWebKit|bingbot|WASALive/i).empty?
          browser[:type] = "Netscape Navigator"
          browser[:version] = user_agent.scan(/Mozilla\/([\d\.]+)/i).to_s
        else
          browser[:type] = "Other"
          browser[:version] = ""
        end
        browser[:short_version] = browser[:version].to_s.scan(/(\d{1,4}\.\d{1,4})/).first
        return browser
      rescue => e
        AdminNotifier.async_deliver_admin_alert("Browser info parser error \n USER_AGENT #{user_agent} \n #{e.inspect}")
        return {}
      end
    end

    class Robot

      # Process the robots (when available) found on the
      # user agent strings and returns its name:
      #
      # user_agent = "Googlebot/2.X (+http://www.googlebot.com/bot.html)"
      # ControllerActivityLogger::Parser::Robot.name(user_agent)
      # => "Googlebot"
      #
      KNOWN_BOTS = [
        ['Atomz.com', /Atomz/i],
        ['Googlebot', /Googlebot/i],
        ['InfoSeek', /InfoSeek/i],
        ['Ask Jeeves', /Ask Jeeves/i],
        ['Lycos', /Lycos/i],
        ['MSNBot', /MSNBOT/i],
        ['Yahoo Slurp', /Yahoo! Slurp/i],
        ['Inktomi', /Slurp/i],
        ['AdsBot [Google]', /AdsBot-Google/i],
        ['Alexa', /ia_archiver/i],
        ['Alta Vista', /Scooter\//i],
        ['Ask Jeeves', /Ask Jeeves/i],
        ['Baidu [Spider]', /Baiduspider\+\(/i],
        ['Bing', /bingbot\//i],
        ['Exabot', /Exabot\//i],
        ['FAST Enterprise', /FAST Enterprise Crawler/i],
        ['FAST WebCrawler', /FAST-WebCrawler\//i],
        ['Francis', /http:\/\/www\.neomo\.de\//i],
        ['Gigabot', /Gigabot\//i],
        ['Google Adsense', /Mediapartners-Google/i],
        ['Google Desktop', /Google Desktop/i],
        ['Google Feedfetcher', /Feedfetcher-Google/i],
        ['Google Feedfetcher', /heise-IT-Markt-Crawler/i],
        ['Heise IT-Markt', /heritrix\//i],
        ['Heritrix', /ibm\.com\/cs\/crawler/i],
        ['ICCrawler - ICjobs', /ICCrawler - ICjobs/i],
        ['Ichiro', /ichiro\//i],
        ['Majestic-12', /MJ12bot\//i],
        ['Metager', /MetagerBot\//i],
        ['MSN NewsBlogs', /msnbot-NewsBlogs\//i],
        ['MSNbot Media', /msnbot-media\//i],
        ['NG-Search', /NG-Search\//i],
        ['Nutch', /http:\/\/lucene\.apache\.org\/nutch\//i],
        ['Nutch/CVS', /NutchCVS\//i],
        ['OmniExplorer', /OmniExplorer_Bot\//i],
        ['Online link', /online link validator/i],
        ['Psbot', /psbot\/0/i],
        ['Seekport', /Seekbot\//i],
        ['Sensis', /Sensis Web Crawler/i],
        ['SEO Crawler', /SEO search Crawler\//i],
        ['Seoma', /Seoma \[SEO Crawler\]/i],
        ['SEOSearch', /SEOsearch\//i],
        ['Snappy', /Snappy\/1\.1 \( http:\/\/www\.urltrends\.com\/ \)/i],
        ['Steeler', /http:\/\/www\.tkl\.iis\.u-tokyo\.ac\.jp\/~crawler\//i],
        ['Synoo', /SynooBot\//i],
        ['Telekom', /crawleradmin\.t-info@telekom\.de/i],
        ['TurnitinBot', /TurnitinBot\//i],
        ['Voyager', /voyager\/1\.0/i],
        ['W3', /W3 SiteSearch Crawler/i],
        ['W3C', /W3C-checklink\//i],
        ['W3C', /W3C_\*Validator/i],
        ['WiseNut', /http:\/\/www\.WISEnutbot\.com/i],
        ['YaCy', /yacybot/i],
        ['Yahoo MMCrawler', /Yahoo-MMCrawler\//i],
        ['YahooSeeker', /YahooSeeker\//i],
        ['YandexBlogs', /YandexBlogs\//i],
        ['YandexImages', /YandexImages\//i],
        ['YandexFavicons', /YandexFavicons\//i],
        ['Yandex', /Yandex/i],
        ['Yandex ADS', /YaDirectBot\//i],
        ['Rambler', /Rambler/i],
        ['Mail.Ru', /Mail\.Ru/i],
        ['Сuill', /Twiceler/i],
        ['WebAlta', /WebAlta Crawler\//i],
        ['Accoona', /Accoona-AI-Agent\//i],
        ['ASPseek', /ASPseek\//i],
        ['Boitho', /boitho\.com-dc\//i],
        ['Bunnybot', /powered by www\.buncat\.de/i],
        ['Cosmix', /cfetch\//i],
        ['Crawler Search', /\.Crawler-Search\.de/i],
        ['Findexa', /Findexa Crawler \(/i],
        ['GBSpider', /GBSpider v/i],
        ['Genie', /genieBot \(/i],
        ['Hogsearch', /oegp v\. 1\.3\.0/i],
        ['Insuranco', /InsurancoBot/i],
        ['IRLbot', /http:\/\/irl\.cs\.tamu\.edu\/crawler/i],
        ['ISC Systems', /ISC Systems iRc Search/i],
        ['Jyxobot', /Jyxobot\//i],
        ['Kraehe', /-DIE-KRAEHE- META-SEARCH-ENGINE\//i],
        ['LinkWalker', /LinkWalker/i],
        ['MMSBot', /http:\/\/www\.mmsweb\.at\/bot\.html/i],
        ['Naver', /nhnbot@naver.com\)/i],
        ['NetResearchServer', /NetResearchServer\//i],
        ['Nimble', /NimbleCrawler/i],
        ['Ocelli', /Ocelli\//i],
        ['Onsearch', /onCHECK-Robot/i],
        ['Orange', /OrangeSpider/i],
        ['Sproose', /http:\/\/www\.sproose\.com\/bot/i],
        ['Susie', /\!Susie \(http:\/\/www\.sync2it\.com\/susie\)/i],
        ['Tbot', /Tbot\//i],
        ['Thumbshots', /thumbshots-de-Bot/i],
        ['Vagabondo', /http:\/\/webagent\.wise-guys\.nl\//i],
        ['Walhello', /appie 1\.1 \(www\.walhello\.com\)/i],
        ['WissenOnline', /WissenOnline-Bot/i],
        ['WWWeasel', /WWWeasel Robot v/i],
        ['Xaldon', /Xaldon WebSpider/i],
        ['MLBot', /MLBot/i],
        ['Discobot', /discobot\//i],
        ['NetNewsWire', /NetNewsWire\//i],
        ['AppleSyndication', /AppleSyndication\//i],
        ['Apple-PubSub', /Apple-PubSub\//i],
        ['Powermarks', /Powermarks\//i],
        ['GeoHasher', /GeoHasher/i],
        ['Facebook External Hit', /\+http:\/\/www.facebook.com\/externalhit_uatext.php/i],
        ['WASALive', /WASALive/i],
        ['Sosospider', /Sosospider/i],
        ['Snoopy', /Snoopy/i],
        ['Best Persons', /http:\/\/www.bestpersons.ru\//i],
        ['WLA Syndication Platform', /WLA Syndication Platform/i],
        ['Twisted PageGetter', /Twisted PageGetter/i],
        ['Tabbloid', /\+http:\/\/tabbloid.com\//i]
      ]

      def self.name(agent)
        KNOWN_BOTS.each do |name, regex|
          if agent =~ regex
            return name
            break
          end
        end
        return nil
      end
    end

    class Keyword

      # Process the referrers and returns
      # the search terms if they're available:
      #
      #   referer = "http://search.msn.com/results.aspx?srch=105&FORM=AS5&q=kroogi"
      #   ControllerActivityLogger::Parser::Keyword.terms(referer)
      #   => 'kroogi'
      #
      def self.terms(string)
        return {} if string.nil?
        begin
          search_string = nil
          domain = URI::split(string)[2]
          if domain =~ /[google|alltheweb|search\.msn|ask|altavista|]\./ && string =~ /[?|&]q=/i
            search_string = CGI.unescape(string.scan(/[?|&]q=([^&]*)/).flatten.to_s)
          elsif domain =~ /yahoo\./i && string =~ /[?|&]p=/i
            search_string = CGI.unescape(string.scan(/[?|&]p=([^&]*)/).flatten.to_s)
          elsif domain =~ /search\.aol\./i && string =~ /[?|&]query=/i
            search_string = CGI.unescape(string.scan(/[?|&]query=([^&]*)/).flatten.to_s)
          elsif domain =~ /nigma/i && string =~ /[?|&]s=/i
            search_string = CGI.unescape(string.scan(/[?|&]s=([^&]*)/).flatten.to_s)
          elsif domain =~ /yandex/i && string =~ /[?|&]text=/i
            search_string = CGI.unescape(string.scan(/[?|&]text=([^&]*)/).flatten.to_s)
          end
          return {:domain => domain, :search_string => search_string}
        rescue
          return {}
        end
      end

      # Process the referrers and returns the referer domain.
      # <em>Host</em> is your site's url (request.host)
      #
      #   referer = "http://search.msn.com/results.aspx?srch=105&FORM=AS5&q=kroogi"
      #   ControllerActivityLogger::Parser::Keyword.get_domain(referer, 'localhost')
      #   => "search.msn.com"
      #
      def self.domain(string, host)
        return if string.nil?
        domain = nil
        domain = URI::split(string)[2]
        return domain != host ? domain : nil
      end
    end

  end

end
