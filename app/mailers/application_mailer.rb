class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.app.fetch(:mailer).fetch(:default_from)
  layout "mailer"
end
