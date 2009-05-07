# -*- coding: utf-8 -*-

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @klass = User
    @basic = @klass.new(
      :user_token => "0" * 20,
      :nickname   => "name")

    @yuya   = users(:yuya)
    @shinya = users(:shinya)
    @risa   = users(:risa)
  end

  #
  # 関連
  #

  test "has_many :open_id_credentials" do
    expected = [
      open_id_credentials(:yuya_livedoor),
      open_id_credentials(:yuya_mixi),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya.open_id_credentials.all(:order => "open_id_credentials.id ASC"))

    expected = [
      open_id_credentials(:shinya_example),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @shinya.open_id_credentials.all(:order => "open_id_credentials.id ASC"))
  end

  test "has_many :email_credentials" do
    expected = [
      email_credentials(:yuya_gmail),
      email_credentials(:yuya_nayutaya),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya.email_credentials.all(:order => "email_credentials.id ASC"))

    expected = [
      email_credentials(:risa_example),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @risa.email_credentials.all(:order => "email_credentials.id ASC"))
  end

  test "has_many :devices" do
    expected = [
      devices(:yuya_pda),
      devices(:yuya_cellular),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya.devices.all(:order => "devices.id ASC"))

    expected = [
      devices(:shinya_note),
      devices(:shinya_cellular),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @shinya.devices.all(:order => "devices.id ASC"))
  end

  test "has_many :energies, :through => :devices" do
    expected = [
      energies(:yuya_pda1),
      energies(:yuya_pda2),
      energies(:yuya_pda3),
      energies(:yuya_cellular1),
      energies(:yuya_cellular2),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya.energies.all(:order => "energies.id ASC"))

    expected = [
      energies(:shinya_note1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @shinya.energies.all(:order => "energies.id ASC"))
  end

  test "has_many :events, :through => :devices" do
    expected = [
      events(:yuya_pda_ge90_1),
      events(:yuya_pda_eq100_1),
      events(:yuya_cellular_lt40_1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya.events.all(:order => "events.id ASC"))

    expected = []
    assert_equal(
      expected.sort_by(&:id),
      @shinya.events.all(:order => "events.id ASC"))
  end

  test "has_many :email_addresses" do
    expected = [
      email_addresses(:yuya1),
      email_addresses(:yuya2),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya.email_addresses.all(:order => "email_addresses.id ASC"))

    expected = [
      email_addresses(:shinya1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @shinya.email_addresses.all(:order => "email_addresses.id ASC"))
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

  test "validates_presence_of :user_token" do
    @basic.user_token = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_length_of :nickname" do
    [
      ["",        true ],
      ["あ" * 40, true ],
      ["あ" * 41, false],
    ].each { |value, expected|
      @basic.nickname = value
      assert_equal(expected, @basic.valid?)
    }
  end

  test "validates_format_of :user_token" do
    [
      ["0123456789abcdef0000", true ],
      ["0" * 19,               false],
      ["0" * 20,               true ],
      ["0" * 21,               false],
      ["0" * 19 + "A",         false],
      ["0" * 19 + "g",         false],
    ].each { |value, expected|
      @basic.user_token = value
      assert_equal(expected, @basic.valid?)
    }
  end

  #
  # クラスメソッド
  #

  test "create_unique_user_token" do
    tokens = [users(:yuya).user_token, "b" * 20]
    musha = Kagemusha.new(TokenUtil)
    musha.defs(:create_token) { tokens.shift }
    musha.swap {
      assert_equal(
        "b" * 20,
        @klass.create_unique_user_token)
    }
  end
end
