if ENV['USE_GMAIL']

  ActionMailer::Base.delivery_method = :smtp

  ActionMailer::Base.smtp_settings = {
      address:        'smtp.gmail.com',
      port:           587,
      authentication: :login,
      user_name:      ENV['GMAIL_USERNAME'],
      password:       ENV['GMAIL_PASSWORD'],
      domain:         'gmail.com',
      enable_starttls_auto: true
  }

end