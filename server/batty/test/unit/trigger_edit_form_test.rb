
require 'test_helper'

class TriggerEditFormTest < ActiveSupport::TestCase
  def setup
    @klass = TriggerEditForm
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
      [:enable,   nil, "1", true ],
      [:enable,   nil, "0", false],
      [:operator, nil, "1", 1],
      [:level,    nil, "1", 1],
    ].each { |name, default, set_value, get_value|
      form = @klass.new
      assert_equal(default, form.__send__(name))
      form.__send__("#{name}=", set_value)
      assert_equal(get_value, form.__send__(name))
    }
  end
end
