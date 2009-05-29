
require 'test_helper'

class UpdateEnergyApiFormTest < ActiveSupport::TestCase
  def setup
    @klass = UpdateEnergyApiForm
    @form  = @klass.new
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

  test "validates_each : time" do
    [
      [20000102_030405, true ],
      [20000101_000000, true ],
      [20001231_235959, true ],
      [20009999_000000, false],
      [20000101_999999, false],
      [20090229_000000, false],
    ].each { |value, expected|
      @basic.time = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  #
  # クラスメソッド
  #

  test "self.from" do
    form = @klass.from(:level => "0", :time => "20090101000000")
    assert_equal(0, form.level)
    assert_equal(Time.local(2009, 1, 1, 0, 0, 0), form.parsed_time)

    time = Time.local(2010, 1, 1, 0, 0, 0)
    form = Kagemusha::DateTime.at(time) { @klass.from(:level => "50") }
    assert_equal(50, form.level)
    assert_equal(time, form.parsed_time)

    time = Time.local(2010, 1, 1, 0, 0, 0)
    form = Kagemusha::DateTime.at(time) { @klass.from({}) }
    assert_equal(nil, form.level)
    assert_equal(time, form.parsed_time)
  end

  #
  # インスタンスメソッド
  #

  test "parsed_time" do
    [
      [20000102_030405, Time.local(2000,  1,  2,  3,  4,  5)],
      [20000101_000000, Time.local(2000,  1,  1,  0,  0,  0)],
      [20001231_235959, Time.local(2000, 12, 31, 23, 59, 59)],
      [20009999_000000, nil],
      [20000101_999999, nil],
      [20090229_000000, nil],
    ].each { |value, expected|
      @form.time = value
      assert_equal(expected, @form.parsed_time, value)
    }
  end

  test "to_energy_hash, empty" do
    expected = {
      :observed_level => nil,
      :observed_at    => nil,
    }
    assert_equal(expected, @form.to_energy_hash)
  end

  test "to_energy_hash, full" do
    @form.attributes = {
      :level => 1,
      :time  => 20000102_030405,
    }
    expected = {
      :observed_level => 1,
      :observed_at    => Time.local(2000, 1, 2, 3, 4, 5),
    }
    assert_equal(expected, @form.to_energy_hash)
  end
end
