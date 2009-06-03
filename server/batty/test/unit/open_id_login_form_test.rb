
require 'test_helper'

class OpenIdLoginFormTest < ActiveSupport::TestCase
  def setup
    @klass = OpenIdLoginForm
    @basic = @klass.new(
      :openid_url => "example.jp")
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
      [:openid_url, nil, "1", "1"],
    ].each { |name, default, set_value, get_value|
      form = @klass.new
      assert_equal(default, form.__send__(name), name)
      form.__send__("#{name}=", set_value)
      assert_equal(get_value, form.__send__(name), name)
    }
  end

  #
  # 検証
  #

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :openid_url" do
    @basic.openid_url = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_length_of :openid_url" do
    [
      ["a" *   1, true ],
      ["a" * 200, true ],
      ["a" * 201, false],
    ].each { |value, expected|
      @basic.openid_url = value
      assert_equal(expected, @basic.valid?, value)
    }
  end
end
