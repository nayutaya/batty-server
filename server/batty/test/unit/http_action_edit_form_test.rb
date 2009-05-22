
require 'test_helper'

class HttpActionEditFormTest < ActiveSupport::TestCase
  def setup
    @klass = HttpActionEditForm
    @form  = @klass.new
    @basic = @klass.new(
      :http_method => "GET",
      :url         => "http://example.jp/")
  end

  #
  # 基底クラス
  #

  test "superclass" do
    assert_equal(ActiveForm, @klass.superclass)
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:enable,      nil, "1", true ],
      [:enable,      nil, "0", false],
      [:http_method, nil, "1", "1"],
      [:url,         nil, "1", "1"],
      [:body,        nil, "1", "1"],
    ].each { |name, default, set_value, get_value|
      form = @klass.new
      assert_equal(default, form.__send__(name), name)
      form.__send__("#{name}=", set_value)
      assert_equal(get_value, form.__send__(name), name)
    }
  end

  #
  # 検証
  #

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :http_method" do
    @basic.http_method = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :url" do
    @basic.url = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_length_of :url" do
    [
      ["http://example.jp/",              18, true ],
      ["http://example.jp/" + "a" * 182, 200, true ],
      ["http://example.jp/" + "a" * 183, 201, false],
    ].each { |value, length, expected|
      assert_equal(length, value.size)
      @basic.url = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  test "validates_length_of :body" do
    [
      ["あ" *    1, true ],
      ["あ" * 1000, true ],
      ["あ" * 1001, false],
    ].each { |value, expected|
      @basic.body = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  test "validates_inclusion_of :http_method" do
    [
      ["HEAD",   true ],
      ["GET",    true ],
      ["POST",   true ],
      ["PUT",    false],
      ["DELETE", false],
    ].each { |value, expected|
      @basic.http_method = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  test "validates_format_of :identity_url" do
    [
     ["http://example.jp/foo",         true ],
     ["http://example.jp/{a:b}={c:d}", true ],
     ["https://example.jp/foo",        false],
     ["ftp://example.jp/foo",          false],
     ["HTTP://example.jp/foo",         false],
    ].each{|value, expected|
      @basic.url = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  #
  #　インスタンスメソッド
  #

  test "to_http_action_hash, empty" do
    expected = {
      :enable      => nil,
      :http_method => nil,
      :url         => nil,
      :body        => nil,
    }
    assert_equal(expected, @form.to_http_action_hash)
  end

  test "to_http_action_hash, full" do
    @form.attributes = {
      :enable      => true,
      :http_method => "a",
      :url         => "b",
      :body        => "c",
    }
    expected = {
      :enable      => true,
      :http_method => "a",
      :url         => "b",
      :body        => "c",
    }
    assert_equal(expected, @form.to_http_action_hash)
  end
end
