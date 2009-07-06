
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
  # クラスメソッド
  #

  test "self.from, empty" do
    executor = @klass.from(HttpAction.new)
    assert_equal(nil, executor.url)
    assert_equal(nil, executor.http_method)
    assert_equal(nil, executor.post_body)
  end

  test "self.from, full" do
    http_action = HttpAction.new(
      :url         => "url",
      :http_method => "GET",
      :body        => "body")
    executor = @klass.from(http_action)
    assert_equal("url",  executor.url)
    assert_equal(:get,   executor.http_method)
    assert_equal("body", executor.post_body)
  end

  test "self.build_executors, no trigger" do
    assert_equal([], @klass.build_exectors(events(:yuya_cellular_ne50_1)))
  end

  test "self.build_executors, one http action" do
    time     = Time.local(2000, 1, 2, 3, 4, 5)
    event    = events(:yuya_pda_ge90_1)
    exectors = Kagemusha::DateTime.at(time) { @klass.build_exectors(event) }
    assert_equal(1, exectors.size)

    keywords = NoticeFormatter.format_event(event, time)
    exector0 = HttpActionExecutor.from(http_actions(:yuya_pda_ge90_1)).replace(keywords)
    assert_equal(exector0.to_hash, exectors[0].to_hash)
  end

  #
  # インスタンスメソッド
  #

  test "replace, empty" do
    executor = @executor.replace({})
    assert_equal(nil, executor.url)
    assert_equal(nil, executor.http_method)
    assert_equal(nil, executor.post_body)
  end

  test "replace, full" do
    @executor.url         = "{a}:url"
    @executor.http_method = :get
    @executor.post_body   = "{a}:body"
    executor = @executor.replace("a" => "A")
    assert_equal("A:url",  executor.url)
    assert_equal(:get,     executor.http_method)
    assert_equal("A:body", executor.post_body)
  end

  # MEMO: 実際に外部へのアクセスを行う
  test "execute, head www.google.co.jp" do
    @executor.url         = "http://www.google.co.jp/"
    @executor.http_method = :head

    assert_equal(
      {:success => true, :message => "200 OK"},
      @executor.execute)
  end

  # MEMO: 実際に外部へのアクセスを行う
  test "execute, get www.google.co.jp" do
    @executor.url         = "http://www.google.co.jp/"
    @executor.http_method = :get

    assert_equal(
      {:success => true, :message => "200 OK"},
      @executor.execute)
  end

  # MEMO: 実際に外部へのアクセスを行う
  test "execute, post www.google.co.jp" do
    @executor.url         = "http://www.google.co.jp/"
    @executor.http_method = :post
    @executor.post_body   = ""

    assert_equal(
      {:success => false, :message => "405 Method Not Allowed"},
      @executor.execute)
  end

  test "execute, host not allowed" do
    @executor.url         = "http://localhost/"
    @executor.http_method = :get

    assert_equal(
      {:success => false, :message => "denied."},
      @executor.execute)
  end

  test "execute, invalid http method" do
    @executor.url         = "http://www.google.co.jp/"
    @executor.http_method = :invalid

    assert_raise(RuntimeError) {
      @executor.execute
    }
  end

  test "to_hash, empty" do
    expected = {
      :url         => nil,
      :http_method => nil,
      :post_body   => nil,
    }
    assert_equal(expected, @executor.to_hash)
  end

  test "to_hash, full" do
    @executor.url         = "url"
    @executor.http_method = :method
    @executor.post_body   = "post_body"
    expected = {
      :url         => "url",
      :http_method => :method,
      :post_body   => "post_body",
    }
    assert_equal(expected, @executor.to_hash)
  end
end
