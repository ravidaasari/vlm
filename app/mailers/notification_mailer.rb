class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.decommission_notification.subject
  #
  def decommission_notification(response)
    @greeting = "Hi"
    @response = response
    puts @response

    mail to: "sushmadssuresh@gmail.com" , subject: "VM deletion notification test"
  end
end
