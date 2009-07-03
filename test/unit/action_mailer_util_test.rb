
require 'test_helper'

class ActionMailerUtilTest < ActiveSupport::TestCase
  def setup
    @module   = ActionMailerUtil
    @instance = Class.new.module_eval { include(ActionMailerUtil); self }.new
    @musha    = Kagemusha.new(@instance.class)
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
    @musha.def(:sent_on)    { |value| called << [:sent_on,    value] }
    @musha.def(:subject)    { |value| called << [:subject,    value] }
    @musha.def(:from)       { |value| called << [:from,       value] }
    @musha.def(:recipients) { |value| called << [:recipients, value] }
    @musha.def(:body)       { |value| called << [:body,       value] }
    @musha.swap {
      Kagemusha::DateTime.at(time) {
        assert_equal(nil, @instance.__send__(:build_message, options))
      }
    }

    expected = [
      [:sent_on,    time],
      [:subject,    "SUBJECT"],
      [:from,       "FROM"],
      [:recipients, "RECIPIENTS"],
      [:body,       {:KEY => :VALUE}],
    ]
    assert_equal(expected, called)
  end

  test "build_message, deficient parameter" do
    options = {
      :subject    => "SUBJECT",
      :from       => "FROM",
      :recipients => "RECIPIENTS",
      :body       => {:KEY => :VALUE},
    }

    @musha.def(:sent_on)    { }
    @musha.def(:subject)    { }
    @musha.def(:from)       { }
    @musha.def(:recipients) { }
    @musha.def(:body)       { }
    @musha.swap {
      assert_nothing_raised       { @instance.__send__(:build_message, options) }
      assert_raise(ArgumentError) { @instance.__send__(:build_message, options.merge(:subject => nil)) }
      assert_raise(ArgumentError) { @instance.__send__(:build_message, options.merge(:from => nil)) }
      assert_raise(ArgumentError) { @instance.__send__(:build_message, options.merge(:recipients => nil)) }
      assert_raise(ArgumentError) { @instance.__send__(:build_message, options.merge(:body => nil)) }
    }
  end
end
