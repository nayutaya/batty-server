
require 'test_helper'

class EmailSignupFormTest < ActiveSupport::TestCase
  def setup
    @klass = EmailSignupForm
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
end
