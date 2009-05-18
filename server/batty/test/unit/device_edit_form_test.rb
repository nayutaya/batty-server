
require 'test_helper'

class DeviceEditFormTest < ActiveSupport::TestCase
  def setup
    @klass = DeviceEditForm
    @form  = @klass.new
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
  # インスタンスメソッド
  #

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
