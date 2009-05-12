require 'test_helper'

class SignupActivationMailerTest < ActionMailer::TestCase
  test "request" do
    @expected.subject = 'SignupActivationMailer#request'
    @expected.body    = read_fixture('request')
    @expected.date    = Time.now

    assert_equal @expected.encoded, SignupActivationMailer.create_request(@expected.date).encoded
  end

end
