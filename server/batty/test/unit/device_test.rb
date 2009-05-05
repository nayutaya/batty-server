# -*- coding: utf-8 -*-

require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  def setup
    @klass         = Device
    @basic         = @klass.new(:user_id => 1,
                                :name => "name",
                                :device_token => "1" * 20,
                                :device_icon_id => 10)
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

  test "all fixtures are valid" do
    assert @klass.all.all?(&:valid?)
  end

  test "name is empty" do
    @basic.name = nil
    assert(!@basic.valid?)
  end

  test "too long japanese name" do
    @basic.name = 'あ' * 51
    assert(!@basic.valid?)
  end

  test "too long ascii name" do
    @basic.name = 'a' * 51
    assert(!@basic.valid?)
  end

  test "device_token is empty" do
    @basic.device_token = nil
    assert(!@basic.valid?)
  end

  test "device_token is invalid (invalid character)" do
    @basic.device_token = 'xxx'
    assert(!@basic.valid?)
  end

  test "device_token is invalid (too long)" do
    @basic.device_token = '0' * 21
    assert(!@basic.valid?)
  end

  test "device_token is invalid (too short)" do
    @basic.device_token = '0' * 19
    assert(!@basic.valid?)
  end

  #
  # device_token 生成
  #

  test "create_unique_device_token" do
    musha = Kagemusha.new(TokenUtil)
    tokens = [ devices(:yuya_pda).device_token, 'b' * 20]
    musha.defs(:create_token){ tokens.shift }
    musha.swap{
      assert_equal('b'*20, @klass.create_unique_device_token)
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
