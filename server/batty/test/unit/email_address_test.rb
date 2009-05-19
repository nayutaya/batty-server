
require 'test_helper'

class EmailAddressTest < ActiveSupport::TestCase
  def setup
    @klass  = EmailAddress
    @record = @klass.new
    @basic  = @klass.new(
      :activation_token => "0" * 20,
      :user_id          => users(:yuya).id,
      :email            => "email@example.jp")
  end

  #
  # 関連
  #

  test "belongs_to :user" do
    assert_equal(
      users(:yuya),
      email_addresses(:yuya1).user)

    assert_equal(
      users(:shinya),
      email_addresses(:shinya1).user)
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

  test "validates_presence_of :activation_token" do
    @basic.activation_token = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :user_id" do
    @basic.user_id = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :email" do
    @basic.email = nil
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

  test "validates_format_of :activation_token" do
    [
      ["0123456789abcdef0000", true ],
      ["0" * 19,               false],
      ["0" * 20,               true ],
      ["0" * 21,               false],
      ["0" * 19 + "A",         false],
      ["0" * 19 + "g",         false],
    ].each { |value, expected|
      @basic.activation_token = value
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
  # クラスメソッド
  #

  test "self.create_unique_activation_token, pattern" do
    assert_match(
      @klass::TokenPattern,
      @klass.create_unique_activation_token)
  end

  test "self.create_unique_activation_token, duplication" do
    dup_token1 = email_addresses(:yuya1).activation_token
    dup_token2 = email_addresses(:yuya2).activation_token
    uniq_token = "f" * @klass::TokenLength
    tokens = [dup_token1, dup_token2, uniq_token]

    musha = Kagemusha.new(TokenUtil)
    musha.defs(:create_token) { tokens.shift }
    musha.swap {
      assert_equal(
        uniq_token,
        @klass.create_unique_activation_token)
    }
  end

  #
  # インスタンスメソッド
  #

  test "activated?" do
    @record.activated_at = nil
    assert_equal(false, @record.activated?)

    @record.activated_at = Time.local(2009, 1, 1)
    assert_equal(true, @record.activated?)
  end

  test "activate!, no activated yet" do
    address = email_addresses(:yuya2)
    time = Time.local(2010, 1, 1)

    assert_equal(false, address.activated?)
    assert_equal(true,  Kagemusha::DateTime.at(time) { address.activate! })
    address.reload
    assert_equal(true,  address.activated?)
    assert_equal(time,  address.activated_at)
  end

  test "activate!, already activated" do
    address = email_addresses(:yuya1)
    time = address.activated_at

    assert_equal(true,  address.activated?)
    assert_equal(false, address.activate!)
    address.reload
    assert_equal(true,  address.activated?)
    assert_equal(time,  address.activated_at)
  end
end
