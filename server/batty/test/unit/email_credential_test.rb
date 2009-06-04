# -*- coding: utf-8 -*-

require 'test_helper'

class EmailCredentialTest < ActiveSupport::TestCase
  def setup
    @klass = EmailCredential
    @basic = @klass.new(
      :activation_token => "0" * 20,
      :user             => users(:yuya),
      :email            => "foo@example.com",
      :hashed_password  => ("0" * 8) + ":" + ("0" * 64))

    @yuya_gmail   = email_credentials(:yuya_gmail)
    @risa_example = email_credentials(:risa_example)
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

  test "validates_presence_of :activation_token" do
    @basic.activation_token = nil
    assert_equal(false, @basic.valid?)
    assert_equal(true, @basic.errors.invalid?(:activation_token))
  end

  test "validates_presence_of :hashed_password" do
    @basic.hashed_password = nil
    assert_equal(false, @basic.valid?)
    assert_equal(true, @basic.errors.invalid?(:hashed_password))
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
      ["0123456789abcdef0000", true,  false],
      ["0" * 19,               false, true ],
      ["0" * 20,               true,  false],
      ["0" * 21,               false, true ],
      ["0" * 19 + "A",         false, true ],
      ["0" * 19 + "g",         false, true ],
    ].each { |value, expected1, expected2|
      @basic.activation_token = value
      assert_equal(expected1, @basic.valid?, value)
      assert_equal(expected2, @basic.errors.invalid?(:activation_token), value)
    }
  end

  test "validates_format_of :hashed_password" do
    [
      # ソルト値部分
      ["01234567"  + ":" + "0" * 64, true ],
      ["89abcdef"  + ":" + "0" * 64, true ],
      ["0000000"   + ":" + "0" * 64, false],
      ["00000000"  + ":" + "0" * 64, true ],
      ["000000000" + ":" + "0" * 64, false],
      ["0000000A"  + ":" + "0" * 64, false],
      ["0000000g"  + ":" + "0" * 64, false],
      # ハッシュ値部分
      ["00000000" + ":" + "0123456789abcdef" + "0" * (64 - 16), true ],
      ["00000000" + ":" + "0" * (64 - 1),                       false],
      ["00000000" + ":" + "0" * 64,                             true ],
      ["00000000" + ":" + "0" * (64 + 1),                       false],
      ["00000000" + ":" + "0" * (64 - 1) + "A",                 false],
      ["00000000" + ":" + "0" * (64 - 1) + "g",                 false],
    ].each { |value, expected|
      @basic.hashed_password = value
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
      assert_equal(
        {:in => value, :out => expected},
        {:in => value, :out => @basic.valid?})
    }
  end

  test "validates_uniqueness_of :email, on create" do
    @basic.email = @yuya_gmail.email
    assert_equal(false, @basic.valid?)
  end

  test "validates_uniqueness_of :email, on update" do
    @yuya_gmail.email = @risa_example.email
    assert_equal(false, @yuya_gmail.valid?)
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
    dup_token1 = @yuya_gmail.activation_token
    dup_token2 = @risa_example.activation_token
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

  test "self.create_hashed_password" do
    assert_match(
      /\A[0-9a-f]{8}:[0-9a-f]{64}\z/,
      @klass.create_hashed_password("a"))

    # 異なるパスワードでは、異なる値になること
    assert_not_equal(
      @klass.create_hashed_password("a"),
      @klass.create_hashed_password("b"))

    # 同一のパスワードでも、異なる値になること
    assert_not_equal(
      @klass.create_hashed_password("a"),
      @klass.create_hashed_password("a"))
  end

  test "self.compare_hashed_password" do
    # ソルト、パスワードが一致
    assert_equal(
      true,
      @klass.compare_hashed_password(
        "password",
        "00000000:" + Digest::SHA256.hexdigest("00000000:password")))

    # ソルトが不一致、パスワードが一致
    assert_equal(
      false,
      @klass.compare_hashed_password(
        "password",
        "00000000:" + Digest::SHA256.hexdigest("11111111:password")))

    # ソルトが一致、パスワードが不一致
    assert_equal(
      false,
      @klass.compare_hashed_password(
        "password",
        "00000000:" + Digest::SHA256.hexdigest("00000000:PASSWORD")))
  end

  test "self.authenticate" do
    assert_equal(
      email_credentials(:yuya_gmail),
      @klass.authenticate(email_credentials(:yuya_gmail).email, "yuya_gmail"))

    assert_equal(
      nil,
      @klass.authenticate(email_credentials(:yuya_gmail).email, "YUYA_GMAIL"))

    assert_equal(
      nil,
      @klass.authenticate(nil, nil))
  end

  #
  # インスタンスメソッド
  #

  test "authenticated?" do
    assert_equal(true,  email_credentials(:yuya_gmail).authenticated?("yuya_gmail"))
    assert_equal(false, email_credentials(:yuya_gmail).authenticated?("YUYA_GMAIL"))
    assert_equal(false, email_credentials(:yuya_nayutaya).authenticated?("yuya_nayutaya"))
  end

  test "activated?" do
    assert_equal(true,  email_credentials(:yuya_gmail).activated?)
    assert_equal(false, email_credentials(:yuya_nayutaya).activated?)
  end

  test "activate!" do
    credential = email_credentials(:yuya_nayutaya)
    time = Time.local(2010, 1, 1)

    assert_equal(false, credential.activated?)
    assert_equal(true, Kagemusha::DateTime.at(time) { credential.activate! })
    credential.reload
    assert_equal(true, credential.activated?)
    assert_equal(time, credential.activated_at)
  end

  test "activate!, already activated" do
    credential = email_credentials(:yuya_gmail)
    time = credential.activated_at

    assert_equal(true, credential.activated?)
    assert_equal(false, credential.activate!)
    credential.reload
    assert_equal(true, credential.activated?)
    assert_equal(time, credential.activated_at)
  end
end
