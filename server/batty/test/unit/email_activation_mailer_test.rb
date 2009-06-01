
require 'test_helper'

class EmailActivationMailerTest < ActionMailer::TestCase
  def setup
    @klass = EmailActivationMailer
  end

  test "self.create_request_params" do
    options = {
      :recipients     => "recipients@example.jp",
      :activation_url => "http://activation/url",
    }
    expected = {
      :header => {
        :subject    => "[batty] 通知先メールアドレス登録",
        :from       => @klass::FromAddress,
        :recipients => "recipients@example.jp",
      },
      :body   => {
        :activation_url => "http://activation/url",
      },
    }
    assert_equal(expected, @klass.create_request_params(options))
  end

  test "self.create_request_params, deficient parameter" do
    assert_nothing_raised {
      @klass.create_request_params(:recipients => "", :activation_url => "")
    }
    assert_raise(ArgumentError) {
      @klass.create_request_params(:activation_url => "")
    }
    assert_raise(ArgumentError) {
      @klass.create_request_params(:recipients => "")
    }
  end

  test "self.create_request_params, invalid parameter" do
    assert_raise(ArgumentError) {
      @klass.create_request_params(:invalid => true)
    }
  end

  test "self.create_complete_params" do
    options = {
      :recipients => "recipients@example.jp",
    }
    expected = {
      :header => {
        :subject    => "[batty] 通知先メールアドレス登録完了",
        :from       => @klass::FromAddress,
        :recipients => "recipients@example.jp",
      },
      :body   => {},
    }
    assert_equal(expected, @klass.create_complete_params(options))
  end

  test "self.create_complete_params, deficient parameter" do
    assert_nothing_raised {
      @klass.create_complete_params(:recipients => "")
    }
    assert_raise(ArgumentError) {
      @klass.create_complete_params({})
    }
  end

  test "self.create_complete_params, invalid parameter" do
    assert_raise(ArgumentError) {
      @klass.create_complete_params(:invalid => true)
    }
  end

  test "request" do
    options = {
      :recipients     => email_addresses(:yuya_nayutaya).email,
      :activation_url => "http://activation/url/" + email_addresses(:yuya_nayutaya).activation_token,
    }
    assert_nothing_raised {
      @klass.create_request(options).encoded
    }
  end

  test "complete" do
    options = {
      :recipients => email_addresses(:yuya_nayutaya).email,
    }
    assert_nothing_raised {
      @klass.create_complete(options).encoded
    }
  end
end
