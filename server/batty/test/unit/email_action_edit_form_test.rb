
require 'test_helper'

class EmailActionEditFormTest < ActiveSupport::TestCase
  def setup
    @klass = EmailActionEditForm
    @form  = @klass.new
    @basic = @klass.new(
      :email   => "email@example.jp",
      :subject => "subject",
      :body    => "Body")
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
      [:enable,  nil, "1", true ],
      [:enable,  nil, "0", false],
      [:email,   nil, "1", "1"],
      [:subject, nil, "1", "1"],
      [:body,    nil, "1", "1"],
    ].each { |name, default, set_value, get_value|
      form = @klass.new
      assert_equal(default, form.__send__(name))
      form.__send__("#{name}=", set_value)
      assert_equal(get_value, form.__send__(name))
    }
  end

  #
  # 検証
  #

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :email" do
    @basic.email = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :subject" do
    @basic.subject = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :body" do
    @basic.body = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_length_of :email" do
    # MEMO: 下記の制約を満たしつつ、文字列長の検証のテストを行う
    #       * ローカルパートは64文字以内
    #       * ドメインパートは255文字以内
    #       * ドメインパートのドットで区切られたパートは63文字以内

    [
      ["a@b.c.d.com", 11, true ],
      [["a" * 64 + "@" + "b" * 63, "c" * 63, "d" * 3, "com"].join("."), 200, true ],
      [["a" * 64 + "@" + "b" * 63, "c" * 63, "d" * 4, "com"].join("."), 201, false],
    ].each { |value, length, expected|
      assert_equal(length, value.size)
      @basic.email = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  test "validates_length_of :subject" do
    [
      ["あ" *   1, true ],
      ["あ" * 200, true ],
      ["あ" * 201, false],
    ].each { |value, expected|
      @basic.subject = value
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

  test "validates_email_format_of :email" do
    [
      ["foo@example.com",   true ],
      ["foo@example.co.jp", true ],
      ["foo@example",       false],
    ].each { |value, expected|
      @basic.email = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  #
  # インスタンスメソッド
  #

  test "to_email_action_hash, empty" do
    expected = {
      :enable  => nil,
      :email   => nil,
      :subject => nil,
      :body    => nil,
    }
    assert_equal(expected, @form.to_email_action_hash)
  end

  test "to_email_action_hash, full" do
    @form.attributes = {
      :enable  => true,
      :email   => "a",
      :subject => "b",
      :body    => "c",
    }
    expected = {
      :enable  => true,
      :email   => "a",
      :subject => "b",
      :body    => "c",
    }
    assert_equal(expected, @form.to_email_action_hash)
  end
end
