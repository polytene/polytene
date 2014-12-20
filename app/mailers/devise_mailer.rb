class DeviseMailer < Devise::Mailer
  layout 'default_email'
  default from: Site.base_email
end
