
require 'test_helper'

class EmailLoginFormTest < ActiveSupport::TestCase
  def setup
    @klass = EmailLoginForm
    @form  = @klass.new
    @basic = @klass.new(
      :email    => "email@example.jp",
      :password => "password")
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
      [:email,    nil, "str", "str"],
      [:password, nil, "str", "str"],
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

  #
  # インスタンスメソッド
  #

  test "authenticate, success" do
    @form.email    = email_credentials(:yuya_gmail).email
    @form.password = "yuya_gmail"
    assert_equal(
      email_credentials(:yuya_gmail),
      @form.authenticate)
  end

  test "authenticate, not activated" do
    @form.email    = email_credentials(:yuya_nayutaya).email
    @form.password = "yuya_nayutaya"
    assert_equal(nil, @form.authenticate)
  end

  test "authenticate, empty" do
    assert_equal(nil, @form.authenticate)
  end
end
