# -*- coding: utf-8 -*-

require 'test_helper'

class TokenUtilTest < ActiveSupport::TestCase

  def setup
    @mod = TokenUtil
  end

  test "create_token" do
    10.times do
      assert_match /\A[0-9a-f]{20}\z/, @mod.create_token(20)
    end
  end

  test "create_unique_token" do
    [
     [Device, 'device_token', devices(:yuya_pda).device_token],
     [User, 'user_token', users(:yuya).user_token]
    ].each do |klass, column, token|
      musha = Kagemusha.new(@mod)
      tokens = [token, 'b' * 20]
      musha.defs(:create_token){ tokens.shift }
      musha.swap{
        assert_equal('b'*20, @mod.create_unique_token(klass, column, 20))
      }
    end
  end

end
