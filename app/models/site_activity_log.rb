class SiteActivityLog < ActiveRecord::Base

  set_table_name :activity_logs

  START_DATE = '2010-12-02'
  
  if (Date.current - Date.parse(START_DATE)).to_i.even?
    set_table_name 'activity_log_even'
  else
    set_table_name 'activity_log_odd'
  end

  belongs_to :user
  belongs_to :actor, :class_name => "User"
  belongs_to :admin_flash

  def robot?
    !SiteActivityLoggerForControllers::Parser::Robot.name(self.user_agent).blank?
  end

  def robot
    SiteActivityLoggerForControllers::Parser::Robot.name(self.user_agent)
  end

  def browser
    browser = SiteActivityLoggerForControllers::Parser::UserAgent.browser_info(self.user_agent)
    "#{browser[:type]} #{browser[:version]}"
  end

  def platform
    SiteActivityLoggerForControllers::Parser::UserAgent.platform(self.user_agent)
  end

  def self.browsers
    browsers = {}

    all(:select => "user_agent, COUNT(*) AS total", :group => "user_agent",
        :order => "total DESC", :conditions => "content IS NULL").each {|log|
      next unless SiteActivityLoggerForControllers::Parser::Robot.name(log.user_agent).blank?
      browser_info = SiteActivityLoggerForControllers::Parser::UserAgent.browser_info(log.user_agent)
      n = "#{browser_info[:type]}|#{browser_info[:short_version]}"
      browsers[n] = (browsers[n] || 0) + log.total.to_i
    }

    browsers.map {|key, value|
      {:name => key.split("|").first, :version => key.split("|").last, :total => value}
    }.sort{|x,y| y[:total] <=> x[:total]}
  end

  def self.platforms
    platforms = {}

    all(:select => "user_agent, COUNT(*) AS total", :group => "user_agent",
        :order => "total DESC", :conditions => "content IS NULL").each {|log|
      next unless SiteActivityLoggerForControllers::Parser::Robot.name(log.user_agent).blank?
      platform_info = SiteActivityLoggerForControllers::Parser::UserAgent.platform(log.user_agent)

      platforms[platform_info] = (platforms[platform_info] || 0) + log.total.to_i
    }

    platforms.map {|key, value|
      {:name => key, :total => value}
    }.sort{|x,y| y[:total] <=> x[:total]}
  end

  def self.robots
    robots = {}
    all(:select => "user_agent, COUNT(*) AS total", :group => "user_agent",
      :order => "total DESC", :conditions => "content IS NULL").each{|log|
      bot = SiteActivityLoggerForControllers::Parser::Robot.name(log.user_agent)
      robots[bot] = ((robots[bot] || 0) + log.total.to_i) unless bot.blank?
    }

    robots.map {|key, value|
      {:name => key, :total => value}
    }.sort{|x,y| y[:total] <=> x[:total]}
  end

  def self.search_terms
    terms = {}
    all(:select => "referrer, COUNT(*) AS total", :group => "referrer",
      :order => "total DESC", :conditions => "content IS NULL").each{|log|
      term = SiteActivityLoggerForControllers::Parser::Keyword.terms(log.referrer)

      terms["#{term[:domain]}|#{term[:search_string]}"] = ((terms["#{term[:domain]}|#{term[:search_string]}"] || 0) + log.total.to_i) unless term[:search_string].blank?
    }

    terms.map {|key, value|

      {:query => key.split("|").last, :total => value, :domain => key.split("|").first}
    }.sort{|x,y| y[:total] <=> x[:total]}
  end

end