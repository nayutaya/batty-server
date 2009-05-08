# -*- coding: utf-8 -*-

require 'test_helper'

class EmailCredentialTest < ActiveSupport::TestCase
  def setup
    @yuya_gmail   = email_credentials(:yuya_gmail)
    @risa_example = email_credentials(:risa_example)
    @klass = EmailCredential
    @basic = @klass.new(
      :activation_token => '0' * 20,
      :user             => users(:yuya),
      :email            => 'foo@example.com',
      :password         => 'password',
      :hashed_password  => 'hashed_password')
  end

  #
  # 関連
  #

  test "belongs_to :user" do
    assert_equal(
      users(:yuya),
      @yuya_gmail.user)

    assert_equal(
      users(:risa),
      @risa_example.user)
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

  test "validates_presence_of :email" do
    @basic.email = nil
    assert_equal(false, @basic.valid?)
    assert_equal(true, @basic.errors.invalid?(:email))
  end

  test "validates_length_of :email" do
    @basic.email = "#{'a' * 189}@example.com" # 201 文字
    assert_equal(false, @basic.valid?)
    assert_equal(true, @basic.errors.invalid?(:email))
  end

  test "validates_presence_of :activation_token" do
    @basic.activation_token = nil
    assert_equal(false, @basic.valid?)
    assert_equal(true, @basic.errors.invalid?(:activation_token))
  end

  test "validates_format_of :activation_token" do
    [
      ["0123456789abcdef0000", true , false],
      ["0" * 19,               false, true],
      ["0" * 20,               true , false],
      ["0" * 21,               false, true],
      ["0" * 19 + "A",         false, true],
      ["0" * 19 + "g",         false, true],
    ].each { |value, expected1, expected2|
      @basic.activation_token = value
      assert_equal(expected1, @basic.valid?, value)
      assert_equal(expected2, @basic.errors.invalid?(:activation_token), value)
    }
  end

  #
  # クラスメソッド
  #

  test "create_unique_activation_token" do
    tokens = [@yuya_gmail.activation_token, "b" * 20]
    musha = Kagemusha.new(TokenUtil)
    musha.defs(:create_token) { tokens.shift }
    musha.swap {
      assert_equal(
        "b" * 20,
        @klass.create_unique_activation_token)
    }
  end

end
