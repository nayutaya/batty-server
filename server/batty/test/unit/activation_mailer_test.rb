
require 'test_helper'

class ActivationMailerTest < ActionMailer::TestCase
  def setup
    @klass = ActivationMailer
  end

  #
  # クラスメソッド
  #

  test "self.create_request_for_notice_params" do
    options = {
      :recipients     => "recipients@example.jp",
      :activation_url => "http://activation/url",
    }
    expected = {
      :header => {
        :subject    => "[batty] 通知先メールアドレス登録",
        :from       => "batty-no-reply@nayutaya.jp",
        :recipients => "recipients@example.jp",
      },
      :body => {
        :activation_url => "http://activation/url",
      },
    }
    assert_equal(expected, @klass.create_request_for_notice_params(options))
  end

  test "self.create_request_for_notice_params, deficient parameter" do
    assert_nothing_raised {
      @klass.create_request_for_notice_params(:recipients => "", :activation_url => "")
    }
    assert_raise(ArgumentError) {
      @klass.create_request_for_notice_params(:activation_url => "")
    }
    assert_raise(ArgumentError) {
      @klass.create_request_for_notice_params(:recipients => "")
    }
  end

  test "self.create_request_for_notice_params, invalid parameter" do
    assert_raise(ArgumentError) {
      @klass.create_request_for_notice_params(:invalid => true)
    }
  end

  #
  # インスタンスメソッド
  #

=begin
  test "request_for_notice" do
    @expected.subject = 'ActivationMailer#request_for_notice'
    @expected.body    = read_fixture('request_for_notice')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ActivationMailer.create_request_for_notice(@expected.date).encoded
  end
=end
end
