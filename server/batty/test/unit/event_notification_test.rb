require 'test_helper'

class EventNotificationTest < ActionMailer::TestCase
  test "notify" do
    @expected.subject = 'EventNotification#notify'
    @expected.body    = read_fixture('notify')
    @expected.date    = Time.now

    assert_equal @expected.encoded, EventNotification.create_notify(@expected.date).encoded
  end

end
