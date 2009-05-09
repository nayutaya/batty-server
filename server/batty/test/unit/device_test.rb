# -*- coding: utf-8 -*-

require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  def setup
    @klass = Device
    @basic = @klass.new(
      :user_id        => users(:yuya).id,
      :name           => "name",
      :device_token   => "0" * 20,
      :device_icon_id => device_icons(:note).id)

    @yuya_pda      = devices(:yuya_pda)
    @yuya_cellular = devices(:yuya_cellular)
    @shinya_note   = devices(:shinya_note)
  end

  #
  # 関連
  #

  test "has_many :energies" do
    expected = [
      energies(:yuya_pda1),
      energies(:yuya_pda2),
      energies(:yuya_pda3),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya_pda.energies.all(:order => "energies.id ASC"))

    expected = [
      energies(:shinya_note1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @shinya_note.energies.all(:order => "energies.id ASC"))
  end

  test "has_many :triggers" do
    expected = [
      triggers(:yuya_pda_ge90),
      triggers(:yuya_pda_eq100),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya_pda.triggers.all(:order => "triggers.id ASC"))

    expected = [
      triggers(:shinya_note_ne0),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @shinya_note.triggers.all(:order => "triggers.id ASC"))
  end

  test "has_many :events" do
    expected = [
      events(:yuya_pda_ge90_1),
      events(:yuya_pda_eq100_1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya_pda.events.all(:order => "events.id ASC"))

    expected = [
      events(:yuya_cellular_lt40_1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya_cellular.events.all(:order => "events.id ASC"))
  end

  test "belongs_to :user" do
    assert_equal(
      users(:yuya),
      @yuya_pda.user)

    assert_equal(
      users(:shinya),
      @shinya_note.user)
  end

  test "belongs_to :device_icon" do
    assert_equal(
      device_icons(:pda),
      @yuya_pda.device_icon)

    assert_equal(
      device_icons(:note),
      @shinya_note.device_icon)
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

  test "validates_presence_of :name" do
    @basic.name = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :device_token" do
    @basic.device_token = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_length_of :name" do
    [
      ["あ" *  1, true ],
      ["あ" * 50, true ],
      ["あ" * 51, false],
    ].each { |value, expected|
      @basic.name = value
      assert_equal(expected, @basic.valid?)
    }
  end

  test "validates_format_of :device_token" do
    [
      ["0123456789abcdef0000", true ],
      ["0" * 19,               false],
      ["0" * 20,               true ],
      ["0" * 21,               false],
      ["0" * 19 + "A",         false],
      ["0" * 19 + "g",         false],
    ].each { |value, expected|
      @basic.device_token = value
      assert_equal(expected, @basic.valid?)
    }
  end

  #
  # クラスメソッド
  #

  test "create_unique_device_token" do
    tokens = [devices(:yuya_pda).device_token, "b" * 20]
    musha = Kagemusha.new(TokenUtil)
    musha.defs(:create_token) { tokens.shift }
    musha.swap {
      assert_equal(
        "b" * 20,
        @klass.create_unique_device_token)
    }
  end

  #
  # インスタンスメソッド
  #

  test "current_energy" do
    assert_equal(
      energies(:yuya_pda3),
      devices(:yuya_pda).current_energy)

    assert_equal(
      energies(:yuya_cellular2),
      devices(:yuya_cellular).current_energy)
  end

  test "current_energy, no records" do
    assert_equal(nil, devices(:shinya_cellular).current_energy)
  end

  test "energies_for_trigger, from 3 energy records" do
    expected = [
      energies(:yuya_pda3),
      energies(:yuya_pda2),
    ]
    assert_equal(expected, devices(:yuya_pda).energies_for_trigger)
  end

  test "energies_for_trigger, from 1 energy record" do
    expected = [
      energies(:shinya_note1),
    ]
    assert_equal(expected, devices(:shinya_note).energies_for_trigger)
  end

  test "energies_for_trigger, from no energy records" do
    expected = []
    assert_equal(expected, devices(:shinya_cellular).energies_for_trigger)
  end

  test "active_triggers, no energy levels" do
    assert_equal(
      [],
      devices(:yuya_pda).active_triggers([]))
  end

  test "active_triggers, one energy level" do
    assert_equal(
      [],
      devices(:yuya_pda).active_triggers([0]))
  end

  test "active_triggers, >=90 and ==100" do
    expected = [
      triggers(:yuya_pda_ge90),
      triggers(:yuya_pda_eq100),
    ]
    assert_equal(
      expected.sort_by(&:id),
      devices(:yuya_pda).active_triggers([100, 0]))
  end

  test "active_triggers, >=90" do
    expected = [
      triggers(:yuya_pda_ge90),
    ]
    assert_equal(
      expected.sort_by(&:id),
      devices(:yuya_pda).active_triggers([90, 80]))
  end

  test "active_triggers, without disable trigger" do
    assert_equal(
      [],
      devices(:shinya_cellular).active_triggers([100, 0]))
  end

  test "update_energy" do
    level = 95
    time  = Time.local(2009, 1, 4)

    assert_difference("Energy.count", +1) {
      devices(:yuya_pda).update_energy(level, time)
    }

    energy = Energy.first(:order => "energies.id DESC")
    assert_equal(level, energy.observed_level)
    assert_equal(time,  energy.observed_at)
  end

  test "update_event" do
    assert_difference("Event.count", +1) {
      devices(:yuya_pda).update_event
    }
  end
end
