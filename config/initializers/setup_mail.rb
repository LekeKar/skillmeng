# Configuration for using SendGrid on Heroku
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :user_name 			=> ENV['SENDGRID_USERNAME'],
  :password 			=> ENV['SENDGRID_PASSWORD'],
  :domain 				=> 'heroku.com',
  :address 				=> 'smtp.sendgrid.net',
  :port 				=> '2525',
  :authentication 		=> :plain,
  :enable_starttls_auto => true
}