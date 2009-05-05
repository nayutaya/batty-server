
require 'test_helper'

class EnergyTest < ActiveSupport::TestCase
  def setup
    @klass = Energy
    @basic = @klass.new(
      :observed_level => 0,
      :observed_at    => Time.local(2009, 1, 1))
  end

  #
  # 関連
  #

  test "belongs to device" do
    assert_equal(
      devices(:yuya_pda),
      energies(:yuya_pda1).device)

    assert_equal(
      devices(:shinya_note),
      energies(:shinya_note1).device)
  end

  #
  # 検証
  #

  test "all fixtures are valid" do
    assert_equal(true, @klass.all.all?(&:valid?))
  end

  test "validates_presence_of :observed_level" do
    @basic.observed_level = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :observed_at" do
    @basic.observed_at = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_inclusion_of :observed_level" do
    [
      [ -1, false],
      [  0, true ],
      [100, true ],
      [101, false],
    ].each { |value, expected|
      @basic.observed_level = value
      assert_equal(expected, @basic.valid?)
    }
  end

  #
  # インスタンスメソッド
  #

  test "to_event_hash" do
    expected = {
      :observed_level => nil,
      :observed_at    => nil,
    }
    assert_equal(
      expected,
      @klass.new.to_event_hash)

    expected = {
      :observed_level => energies(:yuya_pda1).observed_level,
      :observed_at    => energies(:yuya_pda1).observed_at,
    }
    assert_equal(
      expected,
      energies(:yuya_pda1).to_event_hash)
  end
end
