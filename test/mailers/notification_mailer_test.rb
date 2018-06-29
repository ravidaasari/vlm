require 'test_helper'

class NotificationMailerTest < ActionMailer::TestCase
  test "decommission_notification" do
    mail = NotificationMailer.decommission_notification
    assert_equal "Decommission notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
