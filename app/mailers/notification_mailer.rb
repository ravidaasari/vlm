class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.decommission_notification.subject
  #
  def decommission_notification(response, vm_name, user)
    @response = response
    @vm_name = vm_name
    # puts vm_name
    # puts @vm_name
    mail(:to => user , :subject => "VM deletion notification test")
  end
end
