
require 'test_helper'

class EmailActionTest < ActiveSupport::TestCase
  def setup
    @klass = EmailAction
    @basic = @klass.new
  end

  #
  # 関連
  #

  test "belongs_to :trigger" do
    assert_equal(
      triggers(:yuya_pda_ge90),
      email_actions(:yuya_pda_ge90_1).trigger)

    assert_equal(
      triggers(:shinya_note_ne0),
      email_actions(:shinya_note_ne0_1).trigger)
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
end
