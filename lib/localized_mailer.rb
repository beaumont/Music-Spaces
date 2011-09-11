# Inherit from this to reset locale after mail has been delivered.
# Set locale in setup method before sending (see activity_notifier's 
# setup_email for example).

require 'base64'
require "digest/md5"
class LocalizedMailer < ActionMailer::Base
  include ActionController::UrlWriter
  default_url_options[:host] = 'kroogi.com'
  helper :all
  
  def self.drb_mailer
    MiddleMan.worker(:email_worker)
  end
  
  def set_locale(new_loc)
    @old_locale = I18n.locale
    begin
      Locale.set new_loc
    rescue
      Locale.set @old_locale
    end
  end
  
  def reset_locale
    Locale.set(@old_locale) if @old_locale && I18n.locale != @old_locale
  end

  # http://stackoverflow.com/questions/341708/how-to-handle-utf-8-email-headers-like-subject-using-ruby
  def head_encode(incoming_string)
    if I18n.locale == 'en'
      incoming_string
    else  
      self.class.head_encode(incoming_string)
    end
  end

  def self.head_encode(string)
    encoded_string = Base64.encode64(string).chomp
    return "=?UTF-8?B?#{encoded_string}?="    
  end
  
  # Create/deliver like normal method_missing, but add locale param to all URLs and reset locale when done
  def self.method_missing(method_symbol, *parameters)
    case method_symbol.id2name
      when /^create_([_a-z]\w*)/
        begin
          msg = new($1, *parameters)
          init_message(msg)
          msg.reset_locale
          msg.mail
        rescue ActionView::TemplateError => e
          raise e unless e.original_exception.is_a?(Kroogi::NothingToSend)        
        rescue Kroogi::NothingToSend
        end
      when /^deliver_([_a-z]\w*)/ 
        begin
          msg = new($1, *parameters)
          init_message(msg)
          msg.deliver!
          msg.reset_locale
          msg.mail
        rescue ActionView::TemplateError => e
          raise e unless e.original_exception.is_a?(Kroogi::NothingToSend)
        rescue Kroogi::NothingToSend
        end
      else super
    end
  end

  def self.init_message(msg)
    #each part.body needs to be assigned here, once and only once
    get_all_available_body_parts(msg).each do |part|
      body = part.body
      #body = add_locale_to_all_links_in_string(body + " ") # Regex isn't happy with urls ending the text
      body = Base64.encode64(body) if part.try(:transfer_encoding) == 'base64'
      part.body = body
    end
  end
  
  # Multipart emails have to be cycled through mail.parts, but that's just empty if there's only one part.
  def self.get_all_available_body_parts(msg)
    return msg.mail.parts unless msg.mail.parts.empty?
    return [msg.mail]
  end
  
  # Find all the URLs in the email body and append locale=<current locale> to them, so e.g. russian emails link to russian page on site
  def self.add_locale_to_all_links(msg)
    text_blocks = get_all_available_body_parts(msg)
    text_blocks.each do |part|
      new_body = part.body + " " # Regex isn't happy with urls ending the text
      part.body = add_locale_to_all_links_in_string(new_body)
    end
  end

  def self.add_locale_to_all_links_in_string(string)
    string.gsub(/http:\/\/.+?[\s"'<]/) {|url| url_with_locale( url ) }
  end
  
  def self.url_with_locale(given_url)
    #puts "url_with_locale with '%s'" % given_url
    # Return the URL if it isn't a kroogi url, or if it already has a locale section
    return given_url unless given_url.match(/kr(?:oo|u)gi/) || given_url.match(/localhost/)
    return given_url if given_url.match(/[\?&]locale=/)

    # OK, append the current locale to the url as necessary
    cur_locale = I18n.language_code || 'en'
    (url, suffix) = given_url.scan(/(http:\/\/.+?)([\s"'<])/).first
    url.match(/\?/) ? "#{url}&locale=#{cur_locale}#{suffix}" : "#{url}?locale=#{cur_locale}#{suffix}"
  end

  # I don't want to use method_missing here because it's cleaner this way.
  # 
  # This let's you call Mailer.async_deliver_some_message(stuffs) and it will be sent to backgrounDRB as a task.
  def self.method_added(method_name)
    # only add this to public methods a.k.a methods that can be mailed
    if public_method_defined?(method_name)
      module_eval(<<-EOS, __FILE__, __LINE__ + 1)
        def self.async_deliver_#{method_name}(*args)
          enq_deliver_#{method_name}(*args) #async is too unreliable
        end 

        def self.enq_deliver_#{method_name}(*args)
          if APP_CONFIG.disable_bdrb
            return self.deliver_#{method_name}(*args)
          end

          begin
            job_key = args.inspect
            job_key = Digest::MD5.hexdigest(job_key)
            job_key = "#{method_name}_in_#{self.mailer_name}_" + job_key
            # use mailer_name and not class.name so you still have benefits of ActionMailer
            drb_mailer.enq_deliver_email(:arg => ["#{self.mailer_name}", :#{method_name}, args], :job_key => job_key)
          rescue => e
            notify_about_async_error(e, 'send email') #let's see why it failed
            return self.deliver_#{method_name}(*args)
          end
        end
      EOS
    end
  end
end