
require 'test_helper'

class SignupControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "signup"}

    assert_routing("/signup", base.merge(:action => "index"))
  end
end
