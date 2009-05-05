# -*- coding: utf-8 -*-

require 'test_helper'

class TriggerTest < ActiveSupport::TestCase
  def setup
    @klass = Trigger
  end

  #
  # 関連
  #

  test "belongs_to device" do
    assert_equal(
      devices(:yuya_pda),
      triggers(:yuya_pda_ge90).device)

    assert_equal(
      devices(:shinya_note),
      triggers(:shinya_note_ne0).device)
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

    assert_equal(nil, @klass.operator_code_to_symbol(-1))
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

  #
  # named_scope
  #

  test "enabled" do
    assert Trigger.count > Trigger.enable.count
    assert Trigger.find(:all).any?{|v| !v.enable? }
    assert Trigger.enable.all?{|v| v.enable? }
  end
end
