# -*- coding: utf-8 -*-

require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  def setup
    @klass = Device
    @basic = @klass.new(
      :user         => users(:yuya),
      :name         => "name",
      :device_token => "0" * 20,
      :device_icon  => device_icons(:note))

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

  test "validates_presence_of :device_token" do
    @basic.device_token = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :user_id" do
    @basic.user_id = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :name" do
    @basic.name = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :device_icon_id" do
    @basic.device_icon_id = nil
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

  test "update_event, yuya_pad" do
    device = devices(:yuya_pda)

    # 該当するトリガあり、かつイベント生成済み
    assert_difference("Event.count", 0) {
      assert_equal([], device.update_event)
    }

    e1 = device.energies.create!(:observed_level => 80, :observed_at => Time.local(2009, 1, 4))

    # 該当するトリガなし
    assert_difference("Event.count", 0) {
      assert_equal([], device.update_event)
    }

    e2 = device.energies.create!(:observed_level => 90, :observed_at => Time.local(2009, 1, 5))

    # 該当するトリガあり、かつイベント未生成
    assert_difference("Event.count", +1) {
      events = device.update_event
      assert_equal(1, events.size)
      assert_equal(e2.device_id,      events[0].device_id)
      assert_equal(e2.observed_level, events[0].observed_level)
      assert_equal(e2.observed_at,    events[0].observed_at)
      assert_equal(triggers(:yuya_pda_ge90).operator, events[0].trigger_operator)
      assert_equal(triggers(:yuya_pda_ge90).level,    events[0].trigger_level)
    }
  end

  test "update_event, yuya_pad, multiple" do
    device = devices(:yuya_pda)

    e1 = device.energies.create!(:observed_level =>  80, :observed_at => Time.local(2009, 1, 4))
    e2 = device.energies.create!(:observed_level => 100, :observed_at => Time.local(2009, 1, 5))

    # 該当するトリガあり、かつイベント未生成
    assert_difference("Event.count", +2) {
      events = device.update_event
      assert_equal(2, events.size)
      assert_equal(e2.device_id,      events[0].device_id)
      assert_equal(e2.observed_level, events[0].observed_level)
      assert_equal(e2.observed_at,    events[0].observed_at)
      assert_equal(e2.device_id,      events[1].device_id)
      assert_equal(e2.observed_level, events[1].observed_level)
      assert_equal(e2.observed_at,    events[1].observed_at)
    }
  end

  test "update_event, shinya_note" do
    device = devices(:shinya_note)

    # 該当するトリガなし
    assert_difference("Event.count", 0) {
      assert_equal([], device.update_event)
    }

    e1 = device.energies.create!(:observed_level => 10, :observed_at => Time.local(2009, 1, 2))

    # 該当するトリガあり、かつイベント未生成
    assert_difference("Event.count", +1) {
      events = device.update_event
      assert_equal(1, events.size)
      assert_equal(e1.device_id,      events[0].device_id)
      assert_equal(e1.observed_level, events[0].observed_level)
      assert_equal(e1.observed_at,    events[0].observed_at)
      assert_equal(triggers(:shinya_note_ne0).operator, events[0].trigger_operator)
      assert_equal(triggers(:shinya_note_ne0).level,    events[0].trigger_level)
    }
  end

  test "update_energy" do
    device = devices(:yuya_pda)
    level  = 95
    time   = Time.local(2009, 1, 4)

    assert_difference("Energy.count", +1) {
      ret = device.update_energy(
        :observed_level => level,
        :observed_at    => time)
      assert_equal(nil, ret)
    }

    energy = Energy.first(:order => "energies.id DESC")
    assert_equal(device.id, energy.device_id)
    assert_equal(level,     energy.observed_level)
    assert_equal(time,      energy.observed_at)
  end

  test "update_energy, no update event" do
    device = devices(:yuya_pda)

    assert_difference("Event.count", 0) {
      assert_difference("Energy.count", +1) {
        device.update_energy(
          :observed_level => 80,
          :observed_at    => Time.local(2009, 1, 4),
          :update_event   => false)
      }
    }

    assert_difference("Event.count", 0) {
      assert_difference("Energy.count", +1) {
        device.update_energy(
          :observed_level => 90,
          :observed_at    => Time.local(2009, 1, 5),
          :update_event   => false)
      }
    }
  end

  test "update_energy, update event" do
    device = devices(:yuya_pda)

    assert_difference("Event.count", 0) {
      assert_difference("Energy.count", +1) {
        device.update_energy(
          :observed_level => 80,
          :observed_at    => Time.local(2009, 1, 4),
          :update_event   => true)
      }
    }

    assert_difference("Event.count", +1) {
      assert_difference("Energy.count", +1) {
        device.update_energy(
          :observed_level => 90,
          :observed_at    => Time.local(2009, 1, 5),
          :update_event   => true)
      }
    }
  end

  test "update_energy, invalid parameter" do
    assert_raise(ArgumentError) {
      devices(:yuya_pda).update_energy(:invalid => true)
    }
  end
end
