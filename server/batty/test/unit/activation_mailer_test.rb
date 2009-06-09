
require 'test_helper'

class ActivationMailerTest < ActionMailer::TestCase
  def setup
    @klass = ActivationMailer
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
