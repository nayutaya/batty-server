
require 'test_helper'

class ActivationMailerTest < ActionMailer::TestCase
  def setup
    @klass = ActivationMailer
  end

  #
  # クラスメソッド
  #

  test "self.create_request_for_signup_params" do
    options = {
      :recipients     => "recipients@example.jp",
      :activation_url => "http://activation/url",
    }
    expected = {
      :subject    => "[batty] ユーザ登録",
      :from       => @klass::FromAddress,
      :recipients => "recipients@example.jp",
      :body       => {:activation_url => "http://activation/url"},
    }
    assert_equal(expected, @klass.create_request_for_signup_params(options))
  end

  test "self.create_request_for_signup_params, invalid parameter" do
    options = {:recipients => "", :activation_url => ""}
    assert_nothing_raised       { @klass.create_request_for_signup_params(options) }
    assert_raise(ArgumentError) { @klass.create_request_for_signup_params(options.merge(:recipients => nil)) }
    assert_raise(ArgumentError) { @klass.create_request_for_signup_params(options.merge(:activation_url => nil)) }
    assert_raise(ArgumentError) { @klass.create_request_for_signup_params(options.merge(:invalid => true)) }
  end

  test "self.create_complete_for_signup_params" do
    options = {
      :recipients => "recipients@example.jp",
    }
    expected = {
      :subject    => "[batty] ユーザ登録完了",
      :from       => @klass::FromAddress,
      :recipients => "recipients@example.jp",
      :body       => {},
    }
    assert_equal(expected, @klass.create_complete_for_signup_params(options))
  end

  test "self.create_complete_for_signup_params, invalid parameter" do
    options = {:recipients => ""}
    assert_nothing_raised       { @klass.create_complete_for_signup_params(options) }
    assert_raise(ArgumentError) { @klass.create_complete_for_signup_params(options.merge(:recipients => nil)) }
    assert_raise(ArgumentError) { @klass.create_complete_for_signup_params(options.merge(:invalid => true)) }
  end

  test "self.create_request_for_notice_params" do
    options = {
      :recipients     => "recipients@example.jp",
      :activation_url => "http://activation/url",
    }
    expected = {
      :subject    => "[batty] 通知先メールアドレス登録",
      :from       => @klass::FromAddress,
      :recipients => "recipients@example.jp",
      :body       => {:activation_url => "http://activation/url"},
    }
    assert_equal(expected, @klass.create_request_for_notice_params(options))
  end

  test "self.create_request_for_notice_params, invalid parameter" do
    options = {:recipients => "", :activation_url => ""}
    assert_nothing_raised       { @klass.create_request_for_notice_params(options) }
    assert_raise(ArgumentError) { @klass.create_request_for_notice_params(options.merge(:recipients => nil)) }
    assert_raise(ArgumentError) { @klass.create_request_for_notice_params(options.merge(:activation_url => nil)) }
    assert_raise(ArgumentError) { @klass.create_request_for_notice_params(options.merge(:invalid => true)) }
  end

  test "self.create_complete_for_notice_params" do
    options = {
      :recipients => "recipients@example.jp",
    }
    expected = {
      :subject    => "[batty] 通知先メールアドレス登録完了",
      :from       => @klass::FromAddress,
      :recipients => "recipients@example.jp",
      :body       => {},
    }
    assert_equal(expected, @klass.create_complete_for_notice_params(options))
  end

  test "self.create_complete_for_notice_params, invalid parameter" do
    options = {:recipients => ""}
    assert_nothing_raised       { @klass.create_complete_for_notice_params(options) }
    assert_raise(ArgumentError) { @klass.create_complete_for_notice_params(options.merge(:recipients => nil)) }
    assert_raise(ArgumentError) { @klass.create_complete_for_notice_params(options.merge(:invalid => true)) }
  end

  #
  # インスタンスメソッド
  #

  test "request_for_signup" do
    options = {
      :recipients     => email_credentials(:yuya_nayutaya).email,
      :activation_url => "http://activation/url/" + email_credentials(:yuya_nayutaya).activation_token,
    }
    assert_nothing_raised {
      @klass.create_request_for_signup(options).encoded
    }
  end

  test "complete_for_signup" do
    options = {
      :recipients => email_credentials(:yuya_nayutaya).email,
    }
    assert_nothing_raised {
      @klass.create_complete_for_signup(options).encoded
    }
  end

  test "request_for_notice" do
    options = {
      :recipients     => email_addresses(:yuya_nayutaya).email,
      :activation_url => "http://activation/url/" + email_addresses(:yuya_nayutaya).activation_token,
    }
    assert_nothing_raised {
      @klass.create_request_for_notice(options).encoded
    }
  end

  test "complete_for_notice" do
    options = {
      :recipients => email_addresses(:yuya_nayutaya).email,
    }
    assert_nothing_raised {
      @klass.create_complete_for_notice(options).encoded
    }
  end
end
