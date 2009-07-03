
require 'test_helper'

class EventNotificationTest < ActionMailer::TestCase
  def setup
    @klass = EventNotification
  end

  test "self.create_notify_params" do
    options = {
      :subject    => "subject",
      :recipients => "recipients@example.com",
      :body       => "body",
    }
    expected = {
      :header => {
        :subject    => "[batty] subject",
        :from       => @klass::FromAddress,
        :recipients => "recipients@example.com",
      },
      :body   => {
        :body => "body",
      },
    }
    assert_equal(expected, @klass.create_notify_params(options))
  end

  test "self.create_notify_params, deficient parameter" do
    assert_nothing_raised {
      @klass.create_notify_params(:subject => "", :recipients => "", :body => "")
    }
    assert_raise(ArgumentError) {
      @klass.create_notify_params(:recipients => "", :body => "")
    }
    assert_raise(ArgumentError) {
      @klass.create_notify_params(:subject => "", :body => "")
    }
    assert_raise(ArgumentError) {
      @klass.create_notify_params(:subject => "", :recipients => "")
    }
  end

  test "self.create_notify_params, invalid parameter" do
    assert_raise(ArgumentError) {
      @klass.create_notify_params(:invalid => true)
    }
  end

  test "notify" do
    options = {
      :subject    => "subject",
      :recipients => email_addresses(:yuya_gmail).email,
      :body       => "body",
    }
    assert_nothing_raised {
      @klass.create_notify(options).encoded
    }
  end
end
