
require 'test_helper'

class HttpActionExecutorTest < ActiveSupport::TestCase
  def setup
    @klass    = HttpActionExecutor
    @executor = @klass.new
    @musha    = Kagemusha.new(@klass)
  end

  #
  # 初期化
  #

  test "initialize" do
    executor = @klass.new(
      :url         => "http://example.jp/",
      :http_method => :get,
      :post_body   => "body")
    assert_equal("http://example.jp/", executor.instance_variable_get("@url"))
    assert_equal(:get,                 executor.instance_variable_get("@http_method"))
    assert_equal("body",               executor.instance_variable_get("@post_body"))
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
      [:url,         nil, "str", "str"],
      [:http_method, nil, :sym, :sym],
      [:post_body,   nil, "str", "str"],
    ].each { |name, default, set_value, get_value|
      executor = @klass.new
      assert_equal(default, executor.__send__(name), name)
      executor.__send__("#{name}=", set_value)
      assert_equal(get_value, executor.__send__(name), name)
    }
  end

  #
  # インスタンスメソッド
  #

  test "execute" do
    called = nil
    @musha.def(:execute_by_head) { called = :head }
    @musha.def(:execute_by_get)  { called = :get  }
    @musha.def(:execute_by_post) { called = :post }

    @executor.http_method = :head
    @musha.swap { @executor.execute }
    assert_equal(:head, called)

    @executor.http_method = :get
    @musha.swap { @executor.execute }
    assert_equal(:get, called)

    @executor.http_method = :post
    @musha.swap { @executor.execute }
    assert_equal(:post, called)

    @executor.http_method = :invalid
    assert_raise(RuntimeError) {
      @musha.swap { @executor.execute }
    }
  end
end
