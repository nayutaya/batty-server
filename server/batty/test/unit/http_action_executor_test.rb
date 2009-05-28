
require 'test_helper'

class HttpActionExecutorTest < ActiveSupport::TestCase
  def setup
    @klass    = HttpActionExecutor
    @executor = @klass.new
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

  test "create_http_connector" do
    @executor.url = "http://example.jp/path?query"

    http = @executor.create_http_connector
    assert_equal("example.jp",        http.address)
    assert_equal(80,                  http.port)
    assert_equal(@klass::OpenTimeout, http.open_timeout)
    assert_equal(@klass::ReadTimeout, http.read_timeout)
  end

  test "execute, 200 OK" do
    @executor.url         = "http://example.jp/"
    @executor.http_method = :get

    musha = Kagemusha.new(Net::HTTP)
    musha.def(:start) { Net::HTTPOK.new("1.1", "200", "OK") }

    result = musha.swap { @executor.execute }
    assert_equal(true, result.success)
    assert_equal("200 OK", result.message)
  end

  test "execute, 201 Created" do
    @executor.url         = "http://example.jp/"
    @executor.http_method = :get

    musha = Kagemusha.new(Net::HTTP)
    musha.def(:start) { Net::HTTPCreated.new("1.1", "201", "Created") }

    result = musha.swap { @executor.execute }
    assert_equal(true, result.success)
    assert_equal("201 Created", result.message)
  end

  test "execute, 301 Moved Permanently" do
    @executor.url         = "http://example.jp/"
    @executor.http_method = :get

    musha = Kagemusha.new(Net::HTTP)
    musha.def(:start) { Net::HTTPMovedPermanently.new("1.1", "301", "Moved Permanently") }

    result = musha.swap { @executor.execute }
    assert_equal(false, result.success)
    assert_equal("301 Moved Permanently", result.message)
  end

  test "execute, timeout" do
    @executor.url         = "http://example.jp/"
    @executor.http_method = :get

    musha = Kagemusha.new(Net::HTTP)
    musha.def(:start) { raise(TimeoutError) }

    result = musha.swap { @executor.execute }
    assert_equal(false, result.success)
    assert_equal("timeout.", result.message)
  end

  test "execute, refused" do
    @executor.url         = "http://example.jp/"
    @executor.http_method = :get

    musha = Kagemusha.new(Net::HTTP)
    musha.def(:start) { raise(Errno::ECONNREFUSED) }

    result = musha.swap { @executor.execute }
    assert_equal(false, result.success)
    assert_equal("connection refused.", result.message)
  end

  test "execute, reset" do
    @executor.url         = "http://example.jp/"
    @executor.http_method = :get

    musha = Kagemusha.new(Net::HTTP)
    musha.def(:start) { raise(Errno::ECONNRESET) }

    result = musha.swap { @executor.execute }
    assert_equal(false, result.success)
    assert_equal("connection reset by peer.", result.message)
  end

  test "execute, socket error" do
    @executor.url         = "http://example.jp/"
    @executor.http_method = :get

    musha = Kagemusha.new(Net::HTTP)
    musha.def(:start) { raise(SocketError, "message.") }

    result = musha.swap { @executor.execute }
    assert_equal(false, result.success)
    assert_equal("SocketError: message.", result.message)
  end

  test "execute, runtime error" do
    @executor.url         = "http://example.jp/"
    @executor.http_method = :get

    musha = Kagemusha.new(Net::HTTP)
    musha.def(:start) { raise("message.") }

    result = musha.swap { @executor.execute }
    assert_equal(false, result.success)
    assert_equal("RuntimeError: message.", result.message)
  end

  # MEMO: 実際に外部へのアクセスを行う
  test "execute, head www.google.co.jp" do
    @executor.url         = "http://www.google.co.jp/"
    @executor.http_method = :head

    result = @executor.execute
    assert_equal(true, result.success)
    assert_equal("200 OK", result.message)
  end

  # MEMO: 実際に外部へのアクセスを行う
  test "execute, get www.google.co.jp" do
    @executor.url         = "http://www.google.co.jp/"
    @executor.http_method = :get

    result = @executor.execute
    assert_equal(true, result.success)
    assert_equal("200 OK", result.message)
  end

  # MEMO: 実際に外部へのアクセスを行う
  test "execute, post www.google.co.jp" do
    @executor.url         = "http://www.google.co.jp/"
    @executor.http_method = :post
    @executor.post_body   = ""

    result = @executor.execute
    assert_equal(false, result.success)
    assert_equal("405 Method Not Allowed", result.message)
  end
end
