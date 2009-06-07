
require 'test_helper'

class EnergyTest < ActiveSupport::TestCase
  def setup
    @klass = Energy
    @basic = @klass.new(
      :observed_level => 0,
      :observed_at    => Time.local(2009, 1, 1))

    @yuya_pda1      = energies(:yuya_pda1)
    @yuya_pda2      = energies(:yuya_pda2)
    @yuya_cellular2 = energies(:yuya_cellular2)
    @shinya_note1   = energies(:shinya_note1)
  end

  #
  # 関連
  #

  test "has_many :events" do
    expected = [
      events(:yuya_pda_ge90_1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya_pda2.events.sort_by(&:id))

    expected = [
      events(:yuya_cellular_lt40_1),
      events(:yuya_cellular_ne50_1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya_cellular2.events.sort_by(&:id))
  end

  test "has_many :events, :dependent => :nullify" do
    assert_equal(@yuya_pda2.id, events(:yuya_pda_ge90_1).energy_id)
    assert_difference("Event.count", 0) {
      @yuya_pda2.destroy
    }
    assert_equal(nil, events(:yuya_pda_ge90_1).reload.energy_id)

    assert_equal(@yuya_cellular2.id, events(:yuya_cellular_lt40_1).energy_id)
    assert_difference("Event.count", 0) {
      @yuya_cellular2.destroy
    }
    assert_equal(nil, events(:yuya_cellular_lt40_1).reload.energy_id)
  end

  test "belongs_to :device" do
    assert_equal(
      devices(:yuya_pda),
      @yuya_pda1.device)

    assert_equal(
      devices(:shinya_note),
      @shinya_note1.device)
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
  # クラスメソッド
  #

  test "self.cleanup, limit 2" do
    device = devices(:yuya_pda)
    assert_difference("Energy.count", -1) {
      @klass.cleanup(device, 2)
    }
    expected = [
      energies(:yuya_pda3),
      energies(:yuya_pda2),
    ]
    assert_equal(
      expected,
      device.energies.all(:order => "energies.observed_at DESC, energies.id DESC"))
  end

  test "self.cleanup, limit 3" do
    device = devices(:yuya_pda)
    assert_difference("Energy.count", 0) {
      @klass.cleanup(device, 3)
    }
    expected = [
      energies(:yuya_pda3),
      energies(:yuya_pda2),
      energies(:yuya_pda1),
    ]
    assert_equal(
      expected,
      device.energies.all(:order => "energies.observed_at DESC, energies.id DESC"))
  end

  test "self.cleanup, limit 4" do
    device = devices(:yuya_pda)
    assert_difference("Energy.count", 0) {
      @klass.cleanup(device, 4)
    }
    expected = [
      energies(:yuya_pda3),
      energies(:yuya_pda2),
      energies(:yuya_pda1),
    ]
    assert_equal(
      expected,
      device.energies.all(:order => "energies.observed_at DESC, energies.id DESC"))
  end

  test "self.cleanup, invalid parameter" do
    assert_raise(ArgumentError) {
      @klass.cleanup(devices(:yuya_pda), 0)
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
      :observed_level => @yuya_pda1.observed_level,
      :observed_at    => @yuya_pda1.observed_at,
    }
    assert_equal(
      expected,
      @yuya_pda1.to_event_hash)
  end
end
