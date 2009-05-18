
require 'test_helper'

class DeviceEditFormTest < ActiveSupport::TestCase
  def setup
    @klass = DeviceEditForm
    @form  = @klass.new
    @basic = @klass.new(
      :name           => "name",
      :device_icon_id => device_icons(:note).id)
  end

  #
  # 基底クラス
  #

  test "superclass" do
    assert_equal(ActiveForm, @klass.superclass)
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:name,           nil, "1", "1"],
      [:device_icon_id, nil, "1", 1],
    ].each { |name, default, set_value, get_value|
      form = @klass.new
      assert_equal(default, form.__send__(name))
      form.__send__("#{name}=", set_value)
      assert_equal(get_value, form.__send__(name))
    }
  end

  #
  # 検証
  #

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
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

  #
  # インスタンスメソッド
  #

  test "device_icon" do
    @form.device_icon_id = nil
    assert_equal(nil, @form.device_icon)

    @form.device_icon_id = device_icons(:note).id
    assert_equal(device_icons(:note), @form.device_icon)
  end

  test "to_device_hash, empty" do
    expected = {
      :name           => nil,
      :device_icon_id => nil,
    }
    assert_equal(expected, @form.to_device_hash)
  end

  test "to_device_hash, full" do
    @form.attributes = {
      :name           => "a",
      :device_icon_id => 0,
    }
    expected = {
      :name           => "a",
      :device_icon_id => 0,
    }
    assert_equal(expected, @form.to_device_hash)
  end
end
