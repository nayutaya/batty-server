
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

  test "self.build_executors, no trigger" do
    assert_equal([], @klass.build_exectors(events(:yuya_cellular_ne50_1)))
  end

  test "self.build_executors, one email action" do
    time     = Time.local(2000, 1, 2, 3, 4, 5)
    event    = events(:yuya_pda_ge90_1)
    exectors = Kagemusha::DateTime.at(time) { @klass.build_exectors(event) }
    assert_equal(1, exectors.size)

    keywords = NoticeFormatter.format_event(event, time)
    exector0 = EmailActionExecutor.from(email_actions(:yuya_pda_ge90_1)).replace(keywords)
    assert_equal(exector0.to_hash, exectors[0].to_hash)
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

  test "to_hash, emtpy" do
    expected = {
      :subject    => nil,
      :recipients => nil,
      :body       => nil,
    }
    assert_equal(expected, @executor.to_hash)
  end

  test "to_hash, full" do
    @executor.subject    = "subject"
    @executor.recipients = "recipients"
    @executor.body       = "body"
    expected = {
      :subject    => "subject",
      :recipients => "recipients",
      :body       => "body",
    }
    assert_equal(expected, @executor.to_hash)
  end
end
