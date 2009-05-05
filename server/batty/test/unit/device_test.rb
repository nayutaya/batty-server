# -*- coding: utf-8 -*-

require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  def setup
    @yuya_pda      = devices(:yuya_pda)
    @yuya_cellular = devices(:yuya_cellular)
    @shinya_note   = devices(:shinya_note)
  end

  #
  # 関連
  #

  test "has many energies" do
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

  test "has many triggers" do
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

  test "has many events" do
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

  test "belongs to user" do
    assert_equal(
      users(:yuya),
      @yuya_pda.user)

    assert_equal(
      users(:shinya),
      @shinya_note.user)
  end

  test "belongs to device_icon" do
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

  test "name is empty" do
    assert_raise(ActiveRecord::RecordInvalid) do
      Device.create!(:user_id => 1,
                     :device_token => "1" * 20,
                     :device_icon_id => 1)
    end
  end

  test "too long japanese name" do
    assert_raise(ActiveRecord::RecordInvalid) do
      Device.create!(:user_id => 1,
                     :device_token => "1" * 20,
                     :device_icon_id => 1,
                     :name => 'あ' * 51)
    end
  end

  test "too long ascii name" do
    assert_raise(ActiveRecord::RecordInvalid) do
      Device.create!(:user_id => 1,
                     :device_token => "1" * 20,
                     :device_icon_id => 1,
                     :name => 'a' * 51)
    end
  end

  test "device_token is empty" do
    assert_raise(ActiveRecord::RecordInvalid) do
      Device.create!(:user_id => 1,
                     :device_icon_id => 1,
                     :name => 'a' * 50)
    end
  end

  test "device_token is invalid (invalid character)" do
    assert_raise(ActiveRecord::RecordInvalid) do
      Device.create!(:user_id => 1,
                     :device_token => "xxx",
                     :device_icon_id => 1,
                     :name => 'a' * 10)
    end
  end

  test "device_token is invalid (too long)" do
    assert_raise(ActiveRecord::RecordInvalid) do
      Device.create!(:user_id => 1,
                     :device_token => "0" * 21,
                     :device_icon_id => 1,
                     :name => 'a' * 10)
    end
  end

  test "device_token is invalid (too short)" do
    assert_raise(ActiveRecord::RecordInvalid) do
      Device.create!(:user_id => 1,
                     :device_token => "0" * 19,
                     :device_icon_id => 1,
                     :name => 'a' * 10)
    end
  end

  #
  # device_token 生成
  #

  test "create_device_token" do
    10.times do
      d = Device.new do |m|
        m.user_id = 10
        m.device_token = Device.create_device_token
        m.device_icon_id = 1
        m.name = 'a' * 10
      end
      assert d.valid?
    end
  end

  test "create_unique_device_token" do
    Device.create!(:user_id => 1,
                   :device_token => "a" * 20,
                   :device_icon_id => 1,
                   :name => 'a' * 10)
    musha = Kagemusha.new(Device)
    expected = ['a' * 20, 'b' * 20]
    musha.defs(:create_device_token){ expected.shift }
    musha.swap{
      d = Device.new do |m|
        m.user_id = 10
        m.device_token = Device.create_unique_device_token
        m.device_icon_id = 1
        m.name = 'a' * 10
      end
      assert_equal('b'*20, d.device_token)
    }
  end

  #
  # current_energy
  #

  test "current_energy" do
    device = devices(:yuya_pda)
    assert_equal(100, device.current_energy.observed_level)
  end

  test "current_energy without record" do
    device = devices(:shinya_cellular)
    assert_nil(device.current_energy)
  end

end
