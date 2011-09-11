# Copyright (c) 2005 David Heinemeier Hansson
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module UserLocation
  
  def self.included(controller)
    controller.helper_method(:user_domain, :user_subdomain, :user_host, :user_url, :virtual_host) if controller.is_a?(ActionController::Base)
  end

  protected
    def default_user_subdomain
      current_actor.login if current_actor
    end
  
    def user_url(user_subdomain = default_user_subdomain, use_ssl = request.ssl?)
      (use_ssl ? "https://" : "http://") + user_host(user_subdomain) + (local_domain?(user_subdomain) ? ('/user/' + user_subdomain) : "" )
    end

    def user_host(user_subdomain = default_user_subdomain)
      user_subdomain = user_subdomain.login if user_subdomain.is_a?(User)
      domain = user_domain
      if local_domain?(domain)
        user_host = ""
        user_host << domain
      else
        user_host = ""
        user_host << user_subdomain + "."
        user_host << user_domain
      end
    end
    
    
    def virtual_host(subdomain = 'www')
      domain = user_domain
      if local_domain?(domain)
        domain
      else
        v_host = ""
        v_host << subdomain + "."
        v_host << user_domain
      end
    end
    

    def user_domain(options = {})
      # do not replace those hardcode values with request.host_with_port, which is just a convinience wrapper for host + port_string
      # those are here for the really good reason for following cases:
      #  - ip address hit
      #  - bots with http headers that are completely unreliable or whacked, and rails actually has a decency to return a nil domain
      #  - spoofed headers
      # APP_CONFIG[:hostname]
      options.reverse_merge! :port => true
      result = APP_CONFIG[:hostname] unless request && request.domain
      result = APP_CONFIG[:hostname] unless result || request.domain.match(/kroogi\.\w/) #protection, moved here from helper
      if result
        return options[:port] ? result : strip_port(result)
      end 
      user_domain = request.domain
      if request.port_string && options[:port]
        user_domain << request.port_string
      end
      user_domain
    end

  def strip_port(string)
    string.split(':')[0]
  end
    
    def user_subdomain
      subby = request.subdomains.first
      return nil if subby.blank?
      subby =~ /^(#{User::RESERVED})$/i ? nil : subby
    end
end