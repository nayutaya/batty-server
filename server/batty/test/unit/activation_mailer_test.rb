
require 'test_helper'

class ActivationMailerTest < ActionMailer::TestCase
  def setup
    @klass = ActivationMailer
  end

  #
  # インスタンスメソッド
  #

  test "build_message" do
    time = Time.local(2010, 1, 1)
    options = {
      :header => {
        :subject    => "SUBJECT",
        :from       => "FROM",
        :recipients => "RECIPIENTS",
      },
      :body => {:KEY => :VALUE},
    }

    called = []
    musha = Kagemusha.new(@klass)
    musha.def(:subject)    { |value| called << [:subject,    value] }
    musha.def(:from)       { |value| called << [:from,       value] }
    musha.def(:recipients) { |value| called << [:recipients, value] }
    musha.def(:sent_on)    { |value| called << [:sent_on,    value] }
    musha.def(:body)       { |value| called << [:body,       value] }
    musha.swap {
      Kagemusha::DateTime.at(time) {
        assert_equal(nil, @klass.allocate.__send__(:build_message, options))
      }
    }

    expected = [
      [:subject,    "SUBJECT"],
      [:from,       "FROM"],
      [:recipients, "RECIPIENTS"],
      [:sent_on,    time],
      [:body,       {:KEY => :VALUE}],
    ]
    assert_equal(expected, called)
  end

=begin
  test "request_for_notice" do
    @expected.subject = 'ActivationMailer#request_for_notice'
    @expected.body    = read_fixture('request_for_notice')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ActivationMailer.create_request_for_notice(@expected.date).encoded
  end
=end
end
