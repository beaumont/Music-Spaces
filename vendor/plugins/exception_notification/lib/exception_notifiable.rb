require 'ipaddr'

# Copyright (c) 2005 Jamis Buck
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
module ExceptionNotifiable
  def self.included(target)
    target.extend(ClassMethods)
    target.send :helper_method, :just_notify if target.respond_to?(:helper_method)
  end

  module ClassMethods
    def consider_local(*args)
      local_addresses.concat(args.flatten.map { |a| IPAddr.new(a) })
    end

    def local_addresses
      addresses = read_inheritable_attribute(:local_addresses)
      unless addresses
        addresses = [IPAddr.new("127.0.0.1")]
        write_inheritable_attribute(:local_addresses, addresses)
      end
      addresses
    end

    def exception_data(deliverer=self)
      if deliverer == self
        read_inheritable_attribute(:exception_data)
      else
        write_inheritable_attribute(:exception_data, deliverer)
      end
    end

    def exceptions_to_treat_as_404
      exceptions = [
        ActiveRecord::RecordNotFound,
        ActionController::UnknownController,
        Kroogi::NotFound,
        ActionController::UnknownAction
      ]
      exceptions << ActionController::RoutingError if ActionController.const_defined?(:RoutingError)
      exceptions
    end

    def exceptions_to_treat_as_403
      [Kroogi::NotPermitted]
    end
    
    # Don't send email for these exception types
    def exceptions_not_worth_emailing
      [CGI::Session::CookieStore::TamperedWithCookie,
       ActionController::InvalidAuthenticityToken,
       ActionController::UnknownHttpMethod, 
      ]
    end

  end

  def just_notify(exception, options = {})
    log.error "Caught exception: %s" % exception.inspect
    return if options[:skip_40x] &&
            (self.class.exceptions_to_treat_as_403.any? {|ec| exception.is_a?(ec)} ||
                    self.class.exceptions_to_treat_as_404.any? {|ec| exception.is_a?(ec)})
    return if self.class.exceptions_not_worth_emailing.include?(exception.class)
    deliverer = self.class.exception_data
    data = case deliverer
    when nil then {}
    when Symbol then send(deliverer)
    when Proc then deliverer.call(self)
    end

    ExceptionNotifier.deliver_exception_notification(exception, self, request, data)
  end

  def exception_notification__rescue_action_in_public(exception)
    case exception
    when *self.class.exceptions_to_treat_as_404
      render_404 unless self.send(:performed?)
    when *self.class.exceptions_to_treat_as_403
      render_403 unless self.send(:performed?)
    else          
      just_notify(exception)
      render_500 unless self.send(:performed?)
    end
  end

  # Could be done this way, if nginx didn't need straigh HTML
  # def render_404
  #   vars = {
  #     :title => 'Page Not Found'.t,
  #     :msg => 'Please go back'.t
  #   }
  #   respond_to do |type|
  #     type.html { render :file => "#{RAILS_ROOT}/app/views/errors/generic.rhtml", :status => "404 Not Found", :locals => vars }
  #     type.all  { render :nothing => true, :status => "404 Not Found" }
  #   end
  # end
  
  def render_404
    respond_to do |type|
      type.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => "404 Not Found" }
      type.all  { render :nothing => true, :status => "404 Not Found" }
    end
  end
  
  def render_403
    respond_to do |type|
      type.html { render :file => "#{RAILS_ROOT}/public/403.html", :status => "403 Not Permitted" }
      type.all  { render :nothing => true, :status => "403 Not Permitted" }
    end
  end

  def render_500
    respond_to do |type|
      type.html { render :file => "#{RAILS_ROOT}/public/500.html", :status => "500 Error" }
      type.all  { render :nothing => true, :status => "500 Error" }
    end
  end

  private

  def local_request?
    remote = IPAddr.new(request.remote_ip)
    !self.class.local_addresses.detect { |addr| addr.include?(remote) }.nil?
  end

end
