class ApplicationMailer < ActionMailer::Base
  default from: 'core-infra-linux@vmware.com'
  layout 'mailer'
end
