
require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @klass = Event
  end

  #
  # 関連
  #

  test "belongs to device" do
    assert_equal(
      devices(:yuya_pda),
      events(:yuya_pda_ge90_1).device)

    assert_equal(
      devices(:yuya_cellular),
      events(:yuya_cellular_lt40_1).device)
  end

  #
  # インスタンスメソッド
  #

  test "trigger_operator_symbol" do
    assert_equal(:ge, events(:yuya_pda_ge90_1).trigger_operator_symbol)
    assert_equal(:eq, events(:yuya_pda_eq100_1).trigger_operator_symbol)
  end

  test "trigger_operator_sign" do
    assert_equal("≧", events(:yuya_pda_ge90_1).trigger_operator_sign)
    assert_equal("＝", events(:yuya_pda_eq100_1).trigger_operator_sign)
  end
end
