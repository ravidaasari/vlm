class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.decommission_notification.subject
  #

   # def self.send_replacement_request(shift)
   #   @recipients = ["sds@vmware.com","sds1@vmware.com"]
   #   @recipients.each do |recipient|
   #     decommission_notification(recipient, shift, response, vm_name, user).deliver
   #   end
   # end

  def decommission_notification(response, vm_name, senders)
    # @senders = ["sds@vmware.com", "sds1@vmware.com"]
    @senders = senders
    @response = response
    @vm_name = vm_name
    # puts vm_name
    # puts @vm_name
    mail(:to => @senders , :subject => "VM deletion notification test")
  end

  def clone_notification(my_ip_address,my_target_vm, senders)
    # @senders = ["sds@vmware.com", "sds1@vmware.com"]
    @senders = senders
    @my_target_vm = my_target_vm
    @my_ip_address = my_ip_address
    
    # puts vm_name
    # puts @vm_name
    mail(:to => @senders , :subject => "VM Build notification test")
  end


end