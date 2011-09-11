date_only = lambda { |time| time.localize("%b %d, %Y")  }
date_with_time = lambda { |time| time.localize("%d %b %Y %I:%M %p")  }
date_with_time_split = lambda { |time| time.localize("%d %b %Y<br/>(%I:%M %p)")  }
Date::DATE_FORMATS[:date_only] = date_only
Time::DATE_FORMATS[:date_only] = date_only
Date::DATE_FORMATS[:date_with_time] = date_with_time
Time::DATE_FORMATS[:date_with_time] = date_with_time
Date::DATE_FORMATS[:date_with_time_split] = date_with_time_split
Time::DATE_FORMATS[:date_with_time_split] = date_with_time_split


class Time
  def self.end
    parse('2038-01-01')
  end
  
  def stamp
    strftime("%Y%m%d%H%M%S")
  end

  def localize(format)
    # use once you add the time/date formats to the translation yml
    ::I18n.localize self, :format => format
    # strftime(format)
  end
  alias :loc :localize
end

class Date
  # Acts the same as #strftime, but returns a localized version of the
  # formatted date/time string.
  def localize(format)
    # use once you add the time/date formats to the translation yml
    ::I18n.localize self, :format => format
    
    # strftime(format)
  end
  alias :loc :localize
end

