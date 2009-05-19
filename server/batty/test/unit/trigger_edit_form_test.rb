
require 'test_helper'

class TriggerEditFormTest < ActiveSupport::TestCase
  def setup
    @klass = TriggerEditForm
    @basic = @klass.new(
      :enable   => true,
      :operator => Trigger.operator_symbol_to_code(:eq),
      :level    => 0)
  end

  #
  # 基底クラス
  #

  test "superclass" do
    assert_equal(ActiveForm, @klass.superclass)
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:enable,   nil, "1", true ],
      [:enable,   nil, "0", false],
      [:operator, nil, "1", 1],
      [:level,    nil, "1", 1],
    ].each { |name, default, set_value, get_value|
      form = @klass.new
      assert_equal(default, form.__send__(name))
      form.__send__("#{name}=", set_value)
      assert_equal(get_value, form.__send__(name))
    }
  end

  #
  # 検証
  #

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :enable" do
    @basic.enable = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :operator" do
    @basic.operator = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :level" do
    @basic.level = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_inclusion_of :operator" do
    [
      [-1, false],
      [ 0, true ],
      [ 5, true ],
      [ 6, false],
    ].each { |value, expected|
      @basic.operator = value
      assert_equal(expected, @basic.valid?)
    }
  end

  test "validates_inclusion_of :level" do
    [
      [ -1, false],
      [  0, true ],
      [100, true ],
      [101, false],
    ].each { |value, expected|
      @basic.level = value
      assert_equal(expected, @basic.valid?)
    }
  end
end
