module ContactsImport
  require 'json'

  class ContactsImportError < RuntimeError; end

  EMAIL_SAMPLES = [['google_username', 'name@gmail.com'],
     ['yahoo_id', 'name@yahoo.com'],
     ['hotmail_username', 'name@hotmail.com']]

  def import_contacts(mail_in, magic_in)
    if false #debugging thing
      imported_mails = [["yahoo test", "kroogitesting@yahoo.com"],
                        ["ksu", "ksu_51@your-net-works.com   "],
                        ["hotmail test", "kroogi-testing@hotmail.com"], ["yandex test", "kroogi-testing@yandex.ru"],
                        ["hotmail test", "kroogi-testing@hotmail.com "], ['abc', 'abc@your-net-works.com'],
                        ['crooked126', 'a126@b.com'], ['crooked133', 'a133@b.com'], ['crooked151', 'a151@b.com'],
                        ]
      mail_creds = ["kroogi.testing@googlemail.com", "gmail"]
      return imported_mails, mail_creds
    end
    mail_creds = mail_in.split('@')
    if !(mail_creds[1] =~ /^(gmail|yahoo|googlemail|hotmail)\.[a-zA-Z]{2,3}$/i) || mail_creds[1] =~ /gmail\.ru/ #hotmail, aol
      raise ContactsImportError.new('Currently, Kroogi supports only gmail, yahoo and hotmail email accounts.'.t + '<br/>' +
              'We are working to expand the list of email providers.'.t + '<br/>' +
              'We apologize for any inconvenience.'.t)
    end
    unless mail_creds[0] && magic_in
      raise ContactsImportError.new('Invalid email address or password.'.t)
    end
    if mail_creds[1] =~ /^googlemail/i
      mail_creds[0] += '@'+mail_creds[1]
      mail_creds[1] = 'gmail'
      # hotmail wants full email as login
    elsif mail_creds[1] =~ /^hotmail/i
      mail_creds[0] += '@hotmail.com'
    end
    mail_creds[1].gsub!(/\.com$/, '')
    begin
      imported_mails = Contacts.new(mail_creds[1], mail_creds[0], magic_in).contacts
      # Contacts.new(mailsrv, login, password).contacts
    rescue Contacts::AuthenticationError => e # TODO: rescue SocketError and others
      raise ContactsImportError.new('Invalid email address or password.'.t)
    rescue GData::Client::CaptchaError => captcha
      #TODO: Here must be good captcha view or some another logic especially for GMail
      raise ContactsImportError.new('Invalid email address or password.'.t)
    rescue Timeout::Error => timeout
      raise ContactsImportError.new('We were unable to establish connection with your email server.'.t + 'Please try again later'.t)
    end

    return imported_mails, mail_creds
  end

  def categorize_user_contacts(imported_mails, user, mail_service_id)
    kroogi_users_mails, external_mails = [], []
    imported_mails.each do |name, email|
      already_imported = Set.new(user.user_address_book_items.map {|item| item.email})
      categorize_email(name, email, kroogi_users_mails, external_mails, user, mail_service_id, already_imported)
    end
    return kroogi_users_mails, external_mails
  end

  def categorize_email(name, email, kroogi_users_mails, external_mails, user, mail_service_id, already_imported)
    return if email.blank?
    name = unescape_imported_contact_string(name, mail_service_id)
    name ||= ''
    name, email = name.strip, email.strip.downcase
    if mail_service_id == 'hotmail'
      email = unescape_imported_contact_string(email, mail_service_id)
      email.gsub!(/%40/, '@')
      email.gsub!(/&amp.+$/, '')
    end
    name.gsub!(/[<>|:]/, '')
    email.gsub!(/[<>|:]/, '')
    # saving all emails
    unless already_imported.include?(email)
      user.user_address_book_items << UserAddressBookItem.new(:name => name, :email => email)
      already_imported << email
    end
    # then we have to know is that email is our user
    if user = User.active.first(:conditions => ['email = ?', email], :include => :preference)
      kroogi_users_mails << [name, email] if user.preference.email_searchable?
    else
      external_mails << [name, email]
    end
  rescue JSON::ParserError => e
    AdminNotifier.async_deliver_admin_alert("Couldn't import email - parse error: #{e.inspect}. Name, email: #{[name, email].inspect}")
  end

  #contact emails/names are sometimes escaped like this: \u041f\u022a... at least by Yahoo
  def unescape_imported_contact_string(string, mail_service)
    if string && string['\u']
      result = JSON.parse("[\"#{string.gsub('"', '\"')}\"]")[0]
      result
    else
      string
    end
  end

  def equal_emails?(one, another)
    one.downcase == another.downcase
  end

end