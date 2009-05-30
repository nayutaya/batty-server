
require 'test_helper'

class EmailActionExecutorTest < ActiveSupport::TestCase
  def setup
    @klass    = EmailActionExecutor
    @executor = @klass.new
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

  #
  # クラスメソッド
  #

  test "self.from, empty" do
    executor = @klass.from(EmailAction.new)
    assert_equal(nil, executor.subject)
    assert_equal(nil, executor.recipients)
    assert_equal(nil, executor.body)
  end

  test "self.from, full" do
    email_action = EmailAction.new(
      :subject => "subject",
      :email   => "email",
      :body    => "body")
    executor = @klass.from(email_action)
    assert_equal("subject", executor.subject)
    assert_equal("email",   executor.recipients)
    assert_equal("body",    executor.body)
  end

  #
  # インスタンスメソッド
  #

  test "replace, empty" do
    executor = @executor.replace({})
    assert_equal(nil, executor.subject)
    assert_equal(nil, executor.recipients)
    assert_equal(nil, executor.body)
  end

  test "replace, full" do
    @executor.subject    = "{a}:subject"
    @executor.recipients = "{a}:recipients"
    @executor.body       = "{a}:body"
    executor = @executor.replace("a" => "A")
    assert_equal("A:subject",      executor.subject)
    assert_equal("{a}:recipients", executor.recipients)
    assert_equal("A:body",         executor.body)
  end

  test "execute" do
    subject    = @executor.subject    = "subject"
    recipients = @executor.recipients = "recipients"
    body       = @executor.body       = "body"

    called = false
    musha = Kagemusha.new(EventNotification)
    musha.defs(:deliver_notify) { |options|
      raise unless options[:subject]    == subject
      raise unless options[:recipients] == recipients
      raise unless options[:body]       == body
      called = true
    }

    result = musha.swap { @executor.execute }
    assert_equal(nil, result)

    assert_equal(true, called)
  end
end
