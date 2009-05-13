
require 'test_helper'

class EmailSignupFormTest < ActiveSupport::TestCase
  def setup
    @klass = EmailSignupForm
    @basic = @klass.new(
      :email                 => "basic@example.com",
      :password              => "password",
      :password_confirmation => "password")
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:email,                 nil, "str", "str"],
      [:password,              nil, "str", "str"],
      [:password_confirmation, nil, "str", "str"],
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

  test "validates_presence_of :email" do
    @basic.email = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :password" do
    @basic.password = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :password_confirmation" do
    @basic.password_confirmation = nil
    assert_equal(false, @basic.valid?)
  end
end
