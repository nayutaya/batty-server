# -*- coding: utf-8 -*-

require 'test_helper'

class TriggerTest < ActiveSupport::TestCase
  def setup
    @klass = Trigger
    @basic = @klass.new(
      :device_id => devices(:yuya_pda).id,
      :operator  => 0,
      :level     => 0)
  end

  #
  # 関連
  #

  test "has_many :email_actions" do
    expected = [
      email_actions(:yuya_pda_ge90_1),
      email_actions(:yuya_pda_ge90_2),
    ]
    assert_equal(
      expected.sort_by(&:id),
      triggers(:yuya_pda_ge90).email_actions.all(:order => "email_actions.id ASC"))

    expected = [
      email_actions(:shinya_note_ne0_1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      triggers(:shinya_note_ne0).email_actions.all(:order => "email_actions.id ASC"))
  end

  test "belongs_to :device" do
    assert_equal(
      devices(:yuya_pda),
      triggers(:yuya_pda_ge90).device)

    assert_equal(
      devices(:shinya_note),
      triggers(:shinya_note_ne0).device)
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

  test "validates_presence_of :device_id" do
    @basic.device_id = nil
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
  # 名前付きスコープ
  #

  test "enabled" do
    assert_equal(true, @klass.count > @klass.enable.count)
    assert_equal(true, @klass.all.any? { |t| !t.enable? })
    assert_equal(true, @klass.enable.all.all? { |t| t.enable? })
  end

  #
  # クラスメソッド
  #

  test "self.operator_code_to_symbol" do
    assert_equal(:eq, @klass.operator_code_to_symbol(0))
    assert_equal(:ne, @klass.operator_code_to_symbol(1))
    assert_equal(:lt, @klass.operator_code_to_symbol(2))
    assert_equal(:le, @klass.operator_code_to_symbol(3))
    assert_equal(:gt, @klass.operator_code_to_symbol(4))
    assert_equal(:ge, @klass.operator_code_to_symbol(5))

    assert_equal(nil, @klass.operator_code_to_symbol(-1))
  end

  test "self.operator_code_to_sign" do
    assert_equal("＝", @klass.operator_code_to_sign(0))
    assert_equal("≠", @klass.operator_code_to_sign(1))
    assert_equal("＜", @klass.operator_code_to_sign(2))
    assert_equal("≦", @klass.operator_code_to_sign(3))
    assert_equal("＞", @klass.operator_code_to_sign(4))
    assert_equal("≧", @klass.operator_code_to_sign(5))

    assert_equal(nil, @klass.operator_code_to_sign(-1))
  end

  test "self.operator_code_to_description" do
    assert_equal("等しい",     @klass.operator_code_to_description(0))
    assert_equal("等しくない", @klass.operator_code_to_description(1))
    assert_equal("より小さい", @klass.operator_code_to_description(2))
    assert_equal("以下",       @klass.operator_code_to_description(3))
    assert_equal("より大きい", @klass.operator_code_to_description(4))
    assert_equal("以上",       @klass.operator_code_to_description(5))

    assert_equal(nil, @klass.operator_code_to_description(-1))
  end

  test "self.operator_symbol_to_code" do
    assert_equal(0, @klass.operator_symbol_to_code(:eq))
    assert_equal(1, @klass.operator_symbol_to_code(:ne))
    assert_equal(2, @klass.operator_symbol_to_code(:lt))
    assert_equal(3, @klass.operator_symbol_to_code(:le))
    assert_equal(4, @klass.operator_symbol_to_code(:gt))
    assert_equal(5, @klass.operator_symbol_to_code(:ge))

    assert_equal(nil, @klass.operator_symbol_to_code(:invalid))
  end

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
      [["", nil]] + items,
      @klass.operators_for_select(:include_blank => true))
    assert_equal(
      [["empty", nil]] + items,
      @klass.operators_for_select(:include_blank => true, :blank_label => "empty"))
  end

  test "self.operators_for_select, invalid parameter" do
    assert_raise(ArgumentError) {
      @klass.operators_for_select(:invalid => true)
    }
  end

  #
  # インスタンスメソッド
  #

  test "operator_symbol" do
    assert_equal(:ge, triggers(:yuya_pda_ge90).operator_symbol)
    assert_equal(:eq, triggers(:yuya_pda_eq100).operator_symbol)
  end

  test "operator_sign" do
    assert_equal("≧", triggers(:yuya_pda_ge90).operator_sign)
    assert_equal("＝", triggers(:yuya_pda_eq100).operator_sign)
  end

  test "match?, equal" do
    trigger = @klass.new(
      :operator => @klass.operator_symbol_to_code(:eq),
      :level    => 50)
    assert_equal(false, trigger.match?(49))
    assert_equal(true,  trigger.match?(50))
    assert_equal(false, trigger.match?(51))
  end

  test "match?, not equal" do
    trigger = @klass.new(
      :operator => @klass.operator_symbol_to_code(:ne),
      :level    => 50)
    assert_equal(true,  trigger.match?(49))
    assert_equal(false, trigger.match?(50))
    assert_equal(true,  trigger.match?(51))
  end

  test "match?, less then" do
    trigger = @klass.new(
      :operator => @klass.operator_symbol_to_code(:lt),
      :level    => 50)
    assert_equal(true,  trigger.match?(49))
    assert_equal(false, trigger.match?(50))
    assert_equal(false, trigger.match?(51))
  end

  test "match?, less or equal" do
    trigger = @klass.new(
      :operator => @klass.operator_symbol_to_code(:le),
      :level    => 50)
    assert_equal(true,  trigger.match?(49))
    assert_equal(true,  trigger.match?(50))
    assert_equal(false, trigger.match?(51))
  end

  test "match?, greater than" do
    trigger = @klass.new(
      :operator => @klass.operator_symbol_to_code(:gt),
      :level    => 50)
    assert_equal(false, trigger.match?(49))
    assert_equal(false, trigger.match?(50))
    assert_equal(true,  trigger.match?(51))
  end

  test "match?, greater or equal" do
    trigger = @klass.new(
      :operator => @klass.operator_symbol_to_code(:ge),
      :level    => 50)
    assert_equal(false, trigger.match?(49))
    assert_equal(true,  trigger.match?(50))
    assert_equal(true,  trigger.match?(51))
  end

  test "match?, invalid operator" do
    trigger = @klass.new(
      :operator => nil,
      :level    => 50)
    assert_equal(false, trigger.match?(50))
  end

  test "triggered?, equal" do
    trigger = @klass.new(
      :operator => @klass.operator_symbol_to_code(:eq),
      :level    => 0)
    assert_equal(false, trigger.triggered?(0, 0))
    assert_equal(true,  trigger.triggered?(0, 1))
    assert_equal(false, trigger.triggered?(1, 0))
    assert_equal(false, trigger.triggered?(1, 1))
  end

  test "triggered?, not equal" do
    trigger = @klass.new(
      :operator => @klass.operator_symbol_to_code(:ne),
      :level    => 0)
    assert_equal(false, trigger.triggered?(0, 0))
    assert_equal(false, trigger.triggered?(0, 1))
    assert_equal(true,  trigger.triggered?(1, 0))
    assert_equal(false, trigger.triggered?(1, 1))
  end

  test "to_event_hash" do
    expected = {
      :trigger_operator => nil,
      :trigger_level    => nil,
    }
    assert_equal(
      expected,
      @klass.new.to_event_hash)

    expected = {
      :trigger_operator => triggers(:yuya_pda_ge90).operator,
      :trigger_level    => triggers(:yuya_pda_ge90).level,
    }
    assert_equal(
      expected,
      triggers(:yuya_pda_ge90).to_event_hash)
  end
end
