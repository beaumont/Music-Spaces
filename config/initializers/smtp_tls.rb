APP_CONFIG[:important_mail] = {
  :address =>     "mail.authsmtp.com",
  :port =>        2525,
  :domain =>      'kroogi.com',
  :user_name =>   'ac37694',
  :password =>    'uwxk8geqc',
  :tls =>          false,
}

APP_CONFIG[:junk_mail] = APP_CONFIG[:important_mail]

APP_CONFIG[:admin_mail] = APP_CONFIG[:important_mail]

APP_CONFIG[:server_mail] = {
  :address =>     "localhost",
  :port =>        25,
  :domain =>      'your-net-works.com',
  :tls =>          false,
}

#this is the default activity email account, it has a highest probabilty of being blacklisted, dont use it for important user account mail
ActionMailer::Base.smtp_settings = APP_CONFIG[:junk_mail]