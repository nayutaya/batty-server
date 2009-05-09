# -*- coding: utf-8 -*-

require 'test_helper'

class TokenUtilTest < ActiveSupport::TestCase
  def setup
    @mod = TokenUtil
  end

  test "create_token" do
    assert_match(/\A[0-9a-f]{10}\z/, @mod.create_token(10))
    assert_match(/\A[0-9a-f]{20}\z/, @mod.create_token(20))
    assert_match(/\A[0-9a-f]{30}\z/, @mod.create_token(30))

    # MEMO: 結果が乱数に依存するため、ごく稀にテストが失敗する可能性がある
    assert_not_equal(
      @mod.create_token(20),
      @mod.create_token(20))
  end

  test "create_unique_token" do
    assert_match(/\A[0-9a-f]{10}\z/, @mod.create_unique_token(User, :user_token, 10))
    assert_match(/\A[0-9a-f]{20}\z/, @mod.create_unique_token(User, :user_token, 20))
    assert_match(/\A[0-9a-f]{30}\z/, @mod.create_unique_token(User, :user_token, 30))

    # MEMO: 結果が乱数に依存するため、ごく稀にテストが失敗する可能性がある
    assert_not_equal(
      @mod.create_unique_token(User, :user_token, 20),
      @mod.create_unique_token(User, :user_token, 20))
  end

  test "create_unique_token, conflict" do
    [
     [Device, :device_token],
     [User,   :user_token],
    ].each { |klass, column|
      exist_token  = klass.first[column]
      unique_token = "0" * exist_token.size
      assert_equal(true,  klass.exists?(column => exist_token))
      assert_equal(false, klass.exists?(column => unique_token))

      tokens = [exist_token, unique_token]
      musha = Kagemusha.new(@mod)
      musha.defs(:create_token) { tokens.shift }
      musha.swap {
        assert_equal(
          unique_token,
          @mod.create_unique_token(klass, column, exist_token.size))
      }
    }
  end
end
