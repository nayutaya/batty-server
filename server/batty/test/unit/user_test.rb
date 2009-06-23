# -*- coding: utf-8 -*-

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @klass = User
    @basic = @klass.new(
      :user_token => "0" * 20,
      :nickname   => "nickname")

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
      events(:yuya_cellular_ne50_1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya.events.all.sort_by(&:id))

    expected = [
      events(:shinya_cellular_gt0_1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @shinya.events.all.sort_by(&:id))
  end

  test "has_many :email_addresses" do
    expected = [
      email_addresses(:yuya_gmail),
      email_addresses(:yuya_example),
      email_addresses(:yuya_nayutaya),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya.email_addresses.all(:order => "email_addresses.id ASC"))

    expected = [
      email_addresses(:shinya_example),
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
    @basic.user_token = ""
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

  test "validates_uniqueness_of :user_token, on create" do
    @basic.user_token = @yuya.user_token
    assert_equal(false, @basic.valid?)
  end

  test "validates_uniqueness_of :user_token, on update" do
    @yuya.user_token = @shinya.user_token
    assert_equal(false, @yuya.valid?)
  end

  #
  # フック
  #

  test "before_validation_on_create" do
    token = "0" * 20

    user = User.new
    assert_equal(nil, user.user_token)

    Kagemusha.new(@klass).
      defs(:create_unique_user_token) { token }.
      swap {
        user.save!
      }

    assert_equal(token, user.reload.user_token)
  end

  test "before_validation_on_create, already setting" do
    token = "0" * 20

    user = User.new
    user.user_token = token
    user.save!

    assert_equal(token, user.reload.user_token)
  end

  #
  # クラスメソッド
  #

  test "self.create_unique_user_token, pattern" do
    assert_match(
      @klass::TokenPattern,
      @klass.create_unique_user_token)
  end

  test "self.create_unique_user_token, duplication" do
    dup_token1 = @yuya.user_token
    dup_token2 = @shinya.user_token
    uniq_token = "f" * @klass::TokenLength
    tokens = [dup_token1, dup_token2, uniq_token]

    musha = Kagemusha.new(TokenUtil)
    musha.defs(:create_token) { tokens.shift }
    musha.swap {
      assert_equal(
        uniq_token,
        @klass.create_unique_user_token)
    }
  end
end
