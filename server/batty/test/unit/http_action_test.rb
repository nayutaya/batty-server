
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

  test "belongs_to :trigger" do
    assert_equal(
      triggers(:yuya_pda_ge90),
      http_actions(:yuya_pda_ge90_1).trigger)

    assert_equal(
      triggers(:shinya_note_ne0),
      http_actions(:shinya_note_ne0_1).trigger)
  end

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

  #
  # 名前付きスコープ
  #

  test "named_scope :enable" do
    assert_equal(true,  (@klass.count > @klass.enable.count))
    assert_equal(false, @klass.all.all?(&:enable?))
    assert_equal(true,  @klass.enable.all.all?(&:enable?))
  end

  #
  # クラスメソッド
  #

  test "self.http_methods_for_select" do
    items = [
      ["HEAD", "HEAD"],
      ["GET",  "GET" ],
      ["POST", "POST"],
    ]

    assert_equal(
      items,
      @klass.http_methods_for_select)
    assert_equal(
      [["", nil]] + items,
      @klass.http_methods_for_select(:include_blank => true))
    assert_equal(
      [["empty", nil]] + items,
      @klass.http_methods_for_select(:include_blank => true, :blank_label => "empty"))
  end

  test "self.http_methods_for_select, invalid paramter" do
    assert_raise(ArgumentError) {
      @klass.http_methods_for_select(:invalid => true)
    }
  end
end
