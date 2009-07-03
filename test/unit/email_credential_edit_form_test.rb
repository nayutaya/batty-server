
require 'test_helper'

class EmailCredentialEditFormTest < ActiveSupport::TestCase
  def setup
    @klass = EmailCredentialEditForm
    @form  = @klass.new
    @basic = @klass.new(
      :email                 => "email@example.jp",
      :password              => "password",
      :password_confirmation => "password")
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
      [:email,                 nil, "str", "str"],
      [:password,              nil, "str", "str"],
      [:password_confirmation, nil, "str", "str"],
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

  test "validates_presence_of :password" do
    @basic.password = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :password_confirmation" do
    @basic.password_confirmation = nil
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
      assert_equal(expected, @basic.valid?)
    }
  end

  test "validates_length_of :password" do
    [
      ["a" *  3, false],
      ["a" *  4, true ],
      ["a" * 20, true ],
      ["a" * 21, false],
    ].each { |value, expected|
      @basic.password              = value
      @basic.password_confirmation = value
      assert_equal(expected, @basic.valid?)
    }
  end

  test "validates_format_of :password" do
    valid_chars = (0x21..0x7E).map { |c| c.chr }.join

    [
      [valid_chars.slice!(0, 20), true ],
      [valid_chars.slice!(0, 20), true ],
      [valid_chars.slice!(0, 20), true ],
      [valid_chars.slice!(0, 20), true ],
      [valid_chars.slice!(0, 20), true ],
      ["aaaa",   true ],
      ["aaa ",   false],
      ["日本語", false],
    ].each { |value, expected|
      @basic.password              = value
      @basic.password_confirmation = value
      assert_equal(expected, @basic.valid?)
    }

    assert_equal(true, valid_chars.empty?)
  end

  test "validates_email_format_of :email" do
    [
      ["foo@example.com",   true ],
      ["foo@example.co.jp", true ],
      ["foo@example",       false],
    ].each { |value, expected|
      @basic.email = value
      assert_equal(
        {:in => value, :out => expected},
        {:in => value, :out => @basic.valid?})
    }
  end

  test "validates_each, password" do
    @basic.password              = "aaaa"
    @basic.password_confirmation = "aaaa"
    assert_equal(true, @basic.valid?)

    @basic.password              = "aaaa"
    @basic.password_confirmation = "AAAA"
    assert_equal(false, @basic.valid?)
  end

  #
  # インスタンスメソッド
  #

  test "masked_password" do
    @form.password = nil
    assert_equal("", @form.masked_password)

    @form.password = "a"
    assert_equal("*", @form.masked_password)

    @form.password = "abc"
    assert_equal("***", @form.masked_password)
  end

  test "to_email_credential_hash, empty" do
    hash = @form.to_email_credential_hash
    assert_equal(
      [:email, :hashed_password].map(&:to_s).sort,
      hash.keys.map(&:to_s).sort)
    assert_equal(nil, hash[:email])
    assert_equal(true, EmailCredential.compare_hashed_password("", hash[:hashed_password]))
  end

  test "to_email_credential_hash, full" do
    @form.attributes = {
      :email    => "foo@example.com",
      :password => "foo",
    }
    hash = @form.to_email_credential_hash
    assert_equal(
      [:email, :hashed_password].map(&:to_s).sort,
      hash.keys.map(&:to_s).sort)
    assert_equal(@form.email, hash[:email])
    assert_equal(true, EmailCredential.compare_hashed_password(@form.password, hash[:hashed_password]))
  end
end
