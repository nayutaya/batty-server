
require 'test_helper'

class SignupActivationMailerTest < ActionMailer::TestCase
  def setup
    @klass = SignupActivationMailer
  end

  test "self.create_request_params" do
    options = {
      :recipients     => "foo@example.com",
      :activation_url => "http://activation/url",
    }
    expected = {
      :header => {
        :subject    => "[batty] ユーザ登録",
        :from       => "batty-no-reply@nayutaya.jp",
        :recipients => "foo@example.com",
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

  test "request" do
    options = {
      :recipients     => email_credentials(:yuya_nayutaya).email,
      :activation_url => "http://activation/url/" + email_credentials(:yuya_nayutaya).activation_token,
    }
    assert_nothing_raised {
      @klass.create_request(options).encoded
    }
  end
end
