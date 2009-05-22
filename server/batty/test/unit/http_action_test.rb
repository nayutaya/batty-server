
require 'test_helper'

class HttpActionTest < ActiveSupport::TestCase
  def setup
    @klass = HttpAction
    @basic = @klass.new(
      :trigger_id  => triggers(:yuya_pda_ge90).id,
      :http_method => "GET",
      :url         => "http://example.jp/")
  end

  #
  # 関連
  #

  # TODO: 実装せよ

  #
  # 検証
  #

  test "all fixtures are valid" do
    assert_equal(true, @klass.all.all?(&:valid?))
  end

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :trigger_id" do
    @basic.trigger_id = nil
    assert_equal(false, @basic.valid?)
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
end
