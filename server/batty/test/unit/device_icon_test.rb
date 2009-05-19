
require 'test_helper'

class DeviceIconTest < ActiveSupport::TestCase
  def setup
    @klass = DeviceIcon
    @basic = @klass.new(
      :display_order => 0,
      :name          => "name",
      :url24         => "url24",
      :url48         => "url48")

    @pda      = device_icons(:pda)
    @cellular = device_icons(:cellular)
  end

  #
  # 関連
  #

  test "has_many :devices" do
    expected = [
      devices(:yuya_pda),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @pda.devices.all(:order => "devices.id ASC"))

    expected = [
      devices(:yuya_cellular),
      devices(:shinya_cellular),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @cellular.devices.all(:order => "devices.id ASC"))
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

  test "validates_presence_of :display_order" do
    @basic.display_order = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :name" do
    @basic.name = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :url24" do
    @basic.url24 = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :url48" do
    @basic.url48 = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_length_of :name" do
    [
      ["あ" *  1, true ],
      ["あ" * 30, true ],
      ["あ" * 31, false],
    ].each { |value, expected|
      @basic.name = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  test "validates_length_of :url24" do
    [
      ["a" *   1, true ],
      ["a" * 200, true ],
      ["a" * 201, false],
    ].each { |value, expected|
      @basic.url24 = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  test "validates_length_of :url48" do
    [
      ["a" *   1, true ],
      ["a" * 200, true ],
      ["a" * 201, false],
    ].each { |value, expected|
      @basic.url48 = value
      assert_equal(expected, @basic.valid?, value)
    }
  end
end
