if Rails.env.development? || Rails.env.test?
  ActionMailer::Base.default_url_options = { :host => 'localhost',
                                             :port => 3000 }
  # use mailcatcher in development (http://mailcatcher.me/)
  ActionMailer::Base.smtp_settings = {
    :address => '127.0.0.1',
    :port => 1025
  }
else
  ActionMailer::Base.default_url_options = { :host => Sapwood.url }
  ActionMailer::Base.smtp_settings = {
    :user_name => Sapwood.send_grid.user_name,
    :password => Sapwood.send_grid.password,
    :domain => Sapwood.send_grid.domain,
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end
