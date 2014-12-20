class Notifications < ActionMailer::Base
  layout 'default_email'
  default from: Site.base_email

   def deployment_finished(emails, build)
    @build = build

    mail to: emails, subject: t('notifications.deployment_finished.subject', site_domain: Site.domain, build_name: build.name, deployment_status: build.deployment_status)
  end

end
