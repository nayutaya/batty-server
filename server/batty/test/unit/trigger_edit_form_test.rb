
require 'test_helper'

class TriggerEditFormTest < ActiveSupport::TestCase
  def setup
    @klass = TriggerEditForm
    @form  = @klass.new
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

  #
  # クラスメソッド
  #

  test "self.opeartors_for_select" do
    items = [
      ["＝ 等しい",     0],
      ["≠ 等しくない", 1],
      ["＜ より小さい", 2],
      ["≦ 以下",       3],
      ["＞ より大きい", 4],
      ["≧ 以上",       5],
    ]

    assert_equal(
      items,
      @klass.operators_for_select)
    assert_equal(
      [["(選択してください)", nil]] + items,
      @klass.operators_for_select(:include_blank => true))
  end

  test "self.operators_for_select, invalid parameter" do
    assert_raise(ArgumentError) {
      @klass.operators_for_select(:invalid => true)
    }
  end

  #
  # インスタンスメソッド
  #

  test "to_trigger_hash, empty" do
    expected = {
      :enable   => nil,
      :operator => nil,
      :level    => nil,
    }
    assert_equal(expected, @form.to_trigger_hash)
  end

  test "to_trigger_hash, full" do
    @form.attributes = {
      :enable   => true,
      :operator => 0,
      :level    => 1,
    }
    expected = {
      :enable   => true,
      :operator => 0,
      :level    => 1,
    }
    assert_equal(expected, @form.to_trigger_hash)
  end
end
