
require 'test_helper'

class HttpActionEditFormTest < ActiveSupport::TestCase
  def setup
    @klass = HttpActionEditForm
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
      [:enable,      nil, "1", true ],
      [:enable,      nil, "0", false],
      [:http_method, nil, "1", "1"],
      [:url,         nil, "1", "1"],
      [:body,        nil, "1", "1"],
    ].each { |name, default, set_value, get_value|
      form = @klass.new
      assert_equal(default, form.__send__(name), name)
      form.__send__("#{name}=", set_value)
      assert_equal(get_value, form.__send__(name), name)
    }
  end
end
