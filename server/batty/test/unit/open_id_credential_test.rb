
require 'test_helper'

class OpenIdCredentialTest < ActiveSupport::TestCase
  def setup
    @yuya_livedoor  = open_id_credentials(:yuya_livedoor)
    @shinya_example = open_id_credentials(:shinya_example)
  end

  #
  # 関連
  #

  test "belongs_to :user" do
    assert_equal(
      users(:yuya),
      @yuya_livedoor.user)

    assert_equal(
      users(:shinya),
      @shinya_example.user)
  end
end
