# -*- coding: utf-8 -*-

require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  def setup
    @klass = Device
    @basic = @klass.new(
      :user_id        => users(:yuya).id,
      :name           => "name",
      :device_token   => "0" * @klass::TokenLength,
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

  test "has_many :energies, :dependent => :destroy" do
    assert_difference("Energy.count", -@yuya_pda.energies.size) {
      @yuya_pda.destroy
    }

    assert_difference("Energy.count", -@shinya_note.energies.size) {
      @shinya_note.destroy
    }
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

  test "has_many :triggers, :dependent => :destroy" do
    assert_difference("Trigger.count", -@yuya_pda.triggers.size) {
      @yuya_pda.destroy
    }

    assert_difference("Trigger.count", -@shinya_note.triggers.size) {
      @shinya_note.destroy
    }
  end

  test "has_many :email_actions, :through => :triggers" do
    expected = [
      email_actions(:yuya_pda_ge90_1),
      email_actions(:yuya_pda_ge90_2),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya_pda.email_actions.all.sort_by(&:id))

    expected = [
      email_actions(:shinya_note_ne0_1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @shinya_note.email_actions.all.sort_by(&:id))
  end

  test "has_many :http_actions, :through => :triggers" do
    expected = [
      http_actions(:yuya_pda_ge90_1),
      http_actions(:yuya_pda_ge90_2),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya_pda.http_actions.all.sort_by(&:id))

    expected = [
      http_actions(:shinya_note_ne0_1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @shinya_note.http_actions.all.sort_by(&:id))
  end

  test "has_many :events" do
    expected = [
      events(:yuya_pda_ge90_1),
      events(:yuya_pda_eq100_1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya_pda.events.all.sort_by(&:id))

    expected = [
      events(:yuya_cellular_lt40_1),
      events(:yuya_cellular_ne50_1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya_cellular.events.all.sort_by(&:id))
  end

  test "has_many :events, :dependent => :destroy" do
    assert_difference("Event.count", -@yuya_pda.events.size) {
      @yuya_pda.destroy
    }

    assert_difference("Event.count", -@shinya_note.events.size) {
      @shinya_note.destroy
    }
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

=begin MEMO: before_validation_on_createによりテスト不可
  test "validates_presence_of :device_token" do
    @basic.device_token = ""
    assert_equal(false, @basic.valid?)
  end
=end

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

  test "validates_each :user_id" do
    user = users(:yuya)
    create_record = proc {
      user.devices.create!(
        :name           => "name",
        :device_token   => Device.create_unique_device_token,
        :device_icon_id => device_icons(:note).id)
    }

    assert_nothing_raised {
      (10 - user.devices.size).times {
        record = create_record[]
        record.save!
      }
    }
    assert_raise(ActiveRecord::RecordInvalid) {
      create_record[]
    }
  end

  #
  # フック
  #

  test "before_validation_on_create, nil" do
    token = "9" * @klass::TokenLength

    record = @klass.new(@basic.attributes)
    record.device_token = nil

    Kagemusha.new(@klass).
      defs(:create_unique_device_token) { token }.
      swap {
        record.save!
      }

    assert_equal(token, record.reload.device_token)
  end

  test "before_validation_on_create, empty string" do
    token = "9" * @klass::TokenLength

    record = @klass.new(@basic.attributes)
    record.device_token = ""

    Kagemusha.new(@klass).
      defs(:create_unique_device_token) { token }.
      swap {
        record.save!
      }

    assert_equal(token, record.reload.device_token)
  end

  test "before_validation_on_create, already setting" do
    token = "9" * @klass::TokenLength

    record = @klass.new(@basic.attributes)
    record.device_token = token
    record.save!

    assert_equal(token, record.reload.device_token)
  end

  #
  # クラスメソッド
  #

  test "create_unique_device_token, pattern" do
    assert_match(
      @klass::TokenPattern,
      @klass.create_unique_device_token)
  end

  test "create_unique_device_token, duplication" do
    dup_token1 = @yuya_pda.device_token
    dup_token2 = @shinya_note.device_token
    uniq_token = "f" * @klass::TokenLength
    tokens = [dup_token1, dup_token2, uniq_token]

    musha = Kagemusha.new(TokenUtil)
    musha.defs(:create_token) { tokens.shift }
    musha.swap {
      assert_equal(
        uniq_token,
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

  test "current_two_energies, from 3 energy records" do
    expected = [
      energies(:yuya_pda3),
      energies(:yuya_pda2),
    ]
    assert_equal(expected, devices(:yuya_pda).current_two_energies)
  end

  test "current_two_energies, from 1 energy record" do
    expected = [
      energies(:shinya_note1),
    ]
    assert_equal(expected, devices(:shinya_note).current_two_energies)
  end

  test "current_two_energies, from no energy records" do
    expected = []
    assert_equal(expected, devices(:shinya_cellular).current_two_energies)
  end

  test "fired_triggers, no energy levels" do
    assert_equal([], devices(:yuya_pda).fired_triggers(nil, nil))
    assert_equal([], devices(:yuya_pda).fired_triggers(0, nil))
    assert_equal([], devices(:yuya_pda).fired_triggers(nil, 0))
  end

  test "fired_triggers, >=90 and ==100" do
    expected = [
      triggers(:yuya_pda_ge90),
      triggers(:yuya_pda_eq100),
    ]
    assert_equal(
      expected.sort_by(&:id),
      devices(:yuya_pda).fired_triggers(100, 0))
  end

  test "fired_triggers, >=90" do
    expected = [
      triggers(:yuya_pda_ge90),
    ]
    assert_equal(
      expected.sort_by(&:id),
      devices(:yuya_pda).fired_triggers(90, 80))
  end

  test "fired_triggers, without disable trigger" do
    assert_equal(
      [],
      devices(:shinya_cellular).fired_triggers(100, 0))
  end

  test "build_events, yuya_pad" do
    device = devices(:yuya_pda)

    # 該当するトリガあり、かつイベント生成済み
    assert_equal([], device.build_events)

    # 該当するトリガなし
    e1 = device.energies.create!(:observed_level => 80, :observed_at => Time.local(2009, 1, 4))
    assert_equal([], device.build_events)

    # 該当するトリガあり、かつイベント未生成
    t2 = triggers(:yuya_pda_ge90)
    e2 = device.energies.create!(:observed_level => 90, :observed_at => Time.local(2009, 1, 5))
    events = device.build_events
    assert_equal(1, events.size)

    assert_equal(device.id,         events[0].device_id)
    assert_equal(t2.id,             events[0].trigger_id)
    assert_equal(t2.operator,       events[0].trigger_operator)
    assert_equal(t2.level,          events[0].trigger_level)
    assert_equal(e2.id,             events[0].energy_id)
    assert_equal(e2.observed_level, events[0].observed_level)
    assert_equal(e2.observed_at,    events[0].observed_at)
  end

  test "build_events, yuya_pad, multiple" do
    device = devices(:yuya_pda)

    # 該当するトリガあり、かつイベント未生成
    t2a, t2b = [triggers(:yuya_pda_ge90), triggers(:yuya_pda_eq100)].sort_by(&:id)
    e1 = device.energies.create!(:observed_level =>  80, :observed_at => Time.local(2009, 1, 4))
    e2 = device.energies.create!(:observed_level => 100, :observed_at => Time.local(2009, 1, 5))
    events = device.build_events
    assert_equal(2, events.size)

    assert_equal(device.id,         events[0].device_id)
    assert_equal(t2a.id,            events[0].trigger_id)
    assert_equal(t2a.operator,      events[0].trigger_operator)
    assert_equal(t2a.level,         events[0].trigger_level)
    assert_equal(e2.id,             events[0].energy_id)
    assert_equal(e2.observed_level, events[0].observed_level)
    assert_equal(e2.observed_at,    events[0].observed_at)

    assert_equal(device.id,         events[1].device_id)
    assert_equal(t2b.id,            events[1].trigger_id)
    assert_equal(t2b.operator,      events[1].trigger_operator)
    assert_equal(t2b.level,         events[1].trigger_level)
    assert_equal(e2.id,             events[1].energy_id)
    assert_equal(e2.observed_level, events[1].observed_level)
    assert_equal(e2.observed_at,    events[1].observed_at)
  end

  test "build_events, shinya_note" do
    device = devices(:shinya_note)

    # 該当するトリガなし
    assert_equal([], device.build_events)

    # 該当するトリガあり、かつイベント未生成
    t1 = triggers(:shinya_note_ne0)
    e1 = device.energies.create!(:observed_level => 10, :observed_at => Time.local(2009, 1, 2))
    events = device.build_events
    assert_equal(1, events.size)

    assert_equal(device.id,         events[0].device_id)
    assert_equal(t1.id,             events[0].trigger_id)
    assert_equal(t1.operator,       events[0].trigger_operator)
    assert_equal(t1.level,          events[0].trigger_level)
    assert_equal(e1.id,             events[0].energy_id)
    assert_equal(e1.observed_level, events[0].observed_level)
    assert_equal(e1.observed_at,    events[0].observed_at)
  end
end
