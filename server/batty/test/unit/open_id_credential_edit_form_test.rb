
require 'test_helper'

class OpenIdCredentialEditFormTest < ActiveSupport::TestCase
  def setup
    @klass = OpenIdCredentialEditForm
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
end
