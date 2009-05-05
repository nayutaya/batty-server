
require 'test_helper'

class EmailAddressTest < ActiveSupport::TestCase
  #
  # 関連
  #

  test "belongs to user" do
    assert_equal(
      users(:yuya),
      email_addresses(:yuya1).user)

    assert_equal(
      users(:shinya),
      email_addresses(:shinya1).user)
  end
end
