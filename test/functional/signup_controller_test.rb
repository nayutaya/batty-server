
require 'test_helper'

class SignupControllerTest < ActionController::TestCase
  test "routes" do
    base = {:controller => "signup"}

    assert_routing("/signup", base.merge(:action => "index"))
  end

  test "GET index" do
    get :index

    assert_response(:success)
    assert_template("index")
  end
end
