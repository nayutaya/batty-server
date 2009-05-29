
require 'test_helper'

class EmailActionExecutorTest < ActiveSupport::TestCase
  def setup
    @klass = EmailActionExecutor
  end

  #
  # 初期化
  #

  test "initialize" do
    executor = @klass.new(
      :subject    => "subject",
      :recipients => "recipients",
      :body       => "body")
    assert_equal("subject",    executor.subject)
    assert_equal("recipients", executor.recipients)
    assert_equal("body",       executor.body)
  end

  test "initialize, invalid parameter" do
    assert_raise(ArgumentError) {
      @klass.new(:invalid => true)
    }
  end

  #
  # 属性
  #

  test "attributes" do
    [
      [:subject,    nil, "str", "str"],
      [:recipients, nil, "str", "str"],
      [:body,       nil, "str", "str"],
    ].each { |name, default, set_value, get_value|
      executor = @klass.new
      assert_equal(default, executor.__send__(name), name)
      executor.__send__("#{name}=", set_value)
      assert_equal(get_value, executor.__send__(name), name)
    }
  end
end
