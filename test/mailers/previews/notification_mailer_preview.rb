# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/decommission_notification
  def decommission_notification
    NotificationMailer.decommission_notification
  end

end
