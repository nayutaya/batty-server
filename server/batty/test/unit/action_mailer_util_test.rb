
require 'test_helper'

class ActionMailerUtilTest < ActiveSupport::TestCase
  def setup
    @module   = ActionMailerUtil
    @instance = Class.new.module_eval { include(ActionMailerUtil); self }.new
  end

  test "build_message" do
    time = Time.local(2010, 1, 1)
    options = {
      :subject    => "SUBJECT",
      :from       => "FROM",
      :recipients => "RECIPIENTS",
      :body       => {:KEY => :VALUE},
    }

    called = []
    musha = Kagemusha.new(@instance.class)
    musha.def(:subject)    { |value| called << [:subject,    value] }
    musha.def(:from)       { |value| called << [:from,       value] }
    musha.def(:recipients) { |value| called << [:recipients, value] }
    musha.def(:sent_on)    { |value| called << [:sent_on,    value] }
    musha.def(:body)       { |value| called << [:body,       value] }
    musha.swap {
      Kagemusha::DateTime.at(time) {
        assert_equal(nil, @instance.__send__(:build_message, options))
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
end
