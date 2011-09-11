#:notls handler - copy of perform_delivery_smtp from actionmailer-2.2.2, except smtp.enable_starttls_auto line
module ActionMailer
  class Base
      def perform_delivery_notls(mail)
        destinations = mail.destinations
        mail.ready_to_send
        sender = mail['return-path'] || mail.from

        smtp = Net::SMTP.new(smtp_settings[:address], smtp_settings[:port])
        smtp.enable_starttls_auto if smtp.respond_to?(:enable_starttls_auto) && false
        smtp.start(smtp_settings[:domain], smtp_settings[:user_name], smtp_settings[:password],
                   smtp_settings[:authentication]) do |smtp|
          #puts "gonna send email: ---\n%s\n---" % mail.encoded
          smtp.sendmail(mail.encoded, sender, destinations)
        end
      end
  end
end

