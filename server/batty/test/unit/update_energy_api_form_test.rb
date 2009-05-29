
require 'test_helper'

class UpdateEnergyApiFormTest < ActiveSupport::TestCase
  def setup
    @klass = UpdateEnergyApiForm
    @basic = @klass.new(
      :level => "100",
      :time  => "20090101000000")
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
      [:level, nil, "1", 1],
      [:time,  nil, "1", 1],
    ].each { |name, default, set_value, get_value|
      form = @klass.new
      assert_equal(default, form.__send__(name), name)
      form.__send__("#{name}=", set_value)
      assert_equal(get_value, form.__send__(name), name)
    }
  end

  #
  # 検証
  #

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :level" do
    @basic.level = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :time" do
    @basic.time = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_numericality_of :level" do
    @basic.level = "x"
    assert_equal(false, @basic.valid?)

    @basic.level = "0.1"
    assert_equal(false, @basic.valid?)
  end

  test "validates_numericality_of :time" do
    @basic.time = "x"
    assert_equal(false, @basic.valid?)

    @basic.time = "0.1"
    assert_equal(false, @basic.valid?)
  end

  test "validates_inclusion_of :level" do
    [
      [ -1, false],
      [  0, true ],
      [100, true ],
      [101, false],
    ].each { |value, expected|
      @basic.level = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  test "validates_inclusion_of :time" do
    [
      [@klass::TimeMinimumValue - 1, false],
      [@klass::TimeMinimumValue,     true ],
      [@klass::TimeMaximumValue,     true ],
      [@klass::TimeMaximumValue + 1, false],
    ].each { |value, expected|
      @basic.time = value
      assert_equal(expected, @basic.valid?, value)
    }
  end
end
