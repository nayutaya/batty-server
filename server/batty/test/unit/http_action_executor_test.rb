
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

  test "create_http_request, head" do
    @executor.url         = "http://example.jp/head?query"
    @executor.http_method = :head
    @executor.post_body   = "body"

    request = @executor.create_http_request
    assert_equal("HEAD",            request.method)
    assert_equal("/head?query",     request.path)
    assert_equal(nil,               request.body)
    assert_equal(@klass::UserAgent, request["User-Agent"])
  end

  test "create_http_request, get" do
    @executor.url         = "http://example.jp/get?query"
    @executor.http_method = :get
    @executor.post_body   = "body"

    request = @executor.create_http_request
    assert_equal("GET",             request.method)
    assert_equal("/get?query",      request.path)
    assert_equal(nil,               request.body)
    assert_equal(@klass::UserAgent, request["User-Agent"])
  end

  test "create_http_request, post" do
    @executor.url         = "http://example.jp/post?query"
    @executor.http_method = :post
    @executor.post_body   = "body"

    request = @executor.create_http_request
    assert_equal("POST",            request.method)
    assert_equal("/post?query",     request.path)
    assert_equal("body",            request.body)
    assert_equal(@klass::UserAgent, request["User-Agent"])
  end

  test "create_http_request, invalid" do
    @executor.http_method = :invalid

    assert_raise(RuntimeError) {
      @executor.create_http_request
    }
  end

=begin
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

  test "execute_by_head, parameter" do
    called = false
    url    = "http://example.jp/head"

    @executor.url         = url
    @executor.http_method = :head

    @musha.def(:execute_by_head) { |_url|
      raise unless _url == url
      called = true
    }
    assert_nothing_raised {
      @musha.swap { @executor.execute }
    }
    assert_equal(true, called)
  end

  test "execute_by_get, parameter" do
    called = false
    url    = "http://example.jp/get"

    @executor.url         = url
    @executor.http_method = :get

    @musha.def(:execute_by_get) { |_url|
      raise unless _url == url
      called = true
    }
    assert_nothing_raised {
      @musha.swap { @executor.execute }
    }
    assert_equal(true, called)
  end

  test "execute_by_post, parameter" do
    called = false
    url    = "http://example.jp/post"
    body   = "sending data"

    @executor.url         = url
    @executor.http_method = :post
    @executor.post_body   = body

    @musha.def(:execute_by_post) { |_url, _body|
      raise unless _url  == url
      raise unless _body == body
      called = true
    }
    assert_nothing_raised {
      @musha.swap { @executor.execute }
    }
    assert_equal(true, called)
  end
=end
end
