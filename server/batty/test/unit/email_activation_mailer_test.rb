require 'test_helper'

class EmailActivationMailerTest < ActionMailer::TestCase
  test "request" do
    @expected.subject = 'EmailActivationMailer#request'
    @expected.body    = read_fixture('request')
    @expected.date    = Time.now

    assert_equal @expected.encoded, EmailActivationMailer.create_request(@expected.date).encoded
  end

  test "complete" do
    @expected.subject = 'EmailActivationMailer#complete'
    @expected.body    = read_fixture('complete')
    @expected.date    = Time.now

    assert_equal @expected.encoded, EmailActivationMailer.create_complete(@expected.date).encoded
  end

end
