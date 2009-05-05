
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

  test "has many open_id_credentials" do
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

  test "has many email_credentials" do
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

  test "has many devices" do
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

  test "has many energies through by devices" do
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

  test "has many events through by devices" do
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

  #
  # 検証
  #

  test "all fixtures are valid" do
    assert_equal(true, @klass.all.all?(&:valid?))
  end

  test "validates_presence_of :user_token" do
    @basic.user_token = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_length_of :nickname" do
    @basic.nickname = ""
    assert_equal(true, @basic.valid?)

    @basic.nickname = "あ" * 40
    assert_equal(true, @basic.valid?)

    @basic.nickname = "あ" * 41
    assert_equal(false, @basic.valid?)
  end

  test "validates_format_of :user_token" do
    @basic.user_token = "0123456789abcdef0000"
    assert_equal(true, @basic.valid?)

    @basic.user_token = "0" * 20
    assert_equal(true, @basic.valid?)

    @basic.user_token = "0" * 19
    assert_equal(false, @basic.valid?)

    @basic.user_token = "0" * 21
    assert_equal(false, @basic.valid?)

    @basic.user_token = "0" * 19 + "A"
    assert_equal(false, @basic.valid?)

    @basic.user_token = "0" * 19 + "g"
    assert_equal(false, @basic.valid?)
  end
end
