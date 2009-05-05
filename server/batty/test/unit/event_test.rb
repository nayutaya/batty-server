
require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @klass = Event
    @basic = @klass.new(
      :device_id        => devices(:yuya_pda),
      :trigger_operator => 0,
      :trigger_level    => 0,
      :observed_level   => 0,
      :observed_at      => Time.local(2009, 1, 1))
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
  # 検証
  #

  # FIXME: all fixtures

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :device_id" do
    @basic.device_id = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :trigger_operator" do
    @basic.trigger_operator = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :trigger_level" do
    @basic.trigger_level = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :observed_level" do
    @basic.observed_level = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :observed_at" do
    @basic.observed_at = nil
    assert_equal(false, @basic.valid?)
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
